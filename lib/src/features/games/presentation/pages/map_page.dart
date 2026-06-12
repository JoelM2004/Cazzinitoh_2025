import 'dart:convert';
import 'dart:ui' as ui;

import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/core/points/points.dart';
import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/game_bloc.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/current_location_market.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/destination_marker.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_header.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_stats.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ll;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _loadingRoute = false;
  double _currentZoom = 14.0;
  bool _gameInitialized = false;

  // Cache de BitmapDescriptors para no regenerarlos cada tick
  BitmapDescriptor? _currentLocationIcon;

  // ────────────────────────────────────────────────────────────
  // Lifecycle
  // ────────────────────────────────────────────────────────────

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_gameInitialized) {
      _gameInitialized = true;

      final points = PointsSrc.points.map((p) => p.copyWith(
        timeRemaining: 60,
        totalTime: 60,
        isActive: false,
        isCompleted: false,
      )).toList();

      context.read<GameBloc>().add(GameStarted(
        points: points,
        sequenceIds: points.map((p) => p.id).toList(),
        userId: Session.currentUser?.id ?? '',
      ));
    }
  }

  // ────────────────────────────────────────────────────────────
  // Convertir widget a BitmapDescriptor para Google Maps
  // ────────────────────────────────────────────────────────────

  Future<BitmapDescriptor> _widgetToBitmap(Widget widget, {double pixelRatio = 2.0}) async {
    final repaintKey = GlobalKey();

    // Renderizamos el widget off-screen
    final renderWidget = RepaintBoundary(
      key: repaintKey,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: widget),
        ),
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner(focusManager: FocusManager());
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: pipelineOwner.rootNode as RenderView,
      child: renderWidget,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    // Alternativa más simple y confiable: usar WidgetsApp + toImage
    // Usamos el approach de Overlay en vez del pipeline manual
    final controller = OverlayEntry(
      builder: (_) => Positioned(
        left: -9999,
        top: -9999,
        child: RepaintBoundary(key: repaintKey, child: widget),
      ),
    );

    Overlay.of(context).insert(controller);
    await Future.delayed(const Duration(milliseconds: 50));

    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      controller.remove();
      return BitmapDescriptor.defaultMarker;
    }

    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    controller.remove();

    if (byteData == null) return BitmapDescriptor.defaultMarker;

    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }

  // ────────────────────────────────────────────────────────────
  // Markers
  // ────────────────────────────────────────────────────────────

  Future<void> _rebuildMarkersAndPolylines(GameState state) async {
    final newMarkers = <Marker>{};
    final newPolylines = <Polyline>{};

    // ── Marker de ubicación actual ──
    _currentLocationIcon ??= await _widgetToBitmap(
      const CurrentLocationMarkerWidget(),
    );

    newMarkers.add(Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(state.currentLocation.latitude, state.currentLocation.longitude),
      icon: _currentLocationIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      anchor: const Offset(0.5, 0.5),
    ));

    // ── Markers de puntos ──
    final hasActive = state.points.any((p) => p.isActive && !p.isCompleted);

    for (int i = 0; i < state.points.length; i++) {
      final point = state.points[i];

      // Nunca mostrar los completados
      if (point.isCompleted) continue;

      // Durante memorizing: mostrar todos. Durante navigating: si hay uno activo,
      // solo mostrar el activo; si no hay ninguno activo, mostrar todos los pendientes.
      final showMarker = state.phase == GamePhase.memorizing ||
          state.phase == GamePhase.waiting ||
          point.isActive ||
          !hasActive;

      if (!showMarker) continue;

      final icon = await _widgetToBitmap(
        DestinationMarkerWidget(
          order: i + 1,
          title: point.name,
          timeRemaining: point.timeRemaining,
          totalTime: point.totalTime,
          isActive: point.isActive,
          isCompleted: false,
          imageUrl: point.imageUrls.isNotEmpty ? point.imageUrls.first : null,
          onTap: () {},
        ),
      );

      newMarkers.add(Marker(
        markerId: MarkerId('point_${point.id}'),
        position: LatLng(point.coords.latitude, point.coords.longitude),
        icon: icon,
        anchor: const Offset(0.5, 1.0),
        onTap: () => _onPointTapped(point, state),
      ));
    }

    // ── Polilínea (solo memorizing) ──
    if (state.phase == GamePhase.memorizing && state.points.isNotEmpty) {
      final allCoords = <LatLng>[
        LatLng(state.currentLocation.latitude, state.currentLocation.longitude),
        ...state.points
            .where((p) => !p.isCompleted)
            .map((p) => LatLng(p.coords.latitude, p.coords.longitude)),
      ];
      newPolylines.add(Polyline(
        polylineId: const PolylineId('simple_route'),
        points: allCoords,
        color: AppColors.purple500.withOpacity(0.5),
        width: 3,
      ));
    }

    if (mounted) {
      setState(() {
        _markers..clear()..addAll(newMarkers);
        _polylines..clear()..addAll(newPolylines);
      });
    }
  }

  // ────────────────────────────────────────────────────────────
  // Tap en punto
  // ────────────────────────────────────────────────────────────

  void _onPointTapped(Point point, GameState state) {
    if (state.phase != GamePhase.navigating) return;
    if (point.isCompleted) return;

    // Si ya hay un punto activo, no se puede seleccionar otro
    final hasActive = state.points.any((p) => p.isActive && !p.isCompleted);
    if (hasActive && !point.isActive) {
      _showSnackbar('Primero llegá al punto que seleccionaste');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => _PointDialog(
        point: point,
        onConfirm: () {
          Navigator.pop(ctx);
          context.read<GameBloc>().add(PointSelected(point.id));
          _getOSRMRoute(state.currentLocation, point.coords);
        },
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // OSRM
  // ────────────────────────────────────────────────────────────

  Future<void> _getOSRMRoute(ll.LatLng origin, ll.LatLng destination) async {
    setState(() => _loadingRoute = true);

    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/'
      '${origin.longitude},${origin.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routes = data['routes'] as List?;

        if (routes != null && routes.isNotEmpty) {
          final coords = routes[0]['geometry']['coordinates'] as List;
          final routePoints = coords
              .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
              .toList();

          if (mounted) {
            setState(() {
              _polylines.removeWhere((p) => p.polylineId == const PolylineId('osrm_route'));
              _polylines.add(Polyline(
                polylineId: const PolylineId('osrm_route'),
                points: routePoints,
                color: AppColors.purple300,
                width: 5,
              ));
            });
          }

          final bounds = _boundsFromPoints(routePoints);
          _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
        }
      } else {
        _showSnackbar('Sin conexión: no se pudo calcular la ruta');
      }
    } catch (_) {
      _showSnackbar('Error al calcular la ruta');
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude, maxLat = points.first.latitude;
    double minLng = points.first.longitude, maxLng = points.first.longitude;
    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _showSnackbar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ────────────────────────────────────────────────────────────
  // Quiz — lanzado automáticamente cuando el bloc detecta llegada
  // ────────────────────────────────────────────────────────────

  Future<void> _launchQuizForPoint(Point point) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.quiz,
      arguments: {'pointId': point.id, 'pointName': point.name},
    );

    if (!mounted) return;

    final bool correct = result == true;
    context.read<GameBloc>().add(QuestionAnswered(point.id, correct));
  }

  // ────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (prev, curr) =>
          prev.phase != curr.phase ||
          prev.selectedPointId != curr.selectedPointId ||
          prev.completedCount != curr.completedCount ||
          prev.currentLocation != curr.currentLocation,
      listener: (context, state) {
        _rebuildMarkersAndPolylines(state);

        // Quiz automático cuando el bloc detecta llegada
        if (state.phase == GamePhase.answering && state.selectedPointId != null) {
          final point = state.points.firstWhere(
            (p) => p.id == state.selectedPointId,
            orElse: () => state.points.first,
          );
          _launchQuizForPoint(point);
        }

        if (state.phase == GamePhase.finished) {
          Navigator.pushReplacementNamed(context, AppRoutes.stats);
        }

        if (state.phase == GamePhase.error) {
          _showSnackbar(state.errorMessage ?? 'Error desconocido');
        }
      },
      buildWhen: (prev, curr) =>
          prev.phase != curr.phase ||
          prev.score != curr.score ||
          prev.completedCount != curr.completedCount ||
          prev.memorizingSecondsLeft != curr.memorizingSecondsLeft ||
          prev.selectedPointId != curr.selectedPointId ||
          prev.zoom != curr.zoom,
      builder: (context, state) {
        // Puntos disponibles para el carrusel: solo los no completados
        final availablePoints = state.points
            .asMap()
            .entries
            .where((e) => !e.value.isCompleted)
            .toList();

        final hasActive = state.points.any((p) => p.isActive && !p.isCompleted);

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.purpleBackground,
                  AppColors.purple900,
                  AppColors.purpleBackground,
                ],
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    GameHeader(
                      onMenuClick: () => _showSnackbar('Menú presionado'),
                      onSettingsClick: () => _showSnackbar('Configuración presionada'),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                state.currentLocation.latitude,
                                state.currentLocation.longitude,
                              ),
                              zoom: state.zoom,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _rebuildMarkersAndPolylines(state);
                            },
                            markers: _markers,
                            polylines: _polylines,
                            myLocationEnabled: false, // usamos nuestro marker custom
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            onCameraMove: (pos) => _currentZoom = pos.zoom,
                          ),

                          // Cargando ruta
                          if (_loadingRoute)
                            Positioned(
                              top: 16, left: 0, right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.purpleBackground.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16, height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.purple500),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Calculando ruta...', style: TextStyle(color: Colors.white, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // Zoom buttons
                          Positioned(
                            top: 16, right: 16,
                            child: Column(
                              children: [
                                _ZoomButton(icon: Icons.add, onTap: () {
                                  context.read<GameBloc>().add(ZoomInRequested());
                                  _mapController?.animateCamera(CameraUpdate.zoomIn());
                                }),
                                const SizedBox(height: 8),
                                _ZoomButton(icon: Icons.remove, onTap: () {
                                  context.read<GameBloc>().add(ZoomOutRequested());
                                  _mapController?.animateCamera(CameraUpdate.zoomOut());
                                }),
                              ],
                            ),
                          ),

                          // Zoom %
                          Positioned(
                            bottom: 16, left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.purpleBackground.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.purple500.withOpacity(0.3)),
                              ),
                              child: Text(
                                '${(_currentZoom * 100 / 15).round()}%',
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'monospace'),
                              ),
                            ),
                          ),

                          // Botones acción
                          Positioned(
                            bottom: 16, right: 16,
                            child: Column(
                              children: [
                                _ActionButton(
                                  icon: Icons.my_location,
                                  color: AppColors.purple700,
                                  onTap: () => _mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(state.currentLocation.latitude, state.currentLocation.longitude),
                                      state.zoom,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _ActionButton(
                                  icon: Icons.refresh,
                                  color: AppColors.purple900,
                                  onTap: () => _rebuildMarkersAndPolylines(state),
                                ),
                              ],
                            ),
                          ),

                          // Carrusel: solo puntos NO completados, se traban si hay activo
                          if (state.phase == GamePhase.navigating && availablePoints.isNotEmpty)
                            Positioned(
                              bottom: 80, left: 0, right: 0,
                              child: SizedBox(
                                height: 90,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(left: 12),
                                  itemCount: availablePoints.length,
                                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                                  itemBuilder: (ctx, i) {
                                    final entry = availablePoints[i];
                                    final point = entry.value;
                                    final originalOrder = entry.key + 1;
                                    final isLocked = hasActive && !point.isActive;

                                    return _PointChip(
                                      order: originalOrder,
                                      point: point,
                                      isLocked: isLocked,
                                      onTap: isLocked
                                          ? () => _showSnackbar('Primero llegá al punto activo')
                                          : () => _onPointTapped(point, state),
                                    );
                                  },
                                ),
                              ),
                            ),

                          // Indicador de distancia al punto activo
                          if (state.phase == GamePhase.navigating && hasActive)
                            Positioned(
                              top: 16, left: 16,
                              child: _DistanceIndicator(
                                currentLocation: state.currentLocation,
                                points: state.points,
                                selectedPointId: state.selectedPointId,
                              ),
                            ),
                        ],
                      ),
                    ),

                    GameStats(
                      score: state.score,
                      completedPoints: state.completedCount,
                      totalPoints: state.totalCount,
                      timeElapsed: state.formatGameTime(),
                    ),
                  ],
                ),

                // Overlay: waiting
                if (state.phase == GamePhase.waiting)
                  _WaitingOverlay(
                    onStart: () => context.read<GameBloc>().add(MemorizingStarted()),
                  ),

                // Overlay: memorizing
                if (state.phase == GamePhase.memorizing)
                  _MemorizingOverlay(secondsLeft: state.memorizingSecondsLeft),

                // Overlay: saving
                if (state.phase == GamePhase.saving)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.purple500),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// ────────────────────────────────────────────────────────────
// Indicador de distancia al punto activo
// ────────────────────────────────────────────────────────────

class _DistanceIndicator extends StatelessWidget {
  final ll.LatLng currentLocation;
  final List<Point> points;
  final int? selectedPointId;

  const _DistanceIndicator({
    required this.currentLocation,
    required this.points,
    required this.selectedPointId,
  });

  double _distanceMeters(ll.LatLng a, ll.LatLng b) {
    const earthRadius = 6371000.0;
    final dLat = (b.latitude - a.latitude) * (3.14159265358979 / 180);
    final dLon = (b.longitude - a.longitude) * (3.14159265358979 / 180);
    final sinDLat = (dLat / 2);
    final sinDLon = (dLon / 2);
    final c = sinDLat * sinDLat +
        (a.latitude * (3.14159265358979 / 180)).abs() *
            (b.latitude * (3.14159265358979 / 180)).abs() *
            sinDLon *
            sinDLon;
    return earthRadius * 2 * c;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedPointId == null) return const SizedBox.shrink();

    final target = points.firstWhere(
      (p) => p.id == selectedPointId,
      orElse: () => points.first,
    );

    final dist = _distanceMeters(currentLocation, target.coords);
    final distText = dist < 1000
        ? '${dist.round()} m'
        : '${(dist / 1000).toStringAsFixed(1)} km';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.purpleBackground.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple500.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_walk, color: AppColors.purple400, size: 18),
          const SizedBox(width: 6),
          Text(
            distText,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'monospace'),
          ),
          const SizedBox(width: 6),
          Text(
            '· ${target.name}',
            style: const TextStyle(color: AppColors.purple300, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Chip de punto (con estado locked)
// ──────────────────────────────────────────────────────────────

class _PointChip extends StatelessWidget {
  final int order;
  final Point point;
  final bool isLocked;
  final VoidCallback onTap;
  const _PointChip({required this.order, required this.point, required this.isLocked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = point.isActive
        ? AppColors.purple700
        : isLocked
            ? AppColors.darkSecondary.withOpacity(0.5)
            : AppColors.darkSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.92),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: point.isActive
                  ? AppColors.purple300
                  : isLocked
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.1),
            ),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white.withOpacity(0.15),
                child: isLocked
                    ? const Icon(Icons.lock, color: Colors.white54, size: 14)
                    : Text('$order', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      point.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      point.isActive ? '● Navegando' : isLocked ? 'Esperando...' : 'Pendiente',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Overlays ──────────────────────────────────────────────────

class _WaitingOverlay extends StatelessWidget {
  final VoidCallback onStart;
  const _WaitingOverlay({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.purpleCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.purple500, width: 2),
            boxShadow: [BoxShadow(color: AppColors.purple500.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, color: AppColors.purple400, size: 64),
              const SizedBox(height: 16),
              const Text('Memory Trip', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Tendrás 60 segundos para memorizar los puntos del recorrido.\nLuego deberás encontrarlos en el mapa.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.darkMutedForeground, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('¡Comenzar!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemorizingOverlay extends StatelessWidget {
  final int secondsLeft;
  const _MemorizingOverlay({required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 80, left: 24, right: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.purpleBackground.withOpacity(0.92),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.purple500.withOpacity(0.6)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.remove_red_eye_outlined, color: AppColors.purple400, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Memoriza el recorrido — ${secondsLeft}s',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PointDialog extends StatelessWidget {
  final Point point;
  final VoidCallback onConfirm;
  const _PointDialog({required this.point, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.purpleCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.purpleCardBorder),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(point.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Text(point.description, style: const TextStyle(color: AppColors.darkMutedForeground, fontSize: 14)),
            const SizedBox(height: 8),
            const Text('¿Es este el punto que querés ir?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: AppColors.purple400)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Ir', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.darkSecondary.withOpacity(0.9),
      borderRadius: BorderRadius.circular(25),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(width: 50, height: 50, child: Icon(icon, color: Colors.white, size: 24)),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.9),
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(width: 56, height: 56, child: Icon(icon, color: Colors.white, size: 28)),
      ),
    );
  }
}
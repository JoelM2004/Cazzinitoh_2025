import 'dart:convert';
import 'dart:math';

import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/game_bloc.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_header.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_stats.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/game/difficulty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  // ── Google Maps controller ───────────────────────────────────────────────
  GoogleMapController? _mapController;
  bool _mapReady = false;

  // ── Markers y polylines ──────────────────────────────────────────────────
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // ── Secuencia de puntos ──────────────────────────────────────────────────
  List<int> _randomSecuenciaIds = [];
  int? _pointResaltadoId;
  bool _secuenciaReproducida = false;

  // ── Ruta OSRM ────────────────────────────────────────────────────────────
  bool _loadingRoute = false;

  // ── Zoom inicial ─────────────────────────────────────────────────────────
  double _currentZoom = 14.0;

  // ────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ────────────────────────────────────────────────────────────────────────

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && !_secuenciaReproducida) {
      final Difficulty difficulty =
          args['difficulty'] as Difficulty? ?? Difficulty.medium;
      _startSequenceForDifficulty(difficulty);
    }
  }

  // ────────────────────────────────────────────────────────────────────────
  // Google Maps callbacks
  // ────────────────────────────────────────────────────────────────────────

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() => _mapReady = true);
    _rebuildMarkersAndPolylines();
  }

  // ────────────────────────────────────────────────────────────────────────
  // Markers y polylines
  // ────────────────────────────────────────────────────────────────────────

  void _rebuildMarkersAndPolylines() {
    final state = context.read<GameBloc>().state;
    final newMarkers = <Marker>{};
    final newPolylines = <Polyline>{};

    newMarkers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          state.currentLocation.latitude,
          state.currentLocation.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        infoWindow: const InfoWindow(title: 'Tu ubicación'),
      ),
    );

    for (final point in state.points) {
      final hue = point.isCompleted
          ? BitmapDescriptor.hueGreen
          : point.isActive
              ? BitmapDescriptor.hueViolet
              : BitmapDescriptor.hueAzure;

      newMarkers.add(
        Marker(
          markerId: MarkerId('point_${point.id}'),
          position: LatLng(point.coords.latitude, point.coords.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(title: point.name),
          onTap: () {
            if (point.isActive || point.isCompleted) {
              _showPointDialog(
                context,
                point.id,
                point.name,
                point.description,
                point.imageUrls,
                point.coords,
              );
            }
          },
        ),
      );
    }

    if (state.points.isNotEmpty) {
      final allCoords = <LatLng>[
        LatLng(
          state.currentLocation.latitude,
          state.currentLocation.longitude,
        ),
        ...state.points
            .map((p) => LatLng(p.coords.latitude, p.coords.longitude)),
      ];

      newPolylines.add(
        Polyline(
          polylineId: const PolylineId('simple_route'),
          points: allCoords,
          color: Colors.purple.withOpacity(0.4),
          width: 3,
        ),
      );
    }

    setState(() {
      _markers
        ..clear()
        ..addAll(newMarkers);
      _polylines
        ..clear()
        ..addAll(newPolylines);
    });
  }

  // ────────────────────────────────────────────────────────────────────────
  // OSRM
  // ────────────────────────────────────────────────────────────────────────

  Future<void> _getOSRMRoute(ll.LatLng origin, ll.LatLng destination) async {
    setState(() => _loadingRoute = true);

    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/'
      '${origin.longitude},${origin.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response =
          await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routes = data['routes'] as List?;

        if (routes != null && routes.isNotEmpty) {
          final coords = routes[0]['geometry']['coordinates'] as List;

          final routePoints = coords
              .map((c) => LatLng(
                    (c[1] as num).toDouble(),
                    (c[0] as num).toDouble(),
                  ))
              .toList();

          setState(() {
            _polylines.removeWhere(
                (p) => p.polylineId == const PolylineId('osrm_route'));
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('osrm_route'),
                points: routePoints,
                color: Colors.purple.shade200,
                width: 5,
              ),
            );
          });

          final bounds = _boundsFromPoints(routePoints);
          _mapController?.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 80),
          );
        }
      } else {
        _showNoRouteSnackbar();
      }
    } catch (_) {
      _showNoRouteSnackbar();
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  void _showNoRouteSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sin conexión: no se pudo calcular la ruta por calles'),
        backgroundColor: Colors.red,
      ),
    );
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

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

  // ────────────────────────────────────────────────────────────────────────
  // Diálogo de punto
  // ────────────────────────────────────────────────────────────────────────

  void _showPointDialog(
    BuildContext context,
    int id,
    String name,
    String description,
    List<String> imageUrls,
    ll.LatLng pointCoords,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 48,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                // Contenido scrollable
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrls.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              imageUrls.first,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 180,
                                color: Colors.grey.shade800,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          description,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '¿Ir a este punto?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Botones
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.purple.shade300),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // FIX: PointActivated → PointSelected
                          context.read<GameBloc>().add(PointSelected(id));
                          Navigator.pop(dialogContext);
                          final state = context.read<GameBloc>().state;
                          _getOSRMRoute(state.currentLocation, pointCoords);
                          _rebuildMarkersAndPolylines();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Ir'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────
  // Secuencia de puntos
  // ────────────────────────────────────────────────────────────────────────

  List<int> _pickRandomSequenceIds(List<Point> points, int k) {
    final rng = Random();
    final indices = List<int>.generate(points.length, (i) => i);
    indices.shuffle(rng);
    return indices.take(k).map((i) => points[i].id).toList();
  }

  Future<void> _startSequenceForDifficulty(Difficulty difficulty) async {
    if (_secuenciaReproducida) return;
    _secuenciaReproducida = true;

    final state = context.read<GameBloc>().state;
    final allPoints = List<Point>.from(state.points);

    final int k = (difficulty == Difficulty.easy) ? 3 : 4;
    if (allPoints.isEmpty) return;

    _randomSecuenciaIds = allPoints.length <= k
        ? allPoints.map((p) => p.id).toList()
        : _pickRandomSequenceIds(allPoints, k);

    const showDuration = Duration(seconds: 2);
    const interPause = Duration(milliseconds: 300);

    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Observá la secuencia: memorízala')),
        );
      });
    }

    for (final id in _randomSecuenciaIds) {
      if (!mounted) return;
      setState(() => _pointResaltadoId = id);

      try {
        final point = allPoints.firstWhere((p) => p.id == id);
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(point.coords.latitude, point.coords.longitude),
            _currentZoom,
          ),
        );
      } catch (_) {}

      await Future.delayed(showDuration);
      if (!mounted) return;

      setState(() => _pointResaltadoId = null);
      await Future.delayed(interPause);
    }

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.points,
      arguments: {'sequenceIds': _randomSecuenciaIds},
    );

    if (!mounted) return;
    _handleUserChoice(result);
  }

  void _handleUserChoice(dynamic result) {
    if (result == null) return;

    int chosenId;
    if (result is int) {
      chosenId = result;
    } else if (result is Map && result['id'] is int) {
      chosenId = result['id'] as int;
    } else {
      return;
    }

    final state = context.read<GameBloc>().state;
    final chosenPoint = state.points.firstWhere(
      (p) => p.id == chosenId,
      orElse: () => state.points.first,
    );

    final meters = _distanceBetweenLatLng(
      state.currentLocation,
      chosenPoint.coords,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Distancia al punto seleccionado: ${meters.round()} m'),
      ),
    );

    // FIX: también disparar PointSelected al elegir desde la lista
    context.read<GameBloc>().add(PointSelected(chosenId));
    _getOSRMRoute(state.currentLocation, chosenPoint.coords);
  }

  // ────────────────────────────────────────────────────────────────────────
  // Distancia Haversine
  // ────────────────────────────────────────────────────────────────────────

  double _degreesToRadians(double degrees) => degrees * pi / 180.0;

  double _distanceBetweenLatLng(ll.LatLng a, ll.LatLng b) {
    final lat1 = _degreesToRadians(a.latitude);
    final lon1 = _degreesToRadians(a.longitude);
    final lat2 = _degreesToRadians(b.latitude);
    final lon2 = _degreesToRadians(b.longitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final sinDLat = sin(dLat / 2);
    final sinDLon = sin(dLon / 2);
    final aCalc =
        sinDLat * sinDLat + cos(lat1) * cos(lat2) * sinDLon * sinDLon;
    final c = 2 * atan2(sqrt(aCalc), sqrt(1 - aCalc));
    const earthRadius = 6371000;
    return earthRadius * c;
  }

  // ────────────────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              Colors.purple.shade900,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: Column(
          children: [
            GameHeader(
              onMenuClick: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menú presionado'),
                  duration: Duration(seconds: 1),
                ),
              ),
              onSettingsClick: () =>
                  ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Configuración presionada'),
                  duration: Duration(seconds: 1),
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            state.currentLocation.latitude,
                            state.currentLocation.longitude,
                          ),
                          zoom: state.zoom,
                        ),
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        onCameraMove: (pos) {
                          _currentZoom = pos.zoom;
                        },
                      ),

                      if (_mapReady) ..._buildMarkerOverlays(context, state),

                      if (_loadingRoute)
                        Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Calculando ruta...',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      Positioned(
                        top: 16,
                        right: 16,
                        child: Column(
                          children: [
                            _buildZoomButton(
                              icon: Icons.add,
                              onTap: () {
                                context
                                    .read<GameBloc>()
                                    .add(ZoomInRequested());
                                _mapController?.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildZoomButton(
                              icon: Icons.remove,
                              onTap: () {
                                context
                                    .read<GameBloc>()
                                    .add(ZoomOutRequested());
                                _mapController?.animateCamera(
                                  CameraUpdate.zoomOut(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.purple.shade500.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '${(_currentZoom * 100 / 15).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Column(
                          children: [
                            _buildActionButton(
                              icon: Icons.navigation,
                              color: Colors.purple,
                              onTap: () {
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(
                                      state.currentLocation.latitude,
                                      state.currentLocation.longitude,
                                    ),
                                    state.zoom,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildActionButton(
                              icon: Icons.bolt,
                              color: Colors.deepPurple,
                              onTap: () => _rebuildMarkersAndPolylines(),
                            ),
                            const SizedBox(height: 12),
                            _buildActionButton(
                              icon: Icons.home,
                              color: Colors.blue,
                              onTap: () {
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(
                                      state.currentLocation.latitude,
                                      state.currentLocation.longitude,
                                    ),
                                    15.0,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                return GameStats(
                  score: state.score,
                  completedPoints: state.completedCount,
                  totalPoints: state.totalCount,
                  timeElapsed: state.formatGameTime(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────
  // Marker overlays
  // ────────────────────────────────────────────────────────────────────────

  List<Widget> _buildMarkerOverlays(BuildContext context, GameState state) {
    if (_pointResaltadoId != null) {
      final highlighted = _findPointById(state.points, _pointResaltadoId!);
      if (highlighted != null) {
        return [
          Positioned(
            bottom: 80,
            left: 16,
            right: 80,
            child: _HighlightedPointBanner(point: highlighted),
          ),
        ];
      }
    }

    return [
      Positioned(
        bottom: 80,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 12),
            itemCount: state.points.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final point = state.points[i];
              return _PointChip(
                order: i + 1,
                point: point,
                onTap: () {
                  if (point.isActive || point.isCompleted) {
                    _showPointDialog(
                      context,
                      point.id,
                      point.name,
                      point.description,
                      point.imageUrls,
                      point.coords,
                    );
                  }
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(point.coords.latitude, point.coords.longitude),
                      16.0,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    ];
  }

  // ────────────────────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────────────────────

  Point? _findPointById(List<Point> points, int id) {
    for (final p in points) {
      if (p.id == id) return p;
    }
    return null;
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey.shade800.withOpacity(0.9),
      borderRadius: BorderRadius.circular(25),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          width: 50,
          height: 50,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.9),
      borderRadius: BorderRadius.circular(28),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Widgets auxiliares
// ──────────────────────────────────────────────────────────────────────────

class _PointChip extends StatelessWidget {
  final int order;
  final Point point;
  final VoidCallback onTap;

  const _PointChip({
    required this.order,
    required this.point,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = point.isCompleted
        ? Colors.green.shade700
        : point.isActive
            ? Colors.purple.shade700
            : Colors.grey.shade800;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.92),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: point.isActive
                ? Colors.purple.shade300
                : Colors.white.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white.withOpacity(0.15),
              child: Text(
                '$order',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    point.isCompleted
                        ? '✓ Completado'
                        : point.isActive
                            ? '● Activo'
                            : 'Bloqueado',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightedPointBanner extends StatelessWidget {
  final Point point;

  const _HighlightedPointBanner({required this.point});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.yellow.shade700.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Colors.black87, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              point.name,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
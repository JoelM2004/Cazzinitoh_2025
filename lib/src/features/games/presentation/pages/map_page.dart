import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/core/points/points.dart';
import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/game_bloc.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_stats.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/game/difficulty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ll;

// ─────────────────────────────────────────────────────────────
// Utilidades
// ─────────────────────────────────────────────────────────────

gm.LatLng _toGm(ll.LatLng p) => gm.LatLng(p.latitude, p.longitude);

int _pointCountForDifficulty(Difficulty d) {
  switch (d) {
    case Difficulty.easy:   return 3;
    case Difficulty.medium: return 5;
    case Difficulty.hard:   return 7;
  }
}

// ─────────────────────────────────────────────────────────────
// Builders de BitmapDescriptor con Canvas
// ─────────────────────────────────────────────────────────────

/// Marker de ubicación actual: círculo azul con ícono persona
Future<gm.BitmapDescriptor> _buildCurrentLocationBitmap() async {
  const size = 110.0;
  const scale = 2.5;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // 🔴 AGREGADO ESCALADO AQUÍ TAMBIÉN
  canvas.scale(scale, scale);

  final center = const Offset(size / 2, size / 2);

  canvas.drawCircle(center, size / 2, Paint()..color = const Color(0xFF00B4FF).withOpacity(0.22));
  canvas.drawCircle(center, 30, Paint()..color = const Color(0xFF00B4FF));
  canvas.drawCircle(
    center,
    30, // Aseguramos que el borde envuelva al radio real de 30
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0,
  );
  canvas.drawCircle(center, 9, Paint()..color = Colors.white);

  final picture = recorder.endRecording();
  final img = await picture.toImage((size * scale).toInt(), (size * scale).toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return gm.BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

/// Marker de punto: pin moderno con imagen y número condicional.
///
/// GEOMETRÍA DEL PIN:
///   - El canvas tiene totalH píxeles de alto.
///   - La punta del triángulo está en Y = circleR * 2 + padding + pinPointerH.
///   - El anchor que pasamos a GoogleMaps es (0.5, puntaY / totalH)
///     → así la punta queda EXACTAMENTE sobre las coordenadas geográficas.
Future<gm.BitmapDescriptor> _buildPointBitmap({
  required int order,
  required String? imageAssetPath,
  required bool isActive,
  required bool showNumber,
}) async {
  const circleR     = 68.0;
  const pinPointerH = 34.0;
  const padTop      = 24.0;
  const padSide     = 24.0;
  const scale       = 2.5;

  final totalW = circleR * 2 + padSide * 2;
  final totalH = padTop + circleR * 2 + pinPointerH;

  final cx = totalW / 2;
  final cy = padTop + circleR;

  final bgColor = isActive ? const Color(0xFFFACC15) : const Color(0xFF7C3AED);

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // 🔴 AQUÍ ESTÁ LA MAGIA QUE FALTABA
  // Esto expande el dibujo para que llene todo el cuadro de alta resolución
  canvas.scale(scale, scale);

  // 1. Sombra bajo el pin (Ajustada para que pise exacto el suelo)
  final shadowPath = Path()
    ..addOval(Rect.fromCenter(
      center: Offset(cx, totalH - 4), // Ligeramente arriba de la punta
      width: circleR * 1.3,
      height: 8,
    ));
  canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.5), 14, true);

  // 2. Forma del pin
  final tipY = totalH; // La punta toca exactamente el borde inferior
  final pinPath = Path()
    ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: circleR))
    ..moveTo(cx - 20, cy + circleR - 10)
    ..lineTo(cx + 20, cy + circleR - 10)
    ..lineTo(cx, tipY)
    ..close();

  canvas.drawPath(pinPath, Paint()..color = bgColor);
  canvas.drawPath(
    pinPath,
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0,
  );

  // 3. Imagen circular
  final innerR = circleR - 10;
  if (imageAssetPath != null) {
    try {
      final data = await rootBundle.load(imageAssetPath);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: ((innerR * 2) * scale).toInt(),
        targetHeight: ((innerR * 2) * scale).toInt(),
      );
      final frame = await codec.getNextFrame();

      canvas.save();
      canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: innerR)));
      canvas.drawImageRect(
        frame.image,
        Rect.fromLTWH(0, 0, frame.image.width.toDouble(), frame.image.height.toDouble()),
        Rect.fromCenter(center: Offset(cx, cy), width: innerR * 2, height: innerR * 2),
        Paint(),
      );
      canvas.restore();
    } catch (_) {
      _drawFallbackCircle(canvas, cx, cy, innerR);
    }
  } else {
    _drawFallbackCircle(canvas, cx, cy, innerR);
  }

  // 4. Badge numérico
  if (showNumber) {
    const badgeR = 22.0;
    final badgeCx = cx + circleR - 14;
    final badgeCy = cy - circleR + 14;

    canvas.drawCircle(Offset(badgeCx, badgeCy + 2), badgeR, Paint()..color = Colors.black38);
    canvas.drawCircle(Offset(badgeCx, badgeCy), badgeR, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(badgeCx, badgeCy),
      badgeR,
      Paint()..color = bgColor..style = PaintingStyle.stroke..strokeWidth = 4.0,
    );

    final numPainter = TextPainter(
      text: TextSpan(
        text: '$order',
        style: TextStyle(color: bgColor, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    numPainter.paint(
      canvas,
      Offset(badgeCx - numPainter.width / 2, badgeCy - numPainter.height / 2),
    );
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage((totalW * scale).toInt(), (totalH * scale).toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return gm.BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

void _drawFallbackCircle(Canvas canvas, double cx, double cy, double r) {
  canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFF1a1033));
}

/// Calcula el anchor Y correcto para que la PUNTA del pin
/// quede exactamente sobre la coordenada geográfica.
///
/// anchor = (0.5, tipY / totalH)  donde tipY es la Y de la punta en píxeles lógicos.
/*Offset _pinAnchor() {
  const circleR    = 52.0;
  const pinPointerH = 22.0;
  const padTop     = 16.0;
  const padSide    = 20.0;

  final totalW = circleR * 2 + padSide * 2;
  final totalH = padTop + circleR * 2 + pinPointerH + 8.0;
  final cy     = padTop + circleR;
  final tipY   = cy + circleR + pinPointerH;

  return Offset(0.5, tipY / totalH);
}*/

// ─────────────────────────────────────────────────────────────
// MapPage
// ─────────────────────────────────────────────────────────────

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  gm.GoogleMapController? _mapController;
  final Set<gm.Marker> _markers = {};
  final Set<gm.Polyline> _polylines = {};

  bool _loadingRoute    = false;
  bool _gameInitialized = false;
  bool _quizInProgress  = false;

  Difficulty _difficulty = Difficulty.medium;
  List<gm.LatLng> _activeRoutePoints = [];

  gm.BitmapDescriptor? _currentLocationBitmap;
  final Map<String, gm.BitmapDescriptor> _pointBitmaps = {};

  // Anchor pre-calculado (constante, no depende del estado)
  // final Offset _pinAnchorOffset = _pinAnchor();

  // ─── Inicialización ─────────────────────────────────────────

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_gameInitialized) {
      _gameInitialized = true;

      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['difficulty'] is Difficulty) {
        _difficulty = args['difficulty'] as Difficulty;
      }

      final count = _pointCountForDifficulty(_difficulty);
      
      final allPoints = List<Point>.from(PointsSrc.points)..shuffle();

      final selectedPoints = allPoints.take(count).map((p) => p.copyWith(
        timeRemaining: 60,
        totalTime: 60,
        isActive: false,
        isCompleted: false,
      )).toList();

      context.read<GameBloc>().add(GameStarted(
        points: selectedPoints,
        sequenceIds: selectedPoints.map((p) => p.id).toList(),
        userId: Session.currentUser?.id ?? '',
      ));
    }
  }

  // ─── Bitmaps ────────────────────────────────────────────────

  Future<void> _ensureBitmaps(GameState state) async {
    _currentLocationBitmap ??= await _buildCurrentLocationBitmap();

    final showNum = state.phase == GamePhase.memorizing || state.phase == GamePhase.waiting;

    for (int i = 0; i < state.points.length; i++) {
      final point = state.points[i];
      if (point.isCompleted) continue;

      final cacheKey = '${point.id}_${point.isActive}_$showNum';
      if (!_pointBitmaps.containsKey(cacheKey)) {
        _pointBitmaps[cacheKey] = await _buildPointBitmap(
          order: i + 1,
          imageAssetPath: point.imageUrls.isNotEmpty ? point.imageUrls.first : null,
          isActive: point.isActive,
          showNumber: showNum,
        );
      }
    }
  }

  // ─── Markers ────────────────────────────────────────────────

  Future<void> _rebuildMarkers(GameState state) async {
    await _ensureBitmaps(state);

    final newMarkers   = <gm.Marker>{};
    final newPolylines = <gm.Polyline>{};
    final hasActive    = state.points.any((p) => p.isActive && !p.isCompleted);
    final showNum      = state.phase == GamePhase.memorizing || state.phase == GamePhase.waiting;

    // Marker de ubicación actual
    newMarkers.add(gm.Marker(
      markerId: const gm.MarkerId('current_location'),
      position: _toGm(state.currentLocation),
      icon: _currentLocationBitmap ?? gm.BitmapDescriptor.defaultMarkerWithHue(210),
      anchor: const Offset(0.5, 0.5),
      zIndex: 10,
      flat: true,
    ));

    // Markers de puntos
    for (int i = 0; i < state.points.length; i++) {
      final point = state.points[i];
      if (point.isCompleted) continue;

      // Durante navegación/respuesta solo mostramos el punto activo
      if (hasActive &&
          !point.isActive &&
          (state.phase == GamePhase.navigating || state.phase == GamePhase.answering)) {
        continue;
      }

      final cacheKey = '${point.id}_${point.isActive}_$showNum';
      final icon = _pointBitmaps[cacheKey] ??
          gm.BitmapDescriptor.defaultMarkerWithHue(gm.BitmapDescriptor.hueViolet);

      newMarkers.add(gm.Marker(
        markerId: gm.MarkerId('point_${point.id}'),
        position: _toGm(point.coords),
        icon: icon,
        // ← PUNTA del pin sobre la coordenada geográfica
        anchor: const Offset(0.5, 1.0), // 0.5 (X centro), 1.0 (Y abajo). Precisión perfecta.
        onTap: () => _onPointTapped(point, state),
      ));
    }

    // Polyline durante memorización
    if (state.phase == GamePhase.memorizing && state.points.isNotEmpty) {
      _fetchMemorizingRoute(state.currentLocation, state.points.where((p) => !p.isCompleted).toList());
    }

    // Ruta OSRM activa
    if (_activeRoutePoints.isNotEmpty) {
      newPolylines.add(gm.Polyline(
        polylineId: const gm.PolylineId('osrm_route'),
        points: _activeRoutePoints,
        color: const Color(0xFF7c3aed),
        width: 5,
        patterns: [gm.PatternItem.dash(20), gm.PatternItem.gap(8)],
      ));
    }

    if (mounted) {
      setState(() {
        _markers
          ..clear()
          ..addAll(newMarkers);
        _polylines
          ..clear()
          ..addAll(newPolylines);
      });
    }
  }

  Future<void> _fetchMemorizingRoute(ll.LatLng origin, List<Point> points) async {
  final allWaypoints = [origin, ...points.map((p) => p.coords)];
  if (allWaypoints.length < 2) return;

  // Construye el string de coordenadas para OSRM
  final coords = allWaypoints
      .map((p) => '${p.longitude},${p.latitude}')
      .join(';');

  final url = Uri.parse(
    'https://router.project-osrm.org/route/v1/foot/$coords'
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
            .map((c) => gm.LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
            .toList();

        if (mounted) {
          setState(() {
            _polylines.removeWhere(
              (p) => p.polylineId == const gm.PolylineId('memorizing_route'),
            );
            _polylines.add(gm.Polyline(
              polylineId: const gm.PolylineId('memorizing_route'),
              points: routePoints,
              color: const Color(0xFF7c3aed).withOpacity(0.6),
              width: 3,
            ));
          });
        }
      }
    }
  } catch (_) {
    // Silenciamos error, no es crítico
  }
}

  void _updateLocationMarkerOnly(GameState state) {
    if (_currentLocationBitmap == null || !mounted) return;
    setState(() {
      _markers.removeWhere((m) => m.markerId == const gm.MarkerId('current_location'));
      _markers.add(gm.Marker(
        markerId: const gm.MarkerId('current_location'),
        position: _toGm(state.currentLocation),
        icon: _currentLocationBitmap!,
        anchor: const Offset(0.5, 0.5),
        zIndex: 10,
        flat: true,
      ));
    });
  }

  // ─── Tap en marker ──────────────────────────────────────────

  void _onPointTapped(Point point, GameState state) {
    if (state.phase != GamePhase.navigating) return;
    if (point.isCompleted) return;

    final hasActive = state.points.any((p) => p.isActive && !p.isCompleted);
    if (hasActive && !point.isActive) {
      _showSnackbar('Primero llegá al punto activo');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => _PointDialog(
        point: point,
        onConfirm: () {
          Navigator.pop(ctx);
          _pointBitmaps.removeWhere((key, _) => key.startsWith('${point.id}_'));
          context.read<GameBloc>().add(PointSelected(point.id));
          _getOSRMRoute(state.currentLocation, point.coords);
        },
      ),
    );
  }

  // ─── OSRM ───────────────────────────────────────────────────

  Future<void> _getOSRMRoute(ll.LatLng origin, ll.LatLng destination) async {
    if (mounted) setState(() => _loadingRoute = true);

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/foot/'
      '${origin.longitude},${origin.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data   = jsonDecode(response.body);
        final routes = data['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final coords = routes[0]['geometry']['coordinates'] as List;
          _activeRoutePoints = coords
              .map((c) => gm.LatLng(
                    (c[1] as num).toDouble(),
                    (c[0] as num).toDouble(),
                  ))
              .toList();

          if (mounted) {
            setState(() {
              _polylines.removeWhere(
                (p) => p.polylineId == const gm.PolylineId('osrm_route'),
              );
              _polylines.add(gm.Polyline(
                polylineId: const gm.PolylineId('osrm_route'),
                points: _activeRoutePoints,
                color: const Color(0xFF7c3aed),
                width: 5,
                patterns: [gm.PatternItem.dash(20), gm.PatternItem.gap(8)],
              ));
            });
            _mapController?.animateCamera(
              gm.CameraUpdate.newLatLngBounds(
                _boundsFromPoints(_activeRoutePoints),
                80,
              ),
            );
          }
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

  void _clearRoute() {
    _activeRoutePoints = [];
    if (mounted) {
      setState(() => _polylines.removeWhere(
            (p) => p.polylineId == const gm.PolylineId('osrm_route'),
          ));
    }
  }

  gm.LatLngBounds _boundsFromPoints(List<gm.LatLng> pts) {
    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final p in pts) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return gm.LatLngBounds(
      southwest: gm.LatLng(minLat, minLng),
      northeast: gm.LatLng(maxLat, maxLng),
    );
  }

  void _showSnackbar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ─── Quiz ───────────────────────────────────────────────────

  Future<void> _launchQuiz(Point point) async {
    _clearRoute();

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.quiz,
      arguments: {'pointId': point.id, 'pointName': point.name},
    );

    _quizInProgress = false;
    if (!mounted) return;

    _pointBitmaps.removeWhere((key, _) => key.startsWith('${point.id}_'));
    context.read<GameBloc>().add(QuestionAnswered(point.id, result == true));
  }

  // ─── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (prev, curr) =>
          prev.phase != curr.phase ||
          prev.selectedPointId != curr.selectedPointId ||
          prev.completedCount != curr.completedCount,

      listener: (context, state) {
        if (state.phase == GamePhase.answering &&
            state.selectedPointId != null &&
            !_quizInProgress) {
          _quizInProgress = true;
          _rebuildMarkers(state);
          final point = state.points.firstWhere(
            (p) => p.id == state.selectedPointId,
            orElse: () => state.points.first,
          );
          _launchQuiz(point);
          return;
        }

        if (state.phase != GamePhase.answering) {
          _rebuildMarkers(state);
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
          prev.gameTimeSeconds != curr.gameTimeSeconds ||
          prev.selectedPointId != curr.selectedPointId ||
          prev.currentLocation != curr.currentLocation,

      builder: (context, state) {
        // Actualizar solo el marker de posición cuando cambia la ubicación
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateLocationMarkerOnly(state);
        });

        final hasActive = state.points.any((p) => p.isActive && !p.isCompleted);

        return Scaffold(
          body: Stack(
            children: [
              // Fondo
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.purpleBackground,
                      AppColors.purple900,
                      Color(0xFF0d0d1a),
                    ],
                  ),
                ),
              ),

              // Mapa
              Positioned.fill(
                bottom: 80,
                child: gm.GoogleMap(
                  initialCameraPosition: gm.CameraPosition(
                    target: _toGm(state.currentLocation),
                    zoom: state.zoom,
                  ),
                  onMapCreated: (c) {
                    _mapController = c;
                    _rebuildMarkers(state);
                  },
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),

              // Stats
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: GameStats(
                  score: state.score,
                  completedPoints: state.completedCount,
                  totalPoints: state.totalCount,
                  timeElapsed: state.formatGameTime(),
                ),
              ),

              // Controles izquierda
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                child: Column(
                  children: [
                    _MapBtn(
                      icon: Icons.my_location,
                      color: const Color(0xFF7c3aed),
                      onTap: () => _mapController?.animateCamera(
                        gm.CameraUpdate.newLatLngZoom(_toGm(state.currentLocation), 17),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _MapBtn(
                      icon: Icons.add,
                      color: Colors.black54,
                      onTap: () => _mapController?.animateCamera(gm.CameraUpdate.zoomIn()),
                    ),
                    const SizedBox(height: 10),
                    _MapBtn(
                      icon: Icons.remove,
                      color: Colors.black54,
                      onTap: () => _mapController?.animateCamera(gm.CameraUpdate.zoomOut()),
                    ),
                    const SizedBox(height: 10),
                    _MapBtn(
                      icon: Icons.refresh,
                      color: Colors.black38,
                      onTap: () {
                        _pointBitmaps.clear();
                        _rebuildMarkers(state);
                      },
                    ),
                  ],
                ),
              ),

              // Chip de distancia (derecha)
              if (state.phase == GamePhase.navigating &&
                  hasActive &&
                  state.selectedPointId != null)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 16,
                  child: _DistanceChip(
                    current: state.currentLocation,
                    target: state.points.firstWhere(
                      (p) => p.id == state.selectedPointId,
                      orElse: () => state.points.first,
                    ),
                  ),
                ),

              // Cargando ruta
              if (_loadingRoute)
                Positioned(
                  bottom: 100, left: 0, right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14, height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF7c3aed),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Calculando ruta...',
                              style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),

              // Overlays
              if (state.phase == GamePhase.waiting)
                _WaitingOverlay(
                  difficulty: _difficulty,
                  onStart: () => context.read<GameBloc>().add(MemorizingStarted()),
                ),

              if (state.phase == GamePhase.memorizing)
                _MemorizingOverlay(secondsLeft: state.memorizingSecondsLeft),

              if (state.phase == GamePhase.saving)
                Container(
                  color: Colors.black.withOpacity(0.6),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7c3aed)),
                  ),
                ),
            ],
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

// ─────────────────────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────────────────────

class _DistanceChip extends StatelessWidget {
  final ll.LatLng current;
  final Point target;
  const _DistanceChip({required this.current, required this.target});

  double _dist() {
    const r = 6371000.0;
    final dLat = (target.coords.latitude - current.latitude) * (pi / 180);
    final dLon = (target.coords.longitude - current.longitude) * (pi / 180);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(current.latitude * pi / 180) *
            cos(target.coords.latitude * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  @override
  Widget build(BuildContext context) {
    final d    = _dist();
    final text = d < 1000 ? '${d.round()} m' : '${(d / 1000).toStringAsFixed(1)} km';
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7c3aed).withOpacity(0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_walk, color: Color(0xFFc4b5fd), size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '$text · ${target.name}',
              style: const TextStyle(color: Colors.white, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MapBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44, height: 44,
          child: Icon(icon, color: Colors.white, size: 20),
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
          color: const Color(0xFF1a1033),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4c1d95).withOpacity(0.6)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (point.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  point.imageUrls.first,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            if (point.imageUrls.isNotEmpty) const SizedBox(height: 12),
            Text(point.name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 6),
            Text(point.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFFa78bfa), fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Color(0xFFa78bfa))),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7c3aed),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Ir aquí', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WaitingOverlay extends StatelessWidget {
  final Difficulty difficulty;
  final VoidCallback onStart;
  const _WaitingOverlay({required this.difficulty, required this.onStart});

  String get _label {
    switch (difficulty) {
      case Difficulty.easy:   return 'Fácil — 3 puntos';
      case Difficulty.medium: return 'Medio — 5 puntos';
      case Difficulty.hard:   return 'Difícil — 7 puntos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1033),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF7c3aed), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7c3aed).withOpacity(0.3),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, color: Color(0xFFa78bfa), size: 64),
              const SizedBox(height: 16),
              const Text('Memory Trip',
                  style: TextStyle(
                      color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF7c3aed).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF7c3aed).withOpacity(0.5)),
                ),
                child: Text(_label,
                    style: const TextStyle(color: Color(0xFFc4b5fd), fontSize: 13)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tendrás 60 segundos para memorizar los puntos. '
                'Luego deberás encontrarlos en el mapa.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF9ca3af), fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7c3aed),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('¡Comenzar!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
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
            margin: const EdgeInsets.only(top: 12, left: 80, right: 80),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF7c3aed).withOpacity(0.7)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.remove_red_eye_outlined,
                    color: Color(0xFFa78bfa), size: 18),
                const SizedBox(width: 8),
                Text('Memoriza — ${secondsLeft}s',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
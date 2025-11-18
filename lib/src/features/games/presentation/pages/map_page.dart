import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/current_location_market.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/destination_marker.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_header.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../users/presentation/widgets/game/difficulty_card.dart';
import '../blocs/game_bloc.dart';
import 'dart:math';
import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/scheduler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  // IDs de puntos seleccionados al azar
  List<int> _randomSecuenciaIds = [];

  int? _pointResaltadoId;

  bool _secuenciaReproducida = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<GameBloc>().state;
      _mapController.move(state.currentLocation, state.zoom);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Si vienen args y todavía no se ejeccutó la secuenciaa, LA INICIAMOS
    if (args != null && !_secuenciaReproducida) {
      final Difficulty difficulty =
          args['difficulty'] as Difficulty? ?? Difficulty.medium;
      _startSequenceForDifficulty(difficulty);
    }
  }

  void _showPointDialog(
    BuildContext context,
    int id,
    String name,
    String description,
    List<String> imageUrls,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imageUrls.first,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                '¿Activar este punto?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.purple.shade300),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().add(PointActivated(id));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Activar'),
          ),
        ],
      ),
    );
  }

  List<int> _pickRandomSequenceIds(List<Point> points, int k) {
    final rng = Random();
    final indices = List<int>.generate(points.length, (i) => i);
    indices.shuffle(rng);
    return indices.take(k).map((i) => points[i].id).toList();
  }

  Future<void> _startSequenceForDifficulty(Difficulty difficulty) async {
    // Para que no haya muchas llamadas
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

    // Para el usuario, el mensaje de la secuencia
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
      setState(() {
        _pointResaltadoId = id;
      });

      try {
        final point = allPoints.firstWhere((p) => p.id == id);
        _mapController.move(point.coords, context.read<GameBloc>().state.zoom);
      } catch (_) {}

      // Para mostrar por X segundos
      await Future.delayed(showDuration);
      if (!mounted) return;

      setState(() {
        _pointResaltadoId = null;
      });

      await Future.delayed(interPause);
    }

    // La secuencia termina y lo manda de nuevo al a pantalla de los pontis
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.points,
      arguments: {'sequenceIds': _randomSecuenciaIds},
    );

    if (!mounted) return;

    // Manejar elección del usuario cuando vuelve (puede ser null)
    _handleUserChoice(result);
  }

  // Maneja lo que devuelve PointsPage, debería ser el ID o null tal vez
  void _handleUserChoice(dynamic result) {
    if (result == null) return;

    int chosenId;
    if (result is int) {
      chosenId = result;
    } else if (result is Map && result['id'] is int) {
      chosenId = result['id'] as int;
    } else {
      // Este es por si el aformato no es correcto
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
  }

  // Distancia en metros entre dos LatLng
  double _degreesToRadians(double degrees) => degrees * pi / 180.0;
  double _distanceBetweenLatLng(LatLng a, LatLng b) {
    final lat1 = _degreesToRadians(a.latitude);
    final lon1 = _degreesToRadians(a.longitude);
    final lat2 = _degreesToRadians(b.latitude);
    final lon2 = _degreesToRadians(b.longitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final sinDLat = sin(dLat / 2);
    final sinDLon = sin(dLon / 2);
    final aCalc = sinDLat * sinDLat + cos(lat1) * cos(lat2) * sinDLon * sinDLon;
    final c = 2 * atan2(sqrt(aCalc), sqrt(1 - aCalc));
    const earthRadius = 6371000; // Metros
    return earthRadius * c;
  }

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
            // Header
            GameHeader(
              onMenuClick: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menú presionado'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              onSettingsClick: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuración presionada'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            // Mapa
            Expanded(
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: state.currentLocation,
                          initialZoom: state.zoom,
                          minZoom: 12.0,
                          maxZoom: 18.0,
                          backgroundColor: Colors.grey.shade900,
                        ),
                        children: [
                          // Capa de tiles de OpenStreetMap
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.memory_trip',
                          ),

                          // Capa de líneas de conexión
                          PolylineLayer(polylines: _buildPolylines(state)),

                          // Capa de marcadores
                          MarkerLayer(markers: _buildMarkers(state)),
                        ],
                      ),

                      // Controles de zoom
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Column(
                          children: [
                            _buildZoomButton(
                              icon: Icons.add,
                              onTap: () {
                                context.read<GameBloc>().add(ZoomInRequested());
                                _mapController.move(
                                  _mapController.camera.center,
                                  state.zoom + 1.0,
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildZoomButton(
                              icon: Icons.remove,
                              onTap: () {
                                context.read<GameBloc>().add(
                                  ZoomOutRequested(),
                                );
                                _mapController.move(
                                  _mapController.camera.center,
                                  state.zoom - 1.0,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Indicador de zoom
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.purple.shade500.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '${(state.zoom * 100 / 15).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),

                      // Controles de navegación
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Column(
                          children: [
                            _buildActionButton(
                              icon: Icons.navigation,
                              color: Colors.purple,
                              onTap: () {
                                _mapController.move(
                                  state.currentLocation,
                                  state.zoom,
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildActionButton(
                              icon: Icons.bolt,
                              color: Colors.deepPurple,
                              onTap: () {
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildActionButton(
                              icon: Icons.home,
                              color: Colors.blue,
                              onTap: () {
                                _mapController.move(
                                  state.currentLocation,
                                  15.0,
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

            // Stats del juego
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

  List<Polyline> _buildPolylines(GameState state) {
    final polylines = <Polyline>[];
    final points = state.points;

    if (points.isEmpty) return polylines;

    // Línea desde ubicación actual al primer punto
    polylines.add(
      Polyline(
        points: [state.currentLocation, points.first.coords],
        strokeWidth: 3.0,
        color: points.first.isActive
            ? Colors.purple.withOpacity(0.6)
            : points.first.isCompleted
            ? Colors.green.withOpacity(0.8)
            : Colors.grey.withOpacity(0.3),
        pattern: points.first.isActive
            ? StrokePattern.dashed(segments: [10, 5])
            : StrokePattern.solid(),
      ),
    );

    // Líneas entre puntos consecutivos
    for (int i = 0; i < points.length - 1; i++) {
      final from = points[i];
      final to = points[i + 1];

      polylines.add(
        Polyline(
          points: [from.coords, to.coords],
          strokeWidth: 3.0,
          color: to.isActive
              ? Colors.purple.withOpacity(0.6)
              : to.isCompleted
              ? Colors.green.withOpacity(0.8)
              : Colors.grey.withOpacity(0.3),
          pattern: to.isActive
              ? StrokePattern.dashed(segments: [10, 5])
              : StrokePattern.solid(),
        ),
      );
    }

    return polylines;
  }

  List<Marker> _buildMarkers(GameState state) {
    final markers = <Marker>[];

    // Ubicación actual del USuario, siempre ta visible
    markers.add(
      Marker(
        point: state.currentLocation,
        width: 120,
        height: 120,
        alignment: Alignment.center,
        child: const CurrentLocationMarkerWidget(),
      ),
    );

    // Para mostrar solamente el punto resaltado, los demás no
    // Es para la secuencia, básicamente
    if (_pointResaltadoId != null) {
      final highlighted = _findPointById(state.points, _pointResaltadoId!);
      if (highlighted != null) {
        markers.add(
          Marker(
            point: highlighted.coords,
            width: 200,
            height: 180,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                DestinationMarkerWidget(
                  order: state.points.indexOf(highlighted) + 1,
                  title: highlighted.name,
                  timeRemaining: highlighted.timeRemaining,
                  totalTime: highlighted.totalTime,
                  isActive: highlighted.isActive,
                  isCompleted: highlighted.isCompleted,
                  imageUrl: highlighted.imageUrls.isNotEmpty
                      ? highlighted.imageUrls.first
                      : null,

                  onTap: () {
                    if (highlighted.isActive || highlighted.isCompleted) {
                      _showPointDialog(
                        context,
                        highlighted.id,
                        highlighted.name,
                        highlighted.description,
                        highlighted.imageUrls,
                      );
                    }
                  },
                ),

                // Acá se reasalta
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow.withOpacity(0.12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(0.6),
                              blurRadius: 28,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return markers; // Termina devolviendo la ubi actual y el resaltado
    }

    // Si no hay resaltado, muestra TODOS los puntos
    for (int i = 0; i < state.points.length; i++) {
      final point = state.points[i];
      markers.add(
        Marker(
          point: point.coords,
          width: 200,
          height: 180,
          alignment: Alignment.center,
          child: DestinationMarkerWidget(
            order: i + 1,
            title: point.name,
            timeRemaining: point.timeRemaining,
            totalTime: point.totalTime,
            isActive: point.isActive,
            isCompleted: point.isCompleted,
            imageUrl: point.imageUrls.isNotEmpty ? point.imageUrls.first : null,
            onTap: () {
              if (point.isActive || point.isCompleted) {
                _showPointDialog(
                  context,
                  point.id,
                  point.name,
                  point.description,
                  point.imageUrls,
                );
              }
            },
          ),
        ),
      );
    }

    return markers;
  }

  // Busca un Point por id
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
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
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
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

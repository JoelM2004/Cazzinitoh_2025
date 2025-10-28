import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/current_location_market.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/destination_marker.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_header.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/maps/game_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import '../blocs/game_bloc.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<GameBloc>().state;
      _mapController.move(state.currentLocation, state.zoom);
    });
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

    // Marcador de ubicación actual
    markers.add(
      Marker(
        point: state.currentLocation,
        width: 120,
        height: 120,
        alignment: Alignment.center,
        child: const CurrentLocationMarkerWidget(),
      ),
    );

    // Marcadores de puntos
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

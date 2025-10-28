import 'dart:async';
import 'package:cazzinitoh_2025/src/core/points/points.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

// ==================== EVENTS ====================
abstract class GameEvent {}

class GameStarted extends GameEvent {}

class GameTick extends GameEvent {}

class PointActivated extends GameEvent {
  final int pointId;
  PointActivated(this.pointId);
}

class ZoomChanged extends GameEvent {
  final double zoom;
  ZoomChanged(this.zoom);
}

class ZoomInRequested extends GameEvent {}

class ZoomOutRequested extends GameEvent {}

// ==================== STATE ====================
class GameState {
  final int score;
  final int gameTime;
  final double zoom;
  final LatLng currentLocation;
  final List<Point> points;

  GameState({
    required this.score,
    required this.gameTime,
    required this.zoom,
    required this.currentLocation,
    required this.points,
  });

  int get completedCount => points.where((p) => p.isCompleted).length;
  int get totalCount => points.length;

  String formatGameTime() {
    final minutes = gameTime ~/ 60;
    final seconds = gameTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  GameState copyWith({
    int? score,
    int? gameTime,
    double? zoom,
    LatLng? currentLocation,
    List<Point>? points,
  }) {
    return GameState(
      score: score ?? this.score,
      gameTime: gameTime ?? this.gameTime,
      zoom: zoom ?? this.zoom,
      currentLocation: currentLocation ?? this.currentLocation,
      points: points ?? this.points,
    );
  }
}

// ==================== BLOC ====================
class GameBloc extends Bloc<GameEvent, GameState> {
  Timer? _gameTimer;

  GameBloc()
    : super(
        GameState(
          score: 1250,
          gameTime: 0,
          zoom: 15.0,
          currentLocation: const LatLng(-46.4406, -67.5256),
          points: _initializePoints(),
        ),
      ) {
    on<GameStarted>(_onGameStarted);
    on<GameTick>(_onGameTick);
    on<PointActivated>(_onPointActivated);
    on<ZoomChanged>(_onZoomChanged);
    on<ZoomInRequested>(_onZoomInRequested);
    on<ZoomOutRequested>(_onZoomOutRequested);

    // Iniciar el juego automáticamente
    add(GameStarted());
  }

  static List<Point> _initializePoints() {
    final points = PointsSrc.points.map((point) {
      return point.copyWith(
        timeRemaining: 60,
        totalTime: 60,
        isActive: false,
        isCompleted: false,
      );
    }).toList();

    // Activar el primer punto
    if (points.isNotEmpty) {
      points[0] = points[0].copyWith(isActive: true);
    }

    return points;
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(GameTick());
    });
  }

  void _onGameTick(GameTick event, Emitter<GameState> emit) {
    final updatedPoints = <Point>[];

    for (var point in state.points) {
      if (point.isActive && !point.isCompleted && point.timeRemaining > 0) {
        final newTimeRemaining = point.timeRemaining - 1;
        updatedPoints.add(
          point.copyWith(
            timeRemaining: newTimeRemaining,
            isActive: newTimeRemaining > 0,
          ),
        );
      } else {
        updatedPoints.add(point);
      }
    }

    emit(state.copyWith(gameTime: state.gameTime + 1, points: updatedPoints));
  }

  void _onPointActivated(PointActivated event, Emitter<GameState> emit) {
    final index = state.points.indexWhere((p) => p.id == event.pointId);
    if (index == -1) return;

    final point = state.points[index];
    if (point.isCompleted) return;

    final updatedPoints = List<Point>.from(state.points);
    int newScore = state.score;

    // Marcar como completado y ganar puntos si estaba activo
    if (point.isActive) {
      newScore += 500;
    }

    updatedPoints[index] = point.copyWith(isCompleted: true, isActive: false);

    // Activar siguiente punto
    if (index + 1 < updatedPoints.length) {
      final nextPoint = updatedPoints[index + 1];
      if (!nextPoint.isCompleted) {
        updatedPoints[index + 1] = nextPoint.copyWith(isActive: true);
      }
    }

    emit(state.copyWith(score: newScore, points: updatedPoints));
  }

  void _onZoomChanged(ZoomChanged event, Emitter<GameState> emit) {
    final newZoom = event.zoom.clamp(12.0, 18.0);
    emit(state.copyWith(zoom: newZoom));
  }

  void _onZoomInRequested(ZoomInRequested event, Emitter<GameState> emit) {
    final newZoom = (state.zoom + 1.0).clamp(12.0, 18.0);
    emit(state.copyWith(zoom: newZoom));
  }

  void _onZoomOutRequested(ZoomOutRequested event, Emitter<GameState> emit) {
    final newZoom = (state.zoom - 1.0).clamp(12.0, 18.0);
    emit(state.copyWith(zoom: newZoom));
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}

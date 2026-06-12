import 'dart:async';
import 'dart:math';

import 'package:cazzinitoh_2025/src/core/location/location_service.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/save_leaderboard_entry_usecase.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/update_stats_usecase.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

part 'game_event.dart';
part 'game_state.dart';

// Radio en metros para considerar que el usuario llegó al punto
const double _arrivalRadiusMeters = 5.0;

double _distanceMeters(LatLng a, LatLng b) {
  const earthRadius = 6371000.0;
  final dLat = (b.latitude - a.latitude) * (pi / 180);
  final dLon = (b.longitude - a.longitude) * (pi / 180);
  final sinDLat = sin(dLat / 2);
  final sinDLon = sin(dLon / 2);
  final c = sinDLat * sinDLat +
      cos(a.latitude * (pi / 180)) *
          cos(b.latitude * (pi / 180)) *
          sinDLon *
          sinDLon;
  return earthRadius * 2 * atan2(sqrt(c), sqrt(1 - c));
}

class GameBloc extends Bloc<GameEvent, GameState> {
  final LocationService locationService;
  final SaveScoreUseCase saveScore;
  final SaveStatsUseCase saveStats;

  Timer? _gameTimer;
  Timer? _memorizingTimer;
  StreamSubscription<LatLng>? _locationSub;

  GameBloc({
    required this.locationService,
    required this.saveScore,
    required this.saveStats,
  }) : super(const GameState()) {
    on<GameStarted>(_onGameStarted);
    on<MemorizingStarted>(_onMemorizingStarted);
    on<MemorizingTick>(_onMemorizingTick);
    on<GameTick>(_onGameTick);
    on<LocationUpdated>(_onLocationUpdated);
    on<PointSelected>(_onPointSelected);
    on<PointReached>(_onPointReached);
    on<QuestionAnswered>(_onQuestionAnswered);
    on<GameFinished>(_onGameFinished);
    on<ZoomInRequested>(_onZoomIn);
    on<ZoomOutRequested>(_onZoomOut);
  }

  Future<void> _onGameStarted(GameStarted event, Emitter<GameState> emit) async {
    final pts = event.points.map((p) => p.copyWith(
      isActive: false,
      isCompleted: false,
      timeRemaining: 60,
      totalTime: 60,
    )).toList();

    emit(state.copyWith(
      phase: GamePhase.waiting,
      points: pts,
      sequenceIds: event.sequenceIds,
      userId: event.userId,
      score: 0,
      gameTimeSeconds: 0,
      memorizingSecondsLeft: 60,
      correctAnswers: 0,
      totalAnswers: 0,
      clearSelectedPoint: true,
      clearError: true,
    ));

    _startLocationStream();
  }

  void _onMemorizingStarted(MemorizingStarted event, Emitter<GameState> emit) {
    emit(state.copyWith(phase: GamePhase.memorizing, memorizingSecondsLeft: 60));
    _memorizingTimer?.cancel();
    _memorizingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(MemorizingTick());
    });
  }

  void _onMemorizingTick(MemorizingTick event, Emitter<GameState> emit) {
    final newSeconds = state.memorizingSecondsLeft - 1;
    if (newSeconds <= 0) {
      _memorizingTimer?.cancel();
      emit(state.copyWith(phase: GamePhase.navigating, memorizingSecondsLeft: 0));
      _ensureTimerRunning();
    } else {
      emit(state.copyWith(memorizingSecondsLeft: newSeconds));
    }
  }

  void _onGameTick(GameTick event, Emitter<GameState> emit) {
    if (state.phase != GamePhase.navigating) return;

    final pts = state.points.map((p) {
      if (p.id != state.selectedPointId || p.isCompleted) return p;
      final remaining = p.timeRemaining - 1;
      if (remaining <= 0) return p.copyWith(isActive: false, timeRemaining: 0);
      return p.copyWith(timeRemaining: remaining);
    }).toList();

    emit(state.copyWith(gameTimeSeconds: state.gameTimeSeconds + 1, points: pts));

    if (state.selectedPointId != null) {
      final active = pts.firstWhere(
        (p) => p.id == state.selectedPointId,
        orElse: () => pts.first,
      );
      if (active.timeRemaining <= 0 && !active.isCompleted) {
        emit(state.copyWith(points: pts, clearSelectedPoint: true));
      }
    }

    if (pts.every((p) => p.isCompleted)) add(GameFinished());
  }

  // ── Detección de proximidad ──────────────────────────────────
  void _onLocationUpdated(LocationUpdated event, Emitter<GameState> emit) {
    emit(state.copyWith(currentLocation: event.position));

    // Solo chequeamos si hay un punto activo y estamos navegando
    if (state.phase != GamePhase.navigating) return;
    if (state.selectedPointId == null) return;

    final target = state.points.firstWhere(
      (p) => p.id == state.selectedPointId,
      orElse: () => state.points.first,
    );

    if (target.isCompleted || !target.isActive) return;

    final distance = _distanceMeters(event.position, target.coords);

    if (distance <= _arrivalRadiusMeters) {
      add(PointReached(target.id));
    }
  }

  void _onPointSelected(PointSelected event, Emitter<GameState> emit) {
    // Si ya hay un punto activo no completado, no permitir cambiar
    final hasActive = state.points.any((p) => p.isActive && !p.isCompleted);
    if (hasActive) return;

    final pts = state.points.map((p) {
      if (p.id == event.pointId && !p.isCompleted) return p.copyWith(isActive: true);
      if (p.isActive && p.id != event.pointId) return p.copyWith(isActive: false);
      return p;
    }).toList();

    emit(state.copyWith(
      phase: GamePhase.navigating,
      points: pts,
      selectedPointId: event.pointId,
      clearError: true,
    ));

    _ensureTimerRunning();
  }

  void _onPointReached(PointReached event, Emitter<GameState> emit) {
    if (state.selectedPointId != event.pointId) return;
    _gameTimer?.cancel();
    emit(state.copyWith(phase: GamePhase.answering));
  }

  void _onQuestionAnswered(QuestionAnswered event, Emitter<GameState> emit) {
    final idx = state.points.indexWhere((p) => p.id == event.pointId);
    if (idx == -1) return;

    final pts = List<Point>.from(state.points);
    int newScore = state.score;
    int newCorrect = state.correctAnswers;

    if (event.isCorrect) {
      final timeBonus = pts[idx].timeRemaining * 5;
      newScore += 500 + timeBonus;
      newCorrect++;
      // Marcar completado — este chip desaparece del carrusel
      pts[idx] = pts[idx].copyWith(isCompleted: true, isActive: false);
    } else {
      newScore = (newScore - 50).clamp(0, 999999);
      // Respuesta incorrecta: desactivar el punto para que pueda elegir otro
      pts[idx] = pts[idx].copyWith(isActive: false);
    }

    final allDone = pts.every((p) => p.isCompleted);

    emit(state.copyWith(
      phase: GamePhase.navigating,
      points: pts,
      score: newScore,
      correctAnswers: newCorrect,
      totalAnswers: state.totalAnswers + 1,
      clearSelectedPoint: true, // siempre libera la selección tras el quiz
    ));

    if (allDone) {
      add(GameFinished());
      return;
    }

    _ensureTimerRunning();
  }

  Future<void> _onGameFinished(GameFinished event, Emitter<GameState> emit) async {
    _gameTimer?.cancel();
    _memorizingTimer?.cancel();
    _locationSub?.cancel();

    emit(state.copyWith(phase: GamePhase.saving));

    final scoreResult = await saveScore(state.score);
    final statsResult = await saveStats(Stats(
      userId: state.userId,
      mts: 0,
      time: state.gameTimeSeconds.toDouble(),
      matchs: 1,
      accuracy: state.accuracy * 100,
    ));

    final hasError = scoreResult.isLeft() || statsResult.isLeft();
    emit(state.copyWith(
      phase: hasError ? GamePhase.error : GamePhase.finished,
      errorMessage: hasError ? 'Error al guardar los resultados' : null,
    ));
  }

  void _onZoomIn(ZoomInRequested event, Emitter<GameState> emit) =>
      emit(state.copyWith(zoom: (state.zoom + 1.0).clamp(12.0, 18.0)));

  void _onZoomOut(ZoomOutRequested event, Emitter<GameState> emit) =>
      emit(state.copyWith(zoom: (state.zoom - 1.0).clamp(12.0, 18.0)));

  void _ensureTimerRunning() {
    if (_gameTimer?.isActive == true) return;
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) => add(GameTick()));
  }

  void _startLocationStream() {
    try {
      _locationSub?.cancel();
      _locationSub = locationService.positionStream.listen(
        (pos) => add(LocationUpdated(pos)),
        onError: (_) {},
      );
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    _memorizingTimer?.cancel();
    _locationSub?.cancel();
    return super.close();
  }
}
import 'dart:async';

import 'package:cazzinitoh_2025/src/core/location/location_service.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/save_leaderboard_entry_usecase.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/update_stats_usecase.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final LocationService locationService;
  final SaveScoreUseCase saveScore;
  final SaveStatsUseCase saveStats;

  Timer? _gameTimer;
  StreamSubscription<LatLng>? _locationSub;

  GameBloc({
    required this.locationService,
    required this.saveScore,
    required this.saveStats,
  }) : super(const GameState()) {
    on<GameStarted>(_onGameStarted);
    on<GameTick>(_onGameTick);
    on<LocationUpdated>(_onLocationUpdated);
    on<PointSelected>(_onPointSelected);
    on<PointReached>(_onPointReached);
    on<QuestionAnswered>(_onQuestionAnswered);
    on<GameFinished>(_onGameFinished);
    on<ZoomInRequested>(_onZoomIn);
    on<ZoomOutRequested>(_onZoomOut);
  }

  // ── Handlers ────────────────────────────────────────────────

  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) async {
    final pts = event.points
        .map((p) => p.copyWith(isActive: false, isCompleted: false))
        .toList();

    emit(state.copyWith(
      phase: GamePhase.memorizing,
      points: pts,
      sequenceIds: event.sequenceIds,
      userId: event.userId,
      score: 0,
      gameTimeSeconds: 0,
      correctAnswers: 0,
      totalAnswers: 0,
      clearSelectedPoint: true,
      clearError: true,
    ));

    _startLocationStream();
  }

  void _onGameTick(GameTick event, Emitter<GameState> emit) {
    if (state.phase != GamePhase.navigating) return;

    final pts = state.points.map((p) {
      if (p.id != state.selectedPointId || p.isCompleted) return p;
      final remaining = p.timeRemaining - 1;
      if (remaining <= 0) {
        return p.copyWith(isActive: false, timeRemaining: 0);
      }
      return p.copyWith(timeRemaining: remaining);
    }).toList();

    emit(state.copyWith(
      gameTimeSeconds: state.gameTimeSeconds + 1,
      points: pts,
    ));

    // Si el tiempo del punto activo se agotó, limpiamos la selección.
    final wasActive = pts.firstWhere(
      (p) => p.id == state.selectedPointId,
      orElse: () => pts.first,
    );
    if (wasActive.timeRemaining <= 0 && !wasActive.isCompleted) {
      emit(state.copyWith(points: pts, clearSelectedPoint: true));
    }

    if (pts.every((p) => p.isCompleted)) add(GameFinished());
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<GameState> emit) {
    emit(state.copyWith(currentLocation: event.position));
  }

  void _onPointSelected(PointSelected event, Emitter<GameState> emit) {
    final pts = state.points.map((p) {
      if (p.id == event.pointId && !p.isCompleted) {
        return p.copyWith(isActive: true);
      }
      if (p.isActive && p.id != event.pointId) {
        return p.copyWith(isActive: false);
      }
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

    // Pausamos el timer mientras el usuario responde.
    _gameTimer?.cancel();

    emit(state.copyWith(phase: GamePhase.answering));
  }

  void _onQuestionAnswered(QuestionAnswered event, Emitter<GameState> emit) {
    final idx = state.points.indexWhere((p) => p.id == event.pointId);
    if (idx == -1) return;

    final pts = List<Point>.from(state.points);
    final newTotalAnswers = state.totalAnswers + 1;
    int newScore = state.score;
    int newCorrect = state.correctAnswers;

    if (event.isCorrect) {
      const baseScore = 500;
      final timeBonus = pts[idx].timeRemaining * 5;
      newScore += baseScore + timeBonus;
      newCorrect++;
      pts[idx] = pts[idx].copyWith(isCompleted: true, isActive: false);
    } else {
      newScore = (newScore - 50).clamp(0, 999999);
      // El punto sigue activo: el usuario puede reintentarlo.
    }

    final allDone = pts.every((p) => p.isCompleted);

    emit(state.copyWith(
      phase: GamePhase.navigating,
      points: pts,
      score: newScore,
      correctAnswers: newCorrect,
      totalAnswers: newTotalAnswers,
      clearSelectedPoint: event.isCorrect,
    ));

    if (allDone) {
      add(GameFinished());
      return;
    }

    _ensureTimerRunning();
  }

  Future<void> _onGameFinished(
    GameFinished event,
    Emitter<GameState> emit,
  ) async {
    _gameTimer?.cancel();
    _locationSub?.cancel();

    emit(state.copyWith(phase: GamePhase.saving));

    final scoreResult = await saveScore(state.score);

    final statsResult = await saveStats(
      Stats(
        userId: state.userId,
        mts: 0, // extensión futura: distancia recorrida real
        time: state.gameTimeSeconds.toDouble(),
        matchs: 1,
        accuracy: state.accuracy * 100, // el repo espera 0–100
      ),
    );

    final hasError = scoreResult.isLeft() || statsResult.isLeft();

    emit(state.copyWith(
      phase: hasError ? GamePhase.error : GamePhase.finished,
      errorMessage: hasError ? 'Error al guardar los resultados' : null,
    ));
  }

  void _onZoomIn(ZoomInRequested event, Emitter<GameState> emit) {
    emit(state.copyWith(zoom: (state.zoom + 1.0).clamp(12.0, 18.0)));
  }

  void _onZoomOut(ZoomOutRequested event, Emitter<GameState> emit) {
    emit(state.copyWith(zoom: (state.zoom - 1.0).clamp(12.0, 18.0)));
  }

  // ── Helpers privados ─────────────────────────────────────────

  void _ensureTimerRunning() {
    if (_gameTimer?.isActive == true) return;
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(GameTick());
    });
  }

  void _startLocationStream() {
    try {
      _locationSub?.cancel();
      _locationSub = locationService.positionStream.listen(
        (pos) => add(LocationUpdated(pos)),
        onError: (_) {},
      );
    } catch (_) {
      // Geolocator no disponible en emulador; continuamos sin GPS.
    }
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    _locationSub?.cancel();
    return super.close();
  }
}
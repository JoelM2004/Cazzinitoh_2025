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

const double _arrivalRadiusMeters = 200.0;

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

  bool _pointReachHandled = false;

  // ─── Acumulador de distancia ────────────────────────────────
  double _totalMeters = 0.0;
  LatLng? _lastPosition;

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

  // ─── GameStarted ────────────────────────────────────────────

  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) async {
    _gameTimer?.cancel();
    _memorizingTimer?.cancel();
    _pointReachHandled = false;
    _totalMeters = 0.0;
    _lastPosition = null;

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

  // ─── MemorizingStarted ──────────────────────────────────────

  void _onMemorizingStarted(
    MemorizingStarted event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(phase: GamePhase.memorizing, memorizingSecondsLeft: 60));
    _memorizingTimer?.cancel();
    _memorizingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(MemorizingTick()),
    );
  }

  // ─── MemorizingTick ─────────────────────────────────────────

  void _onMemorizingTick(
    MemorizingTick event,
    Emitter<GameState> emit,
  ) {
    final newSeconds = state.memorizingSecondsLeft - 1;
    if (newSeconds <= 0) {
      _memorizingTimer?.cancel();
      _pointReachHandled = false;
      emit(state.copyWith(phase: GamePhase.navigating, memorizingSecondsLeft: 0));
      _ensureTimerRunning();
    } else {
      emit(state.copyWith(memorizingSecondsLeft: newSeconds));
    }
  }

  // ─── GameTick ───────────────────────────────────────────────

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

  // ─── LocationUpdated ────────────────────────────────────────

  void _onLocationUpdated(
    LocationUpdated event,
    Emitter<GameState> emit,
  ) {
    // Acumular distancia solo durante navegación
    if (state.phase == GamePhase.navigating && _lastPosition != null) {
      _totalMeters += _distanceMeters(_lastPosition!, event.position);
    }
    _lastPosition = event.position;

    emit(state.copyWith(currentLocation: event.position));

    if (state.phase != GamePhase.navigating) return;
    if (state.selectedPointId == null) return;
    if (_pointReachHandled) return;

    final target = state.points.firstWhere(
      (p) => p.id == state.selectedPointId,
      orElse: () => state.points.first,
    );

    if (target.isCompleted || !target.isActive) return;

    final distance = _distanceMeters(event.position, target.coords);

    if (distance <= _arrivalRadiusMeters) {
      _pointReachHandled = true;
      add(PointReached(target.id));
    }
  }

  // ─── PointSelected ──────────────────────────────────────────

  void _onPointSelected(
    PointSelected event,
    Emitter<GameState> emit,
  ) {
    final hasActive = state.points.any((p) => p.isActive && !p.isCompleted);
    if (hasActive) return;

    final pts = state.points.map((p) {
      if (p.id == event.pointId && !p.isCompleted) return p.copyWith(isActive: true);
      if (p.isActive && p.id != event.pointId) return p.copyWith(isActive: false);
      return p;
    }).toList();

    _pointReachHandled = false;

    emit(state.copyWith(
      phase: GamePhase.navigating,
      points: pts,
      selectedPointId: event.pointId,
      clearError: true,
    ));

    _ensureTimerRunning();
  }

  // ─── PointReached ───────────────────────────────────────────

  void _onPointReached(
    PointReached event,
    Emitter<GameState> emit,
  ) {
    if (state.selectedPointId != event.pointId) return;
    if (state.phase == GamePhase.answering || state.phase == GamePhase.saving) return;

    _gameTimer?.cancel();
    emit(state.copyWith(phase: GamePhase.answering));
  }

  // ─── QuestionAnswered ───────────────────────────────────────

  void _onQuestionAnswered(
    QuestionAnswered event,
    Emitter<GameState> emit,
  ) {
    final idx = state.points.indexWhere((p) => p.id == event.pointId);
    if (idx == -1) return;

    final pts = List<Point>.from(state.points);
    int newScore = state.score;
    int newCorrect = state.correctAnswers;

    final firstIncomplete = state.points.indexWhere((p) => !p.isCompleted);
    final wasInOrder = firstIncomplete == idx;

    if (event.isCorrect) {
      final timeBonus = pts[idx].timeRemaining * 5;
      newCorrect++;
      newScore += wasInOrder ? (500 + timeBonus) : (200 + timeBonus);
    } else {
      newScore = (newScore - 50).clamp(0, 999999);
    }

    pts[idx] = pts[idx].copyWith(isCompleted: true, isActive: false);

    final allDone = pts.every((p) => p.isCompleted);

    _pointReachHandled = false;

    emit(state.copyWith(
      phase: GamePhase.navigating,
      points: pts,
      score: newScore,
      correctAnswers: newCorrect,
      totalAnswers: state.totalAnswers + 1,
      clearSelectedPoint: true,
    ));

    if (allDone) {
      add(GameFinished());
      return;
    }

    _ensureTimerRunning();
  }

  // ─── GameFinished ───────────────────────────────────────────

  Future<void> _onGameFinished(
    GameFinished event,
    Emitter<GameState> emit,
  ) async {
    _gameTimer?.cancel();
    _memorizingTimer?.cancel();
    _locationSub?.cancel();

    print('🔵 [BLOC] Fin de la partida. Pasando a GamePhase.saving');
    print('🔵 [BLOC] UserId: "${state.userId}", Score: ${state.score}, Metros: ${_totalMeters.round()}');

    emit(state.copyWith(phase: GamePhase.saving));

    print('🔵 [BLOC] Llamando a saveScore...');
    final scoreResult = await saveScore(state.score);
    print('🔵 [BLOC] saveScore falló? ${scoreResult.isLeft()}');

    print('🔵 [BLOC] Llamando a saveStats...');
    final statsResult = await saveStats(Stats(
      userId: state.userId,
      mts: _totalMeters.roundToDouble(),  // ← metros reales acumulados
      time: state.gameTimeSeconds.toDouble(),
      matchs: 1,
      accuracy: state.accuracy * 100,
    ));
    print('🔵 [BLOC] saveStats falló? ${statsResult.isLeft()}');

    final hasError = scoreResult.isLeft() || statsResult.isLeft();

    if (hasError) {
      print('🔴 [BLOC] Error detectado. Cambiando a GamePhase.error');
    } else {
      print('🟢 [BLOC] Todo guardado OK. Cambiando a GamePhase.finished');
    }

    emit(state.copyWith(
      phase: hasError ? GamePhase.error : GamePhase.finished,
      errorMessage: hasError ? 'Error al guardar los resultados' : null,
    ));
  }

  // ─── Zoom ───────────────────────────────────────────────────

  void _onZoomIn(ZoomInRequested event, Emitter<GameState> emit) =>
      emit(state.copyWith(zoom: (state.zoom + 1.0).clamp(12.0, 18.0)));

  void _onZoomOut(ZoomOutRequested event, Emitter<GameState> emit) =>
      emit(state.copyWith(zoom: (state.zoom - 1.0).clamp(12.0, 18.0)));

  // ─── Internos ───────────────────────────────────────────────

  void _ensureTimerRunning() {
    if (_gameTimer?.isActive == true) return;
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(GameTick()),
    );
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
part of 'game_bloc.dart';

enum GamePhase {
  /// Mostrando la secuencia al usuario (pantalla de memorización).
  memorizing,

  /// El usuario navega hacia el punto seleccionado.
  navigating,

  /// El usuario está respondiendo la pregunta del punto.
  answering,

  /// Guardando resultados en backend.
  saving,

  /// Juego terminado con éxito.
  finished,

  /// Error al guardar.
  error,
}

class GameState {
  final GamePhase phase;
  final List<Point> points;
  final List<int> sequenceIds;
  final int? selectedPointId;
  final LatLng currentLocation;
  final double zoom;
  final int score;
  final int gameTimeSeconds;
  final String userId;
  final int correctAnswers;
  final int totalAnswers;
  final String? errorMessage;

  const GameState({
    this.phase = GamePhase.memorizing,
    this.points = const [],
    this.sequenceIds = const [],
    this.selectedPointId,
    this.currentLocation = const LatLng(-46.4406, -67.5256),
    this.zoom = 15.0,
    this.score = 0,
    this.gameTimeSeconds = 0,
    this.userId = '',
    this.correctAnswers = 0,
    this.totalAnswers = 0,
    this.errorMessage,
  });

  // ── Derivados ──────────────────────────────────────────────

  // FIX: p nunca es nullable — List<Point> no contiene nulos.
  int get completedCount => points.where((p) => p.isCompleted).length;
  int get totalCount => points.length;
  bool get allCompleted =>
      points.isNotEmpty && points.every((p) => p.isCompleted);

  /// Precisión: 0.0 – 1.0
  double get accuracy =>
      totalAnswers == 0 ? 0.0 : correctAnswers / totalAnswers;

  /// El punto al que el usuario está navegando actualmente.
  Point? get selectedPoint => selectedPointId == null
      ? null
      : points.where((p) => p.id == selectedPointId).firstOrNull;

  String formatGameTime() {
    final m = gameTimeSeconds ~/ 60;
    final s = gameTimeSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  GameState copyWith({
    GamePhase? phase,
    List<Point>? points,
    List<int>? sequenceIds,
    int? selectedPointId,
    bool clearSelectedPoint = false,
    LatLng? currentLocation,
    double? zoom,
    int? score,
    int? gameTimeSeconds,
    String? userId,
    int? correctAnswers,
    int? totalAnswers,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GameState(
      phase: phase ?? this.phase,
      points: points ?? this.points,
      sequenceIds: sequenceIds ?? this.sequenceIds,
      selectedPointId: clearSelectedPoint
          ? null
          : selectedPointId ?? this.selectedPointId,
      currentLocation: currentLocation ?? this.currentLocation,
      zoom: zoom ?? this.zoom,
      score: score ?? this.score,
      gameTimeSeconds: gameTimeSeconds ?? this.gameTimeSeconds,
      userId: userId ?? this.userId,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalAnswers: totalAnswers ?? this.totalAnswers,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
part of 'game_bloc.dart';

enum GamePhase {
  waiting,     // overlay "Comenzar"
  memorizing,  // 60s viendo los puntos
  navigating,  // navegando hacia un punto
  answering,   // respondiendo quiz
  saving,      // guardando en backend
  finished,    // terminó OK
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
  final int memorizingSecondsLeft; // NUEVO
  final String userId;
  final int correctAnswers;
  final int totalAnswers;
  final String? errorMessage;

  const GameState({
    this.phase = GamePhase.waiting, // arranca en waiting
    this.points = const [],
    this.sequenceIds = const [],
    this.selectedPointId,
    this.currentLocation = const LatLng(-46.4406, -67.5256),
    this.zoom = 15.0,
    this.score = 0,
    this.gameTimeSeconds = 0,
    this.memorizingSecondsLeft = 60, // NUEVO
    this.userId = '',
    this.correctAnswers = 0,
    this.totalAnswers = 0,
    this.errorMessage,
  });

  int get completedCount => points.where((p) => p.isCompleted).length;
  int get totalCount => points.length;
  bool get allCompleted => points.isNotEmpty && points.every((p) => p.isCompleted);
  double get accuracy => totalAnswers == 0 ? 0.0 : correctAnswers / totalAnswers;
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
    int? memorizingSecondsLeft,
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
      selectedPointId: clearSelectedPoint ? null : selectedPointId ?? this.selectedPointId,
      currentLocation: currentLocation ?? this.currentLocation,
      zoom: zoom ?? this.zoom,
      score: score ?? this.score,
      gameTimeSeconds: gameTimeSeconds ?? this.gameTimeSeconds,
      memorizingSecondsLeft: memorizingSecondsLeft ?? this.memorizingSecondsLeft,
      userId: userId ?? this.userId,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalAnswers: totalAnswers ?? this.totalAnswers,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
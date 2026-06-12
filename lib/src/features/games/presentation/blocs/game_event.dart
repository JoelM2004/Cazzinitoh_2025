part of 'game_bloc.dart';

abstract class GameEvent {}

class GameStarted extends GameEvent {
  final List<Point> points;
  final List<int> sequenceIds;
  final String userId;
  GameStarted({required this.points, required this.sequenceIds, required this.userId});
}

// NUEVO: el usuario tocó "Comenzar" en el overlay
class MemorizingStarted extends GameEvent {}

class GameTick extends GameEvent {}

class MemorizingTick extends GameEvent {} // NUEVO: tick del countdown de memorizar

class LocationUpdated extends GameEvent {
  final LatLng position;
  LocationUpdated(this.position);
}

class PointSelected extends GameEvent {
  final int pointId;
  PointSelected(this.pointId);
}

class PointReached extends GameEvent {
  final int pointId;
  PointReached(this.pointId);
}

class QuestionAnswered extends GameEvent {
  final int pointId;
  final bool isCorrect;
  QuestionAnswered(this.pointId, this.isCorrect);
}

class GameFinished extends GameEvent {}

class ZoomInRequested extends GameEvent {}
class ZoomOutRequested extends GameEvent {}
part of 'game_bloc.dart';

abstract class GameEvent {}

/// Inicia el juego con los puntos y el userId ya resueltos.
class GameStarted extends GameEvent {
  final List<Point> points;
  final List<int> sequenceIds;
  final String userId;

  GameStarted({
    required this.points,
    required this.sequenceIds,
    required this.userId,
  });
}

/// Tick interno: cada segundo durante la fase [navigating].
class GameTick extends GameEvent {}

/// El GPS actualizó la posición del usuario.
class LocationUpdated extends GameEvent {
  final LatLng position;
  LocationUpdated(this.position);
}

/// El usuario eligió un punto de la secuencia para ir.
class PointSelected extends GameEvent {
  final int pointId;
  PointSelected(this.pointId);
}

/// El usuario llegó al punto (validado externamente o por distancia).
class PointReached extends GameEvent {
  final int pointId;
  PointReached(this.pointId);
}

/// El usuario respondió la pregunta del punto activo.
class QuestionAnswered extends GameEvent {
  final int pointId;
  final bool isCorrect;
  QuestionAnswered(this.pointId, this.isCorrect);
}

/// Finaliza el juego manualmente (todos los puntos completos o tiempo agotado).
class GameFinished extends GameEvent {}

/// Controles de zoom del mapa.
class ZoomInRequested extends GameEvent {}

class ZoomOutRequested extends GameEvent {}
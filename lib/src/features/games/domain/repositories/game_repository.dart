import 'package:dartz/dartz.dart';

import 'package:cazzinitoh_2025/src/core/error/failures.dart';

import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/score_leaderboard.dart';

abstract class GameRepository {
  /// Obtiene el leaderboard completo.
  Future<Either<Failure, List<ScoreLeaderboard>>> getLeaderboard();

  /// Guarda o actualiza el score del usuario actual.
  Future<Either<Failure, void>> saveScore(
    int score,
  );

  /// Obtiene las estadísticas de un usuario.
  Future<Either<Failure, Stats>> getStats(
    String userId,
  );

  /// Guarda o actualiza las estadísticas.
  Future<Either<Failure, Stats>> saveStats(
    Stats stats,
  );

  Future<Either<Failure, List<ScoreLeaderboard>>> getUserScores(String userId);

}
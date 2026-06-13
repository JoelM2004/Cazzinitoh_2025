import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:cazzinitoh_2025/src/core/error/failures.dart';

import 'package:cazzinitoh_2025/src/features/games/data/datasource/game_remote_datasource.dart';

import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/score_leaderboard.dart';

import 'package:cazzinitoh_2025/src/features/users/data/models/stats_model.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDatasource remoteDatasource;

  const GameRepositoryImpl({
    required this.remoteDatasource,
  });

  // ─── LEADERBOARD ───────────────────────────────────────────

  @override
  Future<Either<Failure, List<ScoreLeaderboard>>> getLeaderboard() async {
    try {
      final leaderboard = await remoteDatasource.getLeaderboard();

      return Right(leaderboard);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, void>> saveScore(int score) async {
    try {
      await remoteDatasource.saveScore(score);

      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }

  // ─── STATS ─────────────────────────────────────────────────

  @override
  Future<Either<Failure, Stats>> getStats(
    String userId,
  ) async {
    try {
      final stats = await remoteDatasource.getStats(userId);

      return Right(stats);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Stats>> saveStats(
    Stats stats,
  ) async {
    try {
      final model = StatsModel.fromEntity(stats);

      final result =
          await remoteDatasource.saveStats(model);

      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }

  @override
Future<Either<Failure, List<ScoreLeaderboard>>> getUserScores(String userId) async {
  try {
    final scores = await remoteDatasource.getUserScores(userId);
    return Right(scores);
  } on Failure catch (e) {
    return Left(e);
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}
}
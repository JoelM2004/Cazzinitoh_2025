import 'package:dartz/dartz.dart';

import 'package:cazzinitoh_2025/src/core/error/failures.dart';

import 'package:cazzinitoh_2025/src/features/users/domain/entities/score_leaderboard.dart';

import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';

class GetLeaderboardUseCase {
  final GameRepository repository;

  const GetLeaderboardUseCase(this.repository);

  Future<Either<Failure, List<ScoreLeaderboard>>> call() {
    return repository.getLeaderboard();
  }
}
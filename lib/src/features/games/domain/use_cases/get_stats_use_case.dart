import 'package:dartz/dartz.dart';

import 'package:cazzinitoh_2025/src/core/error/failures.dart';

import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';

import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';

class GetStatsUseCase {
  final GameRepository repository;

  const GetStatsUseCase(this.repository);

  Future<Either<Failure, Stats>> call(
    String userId,
  ) {
    return repository.getStats(userId);
  }
}
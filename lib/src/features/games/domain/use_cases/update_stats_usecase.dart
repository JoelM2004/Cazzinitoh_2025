import 'package:dartz/dartz.dart';

import 'package:cazzinitoh_2025/src/core/error/failures.dart';

import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';

import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';

class SaveStatsUseCase {
  final GameRepository repository;

  const SaveStatsUseCase(this.repository);

  Future<Either<Failure, Stats>> call(
    Stats stats,
  ) {
    return repository.saveStats(stats);
  }
}
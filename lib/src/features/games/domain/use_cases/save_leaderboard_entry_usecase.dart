import 'package:dartz/dartz.dart';

import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';

class SaveScoreUseCase {
  final GameRepository repository;

  const SaveScoreUseCase(this.repository);

  Future<Either<Failure, void>> call(int score) {
    return repository.saveScore(score);
  }
}
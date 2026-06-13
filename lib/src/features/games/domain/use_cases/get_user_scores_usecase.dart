// get_user_scores_usecase.dart
import 'package:cazzinitoh_2025/src/features/users/domain/entities/score_leaderboard.dart';
import 'package:dartz/dartz.dart';
import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';

class GetUserScoresUseCase {
  final GameRepository repository;
  GetUserScoresUseCase(this.repository);

  Future<Either<Failure, List<ScoreLeaderboard>>> call(String userId) {
    return repository.getUserScores(userId);
  }
}
import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

/// Devuelve la lista de jugadores con sus puntajes, ordenada de mayor a menor.
class GetLeaderboardUseCase {
  final UserRepository repository;

  GetLeaderboardUseCase({required this.repository});

  Future<Either<Failure, List<ScoreLeaderboardModel>>> call() {
    return repository.getLeaderboard();
  }
}

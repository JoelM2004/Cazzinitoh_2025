import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetStatsUseCase {
  final UserRepository repository;

  GetStatsUseCase({required this.repository});

  Future<Either<Failure, Stats>> call(int id) {
    return repository.getStats(id);
  }
}

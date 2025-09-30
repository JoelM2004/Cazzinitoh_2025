import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/repositories/point_repository.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:dartz/dartz.dart';

class GetStatsUseCase {
  final PointRepository repository;

  GetStatsUseCase({required this.repository});

  Future<Either<Failure, bool>> call(int id) {
    return repository.getStats(id);
  }
}

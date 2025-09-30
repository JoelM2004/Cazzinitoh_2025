import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class PointRepository {
  Future<Either<Failure, bool>> cacheUser(User user);
  Future<Either<Failure, bool>> getStats(int id);
}

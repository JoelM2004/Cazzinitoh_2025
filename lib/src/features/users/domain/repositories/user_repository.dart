import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, bool>> cacheUser(User user);
  Future<Either<Failure, User>> getUser(int id);
  Future<Either<Failure, Stats>> getStats(int id);
  Future<Either<Failure, bool>> login(String email, String password);
  Future<Either<Failure, bool>> register(String email, String password);
  Future<Either<Failure, bool>> logout();
}

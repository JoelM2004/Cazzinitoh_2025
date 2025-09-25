import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final UserRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, bool>> call() {
    return repository.logout();
  }
}

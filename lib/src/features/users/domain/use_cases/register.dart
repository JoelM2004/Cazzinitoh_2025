import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase {
  final UserRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String email, String password) {
    return repository.register(email, password);
  }
}

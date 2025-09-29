import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateUseCase {
  final UserRepository repository;

  UpdateUseCase({required this.repository});

  Future<Either<Failure, bool>> call(String name, String nameTag, int age) {
    return repository.update(name, nameTag, age);
  }
}

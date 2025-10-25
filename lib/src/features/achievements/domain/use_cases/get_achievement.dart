import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/achievements/domain/entities/achievement.dart';
import 'package:cazzinitoh_2025/src/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:dartz/dartz.dart';

class GetAchievementUseCase {
  final AchievementRepository repository;

  GetAchievementUseCase({required this.repository});

  Future<Either<Failure, Achievement>> call(int id) {
    return repository.getAchievement(id);
  }
}

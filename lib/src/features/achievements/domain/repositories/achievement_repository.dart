import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/achievements/domain/entities/achievement.dart';
import 'package:dartz/dartz.dart';

abstract class AchievementRepository {
  Future<Either<Failure, Achievement>> getAchievement(int id);
}

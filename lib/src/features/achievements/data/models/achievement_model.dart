import 'package:cazzinitoh_2025/src/features/achievements/domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  AchievementModel({
    required super.id,
    required super.name,
    required super.description,
    required super.pictureUrl,
    required super.requisito,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      pictureUrl: json['pictureUrl'] as String,
      requisito: json['requisito'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureUrl': pictureUrl,
      'requisito': requisito,
    };
  }

  factory AchievementModel.fromEntity(Achievement achievement) {
    return AchievementModel(
      id: achievement.id,
      name: achievement.name,
      description: achievement.description,
      pictureUrl: achievement.pictureUrl,
      requisito: achievement.requisito,
    );
  }
}

import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';

class StatsModel extends Stats {
  StatsModel({
    required super.mts,
    required super.time,
    required super.matchs,
    required super.accuracy,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      mts: (json['mts'] as num).toDouble(),
      time: (json['time'] as num).toDouble(),
      matchs: json['matchs'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'mts': mts, 'time': time, 'matchs': matchs, 'accuracy': accuracy};
  }

  factory StatsModel.fromEntity(Stats stats) {
    return StatsModel(
      mts: stats.mts,
      time: stats.time,
      matchs: stats.matchs,
      accuracy: stats.accuracy,
    );
  }
}

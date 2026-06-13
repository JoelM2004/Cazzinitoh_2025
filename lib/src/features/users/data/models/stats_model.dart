import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';

class StatsModel extends Stats {
  StatsModel({
    required super.mts,
    required super.time,
    required super.matchs,
    required super.accuracy,
    required super.userId,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      mts: (json['mts'] as num).toDouble(),
      time: (json['time'] as num).toDouble(),
      matchs: json['matchs'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
      // 🟢 CORRECCIÓN: Lee directamente de 'userId' como un String
      userId: json['userId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mts': mts.toInt(), // 👈 MAGIA AQUÍ: Forzamos a que sea un entero (sin decimales)
      'time': time,
      'matchs': matchs,
      'accuracy': accuracy,
      'userId': userId,
    };
  }

  factory StatsModel.fromEntity(Stats stats) {
    return StatsModel(
      mts: stats.mts,
      time: stats.time,
      matchs: stats.matchs,
      accuracy: stats.accuracy,
      userId: stats.userId,
    );
  }
}
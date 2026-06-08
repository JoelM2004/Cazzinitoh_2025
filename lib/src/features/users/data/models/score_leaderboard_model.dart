import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/score_leaderboard.dart';

class ScoreLeaderboardModel extends ScoreLeaderboard {
  ScoreLeaderboardModel({
    required super.user,
    required super.score,
    super.isCurrentUser,
  });

  factory ScoreLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return ScoreLeaderboardModel(
      user: UserModel.fromJson(json['user']),
      score: json['score'] as int,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': UserModel.fromEntity(user).toJson(),
      'score': score,
      'isCurrentUser': isCurrentUser,
    };
  }

  factory ScoreLeaderboardModel.fromEntity(
    ScoreLeaderboard leaderboard,
  ) {
    return ScoreLeaderboardModel(
      user: UserModel.fromEntity(leaderboard.user),
      score: leaderboard.score,
      isCurrentUser: leaderboard.isCurrentUser,
    );
  }

  String get displayName =>
      user.nameTag.isNotEmpty ? user.nameTag : user.name;

  String get avatar => user.profilePictureUrl;
  String get id => user.id;
  int get edad => user.age;
  String get email => user.email;
  DateTime get fechaNacimiento => user.fechaNacimiento;
  List<int> get idAchievements => user.idAchievements;
}
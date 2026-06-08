import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';

class ScoreLeaderboard {
  final User user;
  final int score;
  final bool isCurrentUser;

  ScoreLeaderboard({
    required this.user,
    required this.score,
    this.isCurrentUser = false,
  });
}


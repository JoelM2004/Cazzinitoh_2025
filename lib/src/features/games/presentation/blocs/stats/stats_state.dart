part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState {
  final StatsStatus status;
  final Stats? stats;
  final List<ScoreLeaderboard> userScores;
  final String? errorMessage;

  const StatsState({
    this.status = StatsStatus.initial,
    this.stats,
    this.userScores = const [],
    this.errorMessage,
  });

  StatsState copyWith({
    StatsStatus? status,
    Stats? stats,
    List<ScoreLeaderboard>? userScores,
    String? errorMessage,
  }) {
    return StatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      userScores: userScores ?? this.userScores,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
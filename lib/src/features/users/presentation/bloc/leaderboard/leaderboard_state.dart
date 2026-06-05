part of 'leaderboard_bloc.dart';

sealed class LeaderboardState {}

final class LeaderboardInitial extends LeaderboardState {}

final class LeaderboardLoading extends LeaderboardState {}

final class LeaderboardSuccess extends LeaderboardState {
  final List<UserWithScore> players;
  LeaderboardSuccess({required this.players});
}

final class LeaderboardFailure extends LeaderboardState {
  final Failure failure;
  LeaderboardFailure({required this.failure});
}

part of 'leaderboard_bloc.dart';

sealed class LeaderboardEvent {}

/// Dispará este evento al entrar a la pantalla del leaderboard.
class LoadLeaderboard extends LeaderboardEvent {}

/// Resetea el estado (útil si querés limpiar al salir).
class LeaderboardReset extends LeaderboardEvent {}

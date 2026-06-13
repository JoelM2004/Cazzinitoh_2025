import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/get_stats_use_case.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/get_user_scores_usecase.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/score_leaderboard.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStatsUseCase getStats;
  final GetUserScoresUseCase getUserScores;

  StatsBloc({
    required this.getStats,
    required this.getUserScores,
  }) : super(const StatsState()) {
    on<StatsFetchRequested>(_onFetch);
  }

  Future<void> _onFetch(
    StatsFetchRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    final results = await Future.wait([
      getStats(event.userId),
      getUserScores(event.userId),
    ]);

    final statsResult = results[0] as Either;
    final scoresResult = results[1] as Either;

    if (statsResult.isLeft()) {
      emit(state.copyWith(
        status: StatsStatus.failure,
        errorMessage: statsResult.fold((f) => f.message, (_) => null),
      ));
      return;
    }

    emit(state.copyWith(
      status: StatsStatus.success,
      stats: statsResult.fold((_) => null, (s) => s as Stats),
      userScores: scoresResult.fold(
        (_) => <ScoreLeaderboard>[],
        (s) => s as List<ScoreLeaderboard>,
      ),
    ));
  }
}
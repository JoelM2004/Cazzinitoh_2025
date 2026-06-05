import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/get_leaderboard_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final GetLeaderboardUseCase _getLeaderboardUseCase;

  LeaderboardBloc(this._getLeaderboardUseCase) : super(LeaderboardInitial()) {
    on<LoadLeaderboard>((event, emit) async {
      emit(LeaderboardLoading());

      final result = await _getLeaderboardUseCase();

      result.fold(
        (failure) => emit(LeaderboardFailure(failure: failure)),
        (players) => emit(LeaderboardSuccess(players: players)),
      );
    });

    on<LeaderboardReset>((event, emit) {
      emit(LeaderboardInitial());
    });
  }
}

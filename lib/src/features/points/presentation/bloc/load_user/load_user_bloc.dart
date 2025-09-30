import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/get_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'load_user_state.dart';
part 'load_user_event.dart';

class LoadUserBloc extends Bloc<LoadUserEvent, LoadUserState> {
  final GetUserUseCase _getStatsUseCase;

  LoadUserBloc(this._getStatsUseCase) : super(LoadUserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(LoadUserLoading());

      final resp = await _getStatsUseCase(event.id);

      resp.fold(
        (f) => emit(LoadUserFailure(failure: f)),
        (p) => emit(LoadUserSuccess(user: p)),
      );
    });
  }
}

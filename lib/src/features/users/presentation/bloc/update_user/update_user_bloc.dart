import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/update.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_user_state.dart';
part 'update_user_event.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UpdateUseCase _UpdateUseCase;

  UpdateUserBloc(this._UpdateUseCase) : super(UpdateUserInitial()) {
    // Evento de Update
    on<UpdateUser>((event, emit) async {
      emit(UpdateUserLoading());

      final resp = await _UpdateUseCase(event.name, event.nameTag, event.age);

      resp.fold(
        (f) => emit(UpdateUserFailure(failure: f)),
        (user) => emit(UpdateUserSuccess(user: user)),
      );
    });

    // Evento de reset (opcional pero útil)
    on<UpdateUserReset>((event, emit) => emit(UpdateUserInitial()));
  }
}

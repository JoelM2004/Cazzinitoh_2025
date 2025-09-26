import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_user_state.dart';
part 'register_user_event.dart';

class RegisterUserBloc extends Bloc<RegisterUserEvent, RegisterUserState> {
  final RegisterUseCase _RegisterUseCase;

  RegisterUserBloc(this._RegisterUseCase) : super(RegisterUserInitial()) {
    // Evento de Register
    on<RegisterUser>((event, emit) async {
      emit(RegisterUserLoading());

      final resp = await _RegisterUseCase(event.email, event.password);

      resp.fold(
        (f) => emit(RegisterUserFailure(failure: f)),
        (user) => emit(RegisterUserSuccess(user: user)),
      );
    });

    // Evento de reset (opcional pero útil)
    on<RegisterUserReset>((event, emit) => emit(RegisterUserInitial()));
  }
}

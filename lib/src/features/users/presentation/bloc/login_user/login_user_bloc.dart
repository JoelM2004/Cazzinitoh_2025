import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_user_state.dart';
part 'login_user_event.dart';

class LoginUserBloc extends Bloc<LoginUserEvent, LoginUserState> {
  final LoginUseCase _loginUseCase;

  LoginUserBloc(this._loginUseCase) : super(LoginUserInitial()) {
    // Evento de login
    on<LoginUser>((event, emit) async {
      emit(LoginUserLoading());

      final resp = await _loginUseCase(event.email, event.password);

      resp.fold(
        (f) => emit(LoginUserFailure(failure: f)),
        (user) => emit(LoginUserSuccess(user: user)),
      );
    });

    // Evento de reset (opcional pero útil)
    on<LoginUserReset>((event, emit) => emit(LoginUserInitial()));
  }
}

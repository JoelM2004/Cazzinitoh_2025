part of 'login_user_bloc.dart';

sealed class LoginUserState {}

final class LoginUserInitial extends LoginUserState {}

final class LoginUserLoading extends LoginUserState {}

final class LoginUserSuccess extends LoginUserState {
  final bool user;
  LoginUserSuccess({required this.user});
}

final class LoginUserFailure extends LoginUserState {
  final Failure failure;
  LoginUserFailure({required this.failure});
}

part of 'register_user_bloc.dart';

sealed class RegisterUserState {}

final class RegisterUserInitial extends RegisterUserState {}

final class RegisterUserLoading extends RegisterUserState {}

final class RegisterUserSuccess extends RegisterUserState {
  final bool user;
  RegisterUserSuccess({required this.user});
}

final class RegisterUserFailure extends RegisterUserState {
  final Failure failure;
  RegisterUserFailure({required this.failure});
}

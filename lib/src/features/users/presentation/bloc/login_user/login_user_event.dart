part of 'login_user_bloc.dart';

sealed class LoginUserEvent {}

class LoginUser extends LoginUserEvent {
  final String email;
  final String password;
  LoginUser({required this.email, required this.password});
}

class LoginUserReset extends LoginUserEvent {}

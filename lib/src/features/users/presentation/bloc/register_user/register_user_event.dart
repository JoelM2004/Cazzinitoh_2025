part of 'register_user_bloc.dart';

sealed class RegisterUserEvent {}

class RegisterUser extends RegisterUserEvent {
  final String email;
  final String password;
  RegisterUser({required this.email, required this.password});
}

class RegisterUserReset extends RegisterUserEvent {}

part of 'update_user_bloc.dart';

sealed class UpdateUserEvent {}

class UpdateUser extends UpdateUserEvent {
  final String name;
  final String nameTag;
  final int age;
  UpdateUser({required this.name, required this.nameTag, required this.age});
}

class UpdateUserReset extends UpdateUserEvent {}

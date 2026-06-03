part of 'update_user_bloc.dart';

sealed class UpdateUserEvent {}

class UpdateUser extends UpdateUserEvent {
  final String name;
  final String nameTag;
  final DateTime fechaNacimiento;
  final String? profilePictureUrl; // <-- nuevo (null = no cambió)

  UpdateUser({
    required this.name,
    required this.nameTag,
    required this.fechaNacimiento,
    this.profilePictureUrl,
  });
}

class UpdateUserReset extends UpdateUserEvent {}
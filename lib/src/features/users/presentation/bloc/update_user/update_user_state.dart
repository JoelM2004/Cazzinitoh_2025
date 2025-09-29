part of 'update_user_bloc.dart';

sealed class UpdateUserState {}

final class UpdateUserInitial extends UpdateUserState {}

final class UpdateUserLoading extends UpdateUserState {}

final class UpdateUserSuccess extends UpdateUserState {
  final bool user;
  UpdateUserSuccess({required this.user});
}

final class UpdateUserFailure extends UpdateUserState {
  final Failure failure;
  UpdateUserFailure({required this.failure});
}

part of 'load_user_bloc.dart';

sealed class LoadUserState {}

final class LoadUserInitial extends LoadUserState {}

final class LoadUserLoading extends LoadUserState {}

final class LoadUserSuccess extends LoadUserState {
  final User user;
  LoadUserSuccess({required this.user});
}

final class LoadUserFailure extends LoadUserState {
  final Failure failure;
  LoadUserFailure({required this.failure});
}

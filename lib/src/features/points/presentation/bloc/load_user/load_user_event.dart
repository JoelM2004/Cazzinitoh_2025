part of 'load_user_bloc.dart';

sealed class LoadUserEvent {}

class LoadUser extends LoadUserEvent {
  final int id;
  LoadUser({required this.id});
}

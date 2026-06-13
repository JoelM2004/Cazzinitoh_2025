part of 'stats_bloc.dart';

// stats_event.dart
abstract class StatsEvent {}

class StatsFetchRequested extends StatsEvent {
  final String userId;
  StatsFetchRequested(this.userId);
}
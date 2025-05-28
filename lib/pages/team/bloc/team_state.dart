part of 'team_bloc.dart';

@immutable
sealed class TeamState {}

final class TeamInitial extends TeamState {
  TeamInitial() {
    print('TeamState initial');
  }
}

final class TeamCreated extends TeamState {}

final class TeamCreationFailed extends TeamState {}

final class TeamLoadInProgress extends TeamState {}

final class TeamLoadSuccess extends TeamState {
  final dynamic team;

  TeamLoadSuccess({required this.team});
}

class Loaded extends TeamState {
  Loaded() {
    print('TeamState loaded');
  }
}

class Loading extends TeamState {
  Loading() {
    print('TeamState loading');
  }
}

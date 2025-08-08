part of 'team_bloc.dart';

@immutable
sealed class TeamState {}

final class TeamInitial extends TeamState {
  TeamInitial() {
    print('TeamState initial');
  }
}

final class TeamCreatedSuccess extends TeamState {}

final class TeamCreationError extends TeamState {}

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

class LoadingTeam extends TeamState {
  Loading() {
    print('TeamState loading team');
  }
}

final class TeamDeleted extends TeamState {
  final String teamId;
  TeamDeleted({required this.teamId}) {
    print('TeamState deleted');
  }
}

final class TeamDeletionFailed extends TeamState {}

final class TeamJoinedSuccess extends TeamState {
  TeamJoinedSuccess() {
    print('TeamState joined successfully');
  }
}

final class TeamJoinError extends TeamState {
  final String message;
  TeamJoinError({required this.message}) {
    print('TeamState join error: $message');
  }
}

class TeamMembersLoaded extends TeamState {
  final Team members;
  TeamMembersLoaded(this.members);
}

class TeamMembersError extends TeamState {
  final String message;
  TeamMembersError(this.message);
}

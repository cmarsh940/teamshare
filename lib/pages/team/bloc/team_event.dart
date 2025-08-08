part of 'team_bloc.dart';

@immutable
sealed class TeamEvent {}

class TeamCreateEvent extends TeamEvent {
  final dynamic team;

  TeamCreateEvent({required this.team});
}

class TeamLoadEvent extends TeamEvent {
  final String teamId;

  TeamLoadEvent({required this.teamId});
}

class LoadForm extends TeamEvent {
  LoadForm() {}
}

class DeleteTeamEvent extends TeamEvent {
  final String teamId;

  DeleteTeamEvent({required this.teamId});
}

class JoinTeamEvent extends TeamEvent {
  final String teamCode;
  final String userId;

  JoinTeamEvent({required this.teamCode, required this.userId});
}

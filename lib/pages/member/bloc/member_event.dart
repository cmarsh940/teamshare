part of 'member_bloc.dart';

@immutable
sealed class MemberEvent {}

class LoadMembers extends MemberEvent {
  final String teamId;

  LoadMembers(this.teamId);
}

class RemoveMemberFromTeam extends MemberEvent {
  final String teamId;
  final String userId;

  RemoveMemberFromTeam(this.teamId, this.userId);
}

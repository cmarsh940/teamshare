part of 'member_bloc.dart';

@immutable
sealed class MemberEvent {}

class LoadMembers extends MemberEvent {
  final String teamId;

  LoadMembers(this.teamId);
}

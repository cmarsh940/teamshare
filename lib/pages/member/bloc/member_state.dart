part of 'member_bloc.dart';

@immutable
sealed class MemberState {}

final class MemberInitial extends MemberState {}

final class MembersLoading extends MemberState {}

final class MembersLoaded extends MemberState {
  final List<String> members;

  MembersLoaded(this.members);
}

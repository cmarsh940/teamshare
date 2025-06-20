part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

class LoadTeamPosts extends PostEvent {
  final String teamId;

  LoadTeamPosts(this.teamId);
}

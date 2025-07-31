part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

class LoadTeamPosts extends PostEvent {
  final String teamId;

  LoadTeamPosts(this.teamId);
}

class AddPost extends PostEvent {
  final Post post;
  final String teamId;
  final List<PlatformFile>? attachments;

  AddPost(this.post, this.teamId, this.attachments);
}

class LikePost extends PostEvent {
  final String postId;
  final String userId;
  final List<Post> posts;

  LikePost(this.postId, this.userId, this.posts);
}

class UnlikePost extends PostEvent {
  final String postId;
  final String userId;
  final List<Post> posts;

  UnlikePost(this.postId, this.userId, this.posts);
}

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
  final String teamId;

  LikePost(this.postId, this.userId, this.posts, this.teamId);
}

class UnlikePost extends PostEvent {
  final String postId;
  final String userId;
  final List<Post> posts;
  final String teamId;

  UnlikePost(this.postId, this.userId, this.posts, this.teamId);
}

class LoadComments extends PostEvent {
  final String postId;
  final List<Post> posts;
  final String teamId;

  LoadComments(this.postId, this.posts, this.teamId);
}

class AddComment extends PostEvent {
  final String postId;
  final Comment comment;
  final String userId;
  final List<Post> posts;
  final String teamId;

  AddComment(this.postId, this.comment, this.userId, this.posts, this.teamId);
}

class LikeComment extends PostEvent {
  final String postId;
  final String commentId;
  final String userId;
  final List<Post> posts;
  final String teamId;

  LikeComment(
    this.postId,
    this.commentId,
    this.userId,
    this.posts,
    this.teamId,
  );
}

class UnlikeComment extends PostEvent {
  final String postId;
  final String commentId;
  final String userId;
  final List<Post> posts;
  final String teamId;

  UnlikeComment(
    this.postId,
    this.commentId,
    this.userId,
    this.posts,
    this.teamId,
  );
}

class RefreshPosts extends PostEvent {
  final String teamId;

  RefreshPosts(this.teamId);
}

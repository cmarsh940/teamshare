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

class LoadComments extends PostEvent {
  final String postId;
  final List<Post> posts;

  LoadComments(this.postId, this.posts);
}

class AddComment extends PostEvent {
  final String postId;
  final Comment comment;
  final String userId;
  final List<Post> posts;

  AddComment(this.postId, this.comment, this.userId, this.posts);
}

class LikeComment extends PostEvent {
  final String postId;
  final String commentId;
  final String userId;
  final List<Post> posts;

  LikeComment(this.postId, this.commentId, this.userId, this.posts);
}

class UnlikeComment extends PostEvent {
  final String postId;
  final String commentId;
  final String userId;
  final List<Post> posts;

  UnlikeComment(this.postId, this.commentId, this.userId, this.posts);
}

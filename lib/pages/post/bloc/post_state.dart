part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);
}

final class PostError extends PostState {
  final String message;

  PostError(this.message);
}

final class PostEmpty extends PostState {}

final class PostAdded extends PostState {
  final Post post;

  PostAdded(this.post);
}

final class PostLiked extends PostState {
  final String postId;
  final String userId;
  final List<Post> posts;

  PostLiked(this.postId, this.userId, this.posts);
}

final class PostUnliked extends PostState {
  final String postId;
  final String userId;
  final List<Post> posts;

  PostUnliked(this.postId, this.userId, this.posts);
}

final class CommentsLoaded extends PostState {
  final String postId;
  final List<Comment> comments;
  final List<Post> posts; // <-- add this

  CommentsLoaded(this.postId, this.comments, this.posts);
}

final class CommentAdded extends PostState {
  final String postId;
  final Comment comment;
  final List<Post> posts;
  final List<Comment> comments;

  CommentAdded(this.postId, this.comment, this.posts, this.comments);
}

class CommentLiked extends PostState {
  final String postId;
  final List<Comment> comments;
  final List<Post> posts;

  CommentLiked(this.postId, this.comments, this.posts);
}

class CommentUnliked extends PostState {
  final String postId;
  final List<Comment> comments;
  final List<Post> posts;

  CommentUnliked(this.postId, this.comments, this.posts);
}

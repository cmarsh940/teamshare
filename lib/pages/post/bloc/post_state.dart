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

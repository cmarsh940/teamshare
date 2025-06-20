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

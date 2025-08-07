import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/models/comment.dart';
import 'package:teamshare/models/post.dart';
import '../../../utils/app_logger.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final TeamRepository _teamRepository = GetIt.instance<TeamRepository>();

  PostBloc() : super(PostInitial()) {
    on<LoadTeamPosts>(_mapLoadTeamPostsToState);
    on<AddPost>(_mapAddPostToState);
    on<LikePost>(_mapLikePostToState);
    on<UnlikePost>(_mapUnlikePostToState);
    on<LoadComments>(_mapLoadCommentsToState);
    on<AddComment>(_mapAddCommentToState);
    on<LikeComment>(_mapLikeCommentToState);
    on<UnlikeComment>(_mapUnlikeCommentToState);
  }

  _mapLoadTeamPostsToState(LoadTeamPosts event, Emitter<PostState> emit) async {
    AppLogger.info('Loading posts for team: ${event.teamId}');
    emit(PostLoading());
    try {
      final posts = await _teamRepository.getTeamPosts(event.teamId);
      AppLogger.info('Loaded ${posts.length} posts for team: ${event.teamId}');
      if (posts.isEmpty) {
        emit(PostEmpty());
      } else {
        emit(PostLoaded(posts));
      }
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  _mapAddPostToState(AddPost event, Emitter<PostState> emit) async {
    AppLogger.info('Adding post: ${event.post.title}');
    try {
      await _teamRepository.addPost(event.post, event.teamId);
      emit(PostAdded(event.post));
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  _mapLikePostToState(LikePost event, Emitter<PostState> emit) async {
    AppLogger.info('Liking post: ${event.postId} by user: ${event.userId}');
    try {
      await _teamRepository.likePost(event.postId, event.userId);

      for (var post in event.posts) {
        if (post.id == event.postId) {
          post.likes ??= [];
          if (!post.likes!.contains(event.userId)) {
            post.likes!.add(event.userId);
          }
          break;
        }
      }
      emit(PostLiked(event.postId, event.userId, event.posts));
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  _mapUnlikePostToState(UnlikePost event, Emitter<PostState> emit) async {
    AppLogger.info('Unliking post: ${event.postId} by user: ${event.userId}');
    try {
      await _teamRepository.likePost(event.postId, event.userId);

      for (var post in event.posts) {
        if (post.id == event.postId) {
          post.likes ??= [];
          post.likes!.remove(event.userId);
          break;
        }
      }
      emit(PostUnliked(event.postId, event.userId, event.posts));
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  _mapLoadCommentsToState(LoadComments event, Emitter<PostState> emit) async {
    AppLogger.info('Loading comments for post: ${event.postId}');
    emit(PostLoading());
    try {
      List<Comment> comments = await _teamRepository.getCommentsForPost(
        event.postId,
      );
      AppLogger.info(
        'Loaded ${comments.length} comments for post: ${event.postId}',
      );
      if (comments.isEmpty) {
        emit(PostEmpty());
      } else {
        emit(CommentsLoaded(event.postId, comments, event.posts));
      }
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  _mapAddCommentToState(AddComment event, Emitter<PostState> emit) async {
    try {
      final updatedPost = await _teamRepository.addComment(
        event.postId,
        event.comment,
        event.userId,
      );

      // Update the posts list with the new post
      final updatedPosts =
          event.posts.map((post) {
            if (post.id == updatedPost.id) {
              return updatedPost;
            }
            return post;
          }).toList();

      // Get the updated comments list
      final updatedComments = updatedPost.comments ?? [];

      emit(
        CommentAdded(
          event.postId,
          event.comment,
          updatedPosts,
          updatedComments,
        ),
      );
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  void _mapLikeCommentToState(
    LikeComment event,
    Emitter<PostState> emit,
  ) async {
    try {
      // Get current state's comments
      List<Comment> currentComments = [];
      if (state is CommentsLoaded) {
        currentComments = (state as CommentsLoaded).comments;
      } else if (state is CommentLiked) {
        currentComments = (state as CommentLiked).comments;
      } else if (state is CommentUnliked) {
        currentComments = (state as CommentUnliked).comments;
      } else if (state is CommentAdded) {
        currentComments = (state as CommentAdded).comments;
      } else {
        // fallback: try to get from the post in event.posts
        Post? post;
        for (final p in event.posts) {
          if (p.id == event.postId) {
            post = p;
            break;
          }
        }
        if (post != null && post.comments != null) {
          currentComments = post.comments!;
        }
      }

      final success = await _teamRepository.likeComment(
        event.postId,
        event.commentId,
        event.userId,
      );

      if (success) {
        // Locally update likedBy for the comment
        final updatedComments =
            currentComments.map((comment) {
              if (comment.id == event.commentId) {
                final likedBy = List<String>.from(comment.likedBy ?? []);
                if (!likedBy.contains(event.userId)) {
                  likedBy.add(event.userId);
                }
                return comment.copyWith(likedBy: likedBy);
              }
              return comment;
            }).toList();

        // Update the post in our posts list
        final updatedPosts =
            event.posts.map((post) {
              if (post.id == event.postId) {
                return post.copyWith(comments: updatedComments);
              }
              return post;
            }).toList();

        emit(CommentsLoaded(event.postId, updatedComments, updatedPosts));
      }
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  void _mapUnlikeCommentToState(
    UnlikeComment event,
    Emitter<PostState> emit,
  ) async {
    try {
      // Get current state's comments
      List<Comment> currentComments = [];
      if (state is CommentsLoaded) {
        currentComments = (state as CommentsLoaded).comments;
      } else if (state is CommentLiked) {
        currentComments = (state as CommentLiked).comments;
      } else if (state is CommentUnliked) {
        currentComments = (state as CommentUnliked).comments;
      } else if (state is CommentAdded) {
        currentComments = (state as CommentAdded).comments;
      } else {
        // fallback: try to get from the post in event.posts
        Post? post;
        for (final p in event.posts) {
          if (p.id == event.postId) {
            post = p;
            break;
          }
        }
        if (post != null && post.comments != null) {
          currentComments = post.comments!;
        }
      }

      final success = await _teamRepository.likeComment(
        event.postId,
        event.commentId,
        event.userId,
      );

      if (success) {
        // Locally update likedBy for the comment
        final updatedComments =
            currentComments.map((comment) {
              if (comment.id == event.commentId) {
                final likedBy = List<String>.from(comment.likedBy ?? []);
                likedBy.remove(event.userId);
                return comment.copyWith(likedBy: likedBy);
              }
              return comment;
            }).toList();

        // Update the post in our posts list
        final updatedPosts =
            event.posts.map((post) {
              if (post.id == event.postId) {
                return post.copyWith(comments: updatedComments);
              }
              return post;
            }).toList();

        emit(CommentsLoaded(event.postId, updatedComments, updatedPosts));
      }
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }
}

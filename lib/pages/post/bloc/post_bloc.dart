import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/models/post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final TeamRepository _teamRepository = GetIt.instance<TeamRepository>();

  PostBloc() : super(PostInitial()) {
    on<LoadTeamPosts>(_mapLoadTeamPostsToState);
    on<AddPost>(_mapAddPostToState);
    on<LikePost>(_mapLikePostToState);
    on<UnlikePost>(_mapUnlikePostToState);
  }

  _mapLoadTeamPostsToState(LoadTeamPosts event, Emitter<PostState> emit) async {
    print('Loading posts for team: ${event.teamId}');
    emit(PostLoading());
    try {
      final posts = await _teamRepository.getTeamPosts(event.teamId);
      print('Loaded ${posts.length} posts for team: ${event.teamId}');
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
    print('Adding post: ${event.post.title}');
    try {
      await _teamRepository.addPost(event.post, event.teamId);
      emit(PostAdded(event.post));
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  _mapLikePostToState(LikePost event, Emitter<PostState> emit) async {
    print('Liking post: ${event.postId} by user: ${event.userId}');
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
    print('Unliking post: ${event.postId} by user: ${event.userId}');
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
}

import 'dart:math';

import 'package:bloc/bloc.dart';
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
  }

  _mapLoadTeamPostsToState(LoadTeamPosts event, Emitter<PostState> emit) async {
    print('Loading posts for team: ${event.teamId}');
    emit(PostLoading());
    try {
      final posts = await _teamRepository.getTeamPosts(event.teamId);
      if (posts.isEmpty) {
        emit(PostEmpty());
      } else {
        emit(PostLoaded(posts));
      }
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }
}

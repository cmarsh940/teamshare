import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';
import 'package:teamshare/pages/post/widgets/create_post_form.dart';
import 'package:teamshare/pages/post/widgets/post_list.dart';

class PostPage extends StatelessWidget {
  final String userId;
  final String teamId;

  const PostPage({super.key, required this.teamId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create:
          (_) => GetIt.I<PostBloc>(param1: teamId)..add(LoadTeamPosts(teamId)),
      child: Builder(
        builder: (ctx) {
          final postBloc = ctx.read<PostBloc>();
          return Scaffold(
            body: PostList(teamId: teamId, userId: userId),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(ctx)
                    .push(
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: postBloc,
                              child: CreatePostForm(
                                teamId: teamId,
                                userId: userId,
                              ),
                            ),
                      ),
                    )
                    .then((_) => postBloc.add(RefreshPosts(teamId)));
              },
              tooltip: 'Add Post',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

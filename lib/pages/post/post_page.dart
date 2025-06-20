import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';
import 'package:teamshare/pages/post/widgets/post_list.dart';

class PostPage extends StatelessWidget {
  final String teamId;

  const PostPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<PostBloc>(
          create: (context) => PostBloc(),
          child: PostList(teamId: teamId),
        ),
      ),
    );
  }
}

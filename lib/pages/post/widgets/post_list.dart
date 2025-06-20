import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';

class PostList extends StatefulWidget {
  final String teamId;

  const PostList({super.key, required this.teamId});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostInitial) {
          _postBloc.add(LoadTeamPosts(widget.teamId));
        }
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostLoaded) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final notification = state.posts[index];
              return Text('data');
            },
          );
        } else if (state is PostEmpty) {
          return const Center(
            child: Text(
              'No posts available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else if (state is PostError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }
        return const Center(
          child: Text(
            'No posts available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _postBloc.close();
    super.dispose();
  }
}

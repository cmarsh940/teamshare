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
    return Scaffold(
      body: PostList(teamId: teamId, userId: userId),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostForm(teamId: teamId),
            ),
          );
        },
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}

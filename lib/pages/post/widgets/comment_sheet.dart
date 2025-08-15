import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/models/comment.dart';
import 'package:teamshare/models/post.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';

class CommentsSheet extends StatefulWidget {
  final String postId;
  final List<Post> posts;
  final String teamId;
  final String userId;
  final List<Comment>? initialComments;

  const CommentsSheet({
    required this.postId,
    required this.posts,
    required this.teamId,
    required this.userId,
    this.initialComments,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Comment> _deriveComments(PostState state) {
    if (state is CommentsLoaded && state.postId == widget.postId) {
      return state.comments.reversed.toList();
    }
    if (state is CommentAdded && state.postId == widget.postId) {
      return state.comments.reversed.toList();
    }
    return (widget.initialComments ?? []).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Comments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  final comments = _deriveComments(state);
                  if (comments.isEmpty) {
                    return const Center(child: Text('No comments yet'));
                  }
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (_, idx) {
                      final c = comments[idx];
                      final liked = c.likedBy?.contains(widget.userId) ?? false;
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (c.author?.firstName != null)
                              Text(
                                '${c.author!.firstName} ${c.author!.lastName ?? ''}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            Text(
                              c.body ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                liked ? Icons.favorite : Icons.favorite_border,
                                size: 18,
                                color: liked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                final bloc = context.read<PostBloc>();
                                if (liked) {
                                  bloc.add(
                                    UnlikeComment(
                                      widget.postId,
                                      c.id!,
                                      widget.userId,
                                      widget.posts,
                                      widget.teamId,
                                    ),
                                  );
                                } else {
                                  bloc.add(
                                    LikeComment(
                                      widget.postId,
                                      c.id!,
                                      widget.userId,
                                      widget.posts,
                                      widget.teamId,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${c.likedBy?.length ?? 0}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final comment = Comment(
      '',
      text,
      null,
      null,
      widget.postId,
      DateTime.now().toIso8601String(),
      null,
      null,
    );
    context.read<PostBloc>().add(
      AddComment(
        widget.postId,
        comment,
        widget.userId,
        widget.posts,
        widget.teamId,
      ),
    );
    _controller.clear();
  }
}

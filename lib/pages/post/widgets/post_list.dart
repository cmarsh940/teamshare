import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/models/comment.dart';
import 'package:teamshare/models/post.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';
import 'package:teamshare/pages/post/widgets/comment_sheet.dart';

class PostList extends StatefulWidget {
  final String teamId;
  final String userId;

  const PostList({super.key, required this.teamId, required this.userId});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  String userId = '';
  List<Post> _cachedPosts = [];

  @override
  void initState() {
    userId = widget.userId;
    super.initState();
  }

  @override
  void didUpdateWidget(PostList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      setState(() {
        userId = widget.userId;
      });
    }
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        // Loading
        if (state is PostLoading ||
            (state is PostInitial && _cachedPosts.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        // Always start from cached
        var posts = _cachedPosts;

        // Update cache only for states that include posts
        if (state is PostLoaded) {
          posts = state.posts;
          if (posts.isNotEmpty) _cachedPosts = posts;
        } else if (state is PostLiked) {
          posts = state.posts;
          _cachedPosts = posts;
        } else if (state is PostUnliked) {
          posts = state.posts;
          _cachedPosts = posts;
        } else if (state is CommentAdded) {
          posts = state.posts;
          _cachedPosts = posts;
        } else if (state is CommentLiked) {
          posts = state.posts;
          _cachedPosts = posts;
        } else if (state is CommentUnliked) {
          posts = state.posts;
          _cachedPosts = posts;
        }
        // IMPORTANT: Do NOT overwrite with CommentsLoaded if that state
        // does not contain the full posts list (prevents clearing UI).
        // Leave CommentsLoaded to just update the bottom sheet.

        if (posts.isEmpty) {
          if (state is PostError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No posts available'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                post.author?.picture != null
                                    ? NetworkImage(post.author!.picture!)
                                    : null,
                            child:
                                post.author?.picture == null
                                    ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${post.author?.firstName ?? ''} ${post.author?.lastName ?? ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            post.createdAt != null
                                ? timeAgo(
                                  post.createdAt is DateTime
                                      ? post.createdAt as DateTime
                                      : DateTime.parse(
                                        post.createdAt.toString(),
                                      ),
                                )
                                : '',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (post.title != null && post.title!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            post.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      if (post.body != null && post.body!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            post.body!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              post.likes != null && post.likes!.contains(userId)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  post.likes != null &&
                                          post.likes!.contains(userId)
                                      ? Colors.red
                                      : Colors.grey[700],
                            ),
                            onPressed: () {
                              final bloc = context.read<PostBloc>();
                              if (post.likes != null &&
                                  post.likes!.contains(userId)) {
                                bloc.add(
                                  UnlikePost(
                                    post.id!,
                                    userId,
                                    posts,
                                    widget.teamId,
                                  ),
                                );
                              } else {
                                bloc.add(
                                  LikePost(
                                    post.id!,
                                    userId,
                                    posts,
                                    widget.teamId,
                                  ),
                                );
                              }
                            },
                          ),
                          Text('${post.likes?.length ?? 0}'),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.mode_comment_outlined),
                            onPressed: () {
                              final bloc =
                                  context.read<PostBloc>(); // capture once
                              bloc.add(
                                LoadComments(post.id!, posts, widget.teamId),
                              );
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(18),
                                  ),
                                ),
                                builder: (sheetCtx) {
                                  return BlocProvider.value(
                                    value: bloc,
                                    child: CommentsSheet(
                                      postId: post.id!,
                                      posts: posts,
                                      teamId: widget.teamId,
                                      userId: userId,
                                      initialComments: post.comments,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Text('${post.comments?.length ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _stateHasPosts(PostState state) {
    return state is PostLoaded ||
        state is PostLiked ||
        state is PostUnliked ||
        state is CommentsLoaded ||
        state is CommentAdded ||
        state is CommentLiked ||
        state is CommentUnliked;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

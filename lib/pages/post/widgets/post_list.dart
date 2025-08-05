import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/repositories.dart';
import 'package:teamshare/models/comment.dart';
import 'package:teamshare/models/post.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';

class PostList extends StatefulWidget {
  final String teamId;
  final String userId;

  const PostList({super.key, required this.teamId, required this.userId});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late PostBloc _postBloc;
  late final String userId;

  @override
  void initState() {
    userId = widget.userId;
    super.initState();
    _postBloc = GetIt.I<PostBloc>();
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
    return BlocListener<PostBloc, PostState>(
      bloc: _postBloc,
      listener: (context, state) {
        // Optionally show snackbars or handle side effects here
      },
      child: BlocBuilder<PostBloc, PostState>(
        bloc: _postBloc,
        builder: (context, state) {
          if (state is PostInitial) {
            _postBloc.add(LoadTeamPosts(widget.teamId));
          }
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded ||
              state is PostLiked ||
              state is PostUnliked ||
              state is CommentsLoaded ||
              state is CommentAdded ||
              state is CommentLiked ||
              state is CommentUnliked) {
            final posts = (state as dynamic).posts;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
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
                          // Author row
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
                          // Instagram-style actions row
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  post.likes != null &&
                                          post.likes!.contains(userId)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      post.likes != null &&
                                              post.likes!.contains(userId)
                                          ? Colors.red
                                          : Colors.grey[700],
                                ),
                                onPressed: () {
                                  if (post.likes != null &&
                                      post.likes!.contains(userId)) {
                                    _postBloc.add(
                                      UnlikePost(post.id!, userId, posts),
                                    );
                                  } else {
                                    _postBloc.add(
                                      LikePost(post.id!, userId, posts),
                                    );
                                  }
                                },
                              ),
                              Text('${post.likes?.length ?? 0}'),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.mode_comment_outlined),
                                onPressed: () {
                                  _postBloc.add(LoadComments(post.id, posts));
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                    ),
                                    builder: (context) {
                                      return BlocBuilder<PostBloc, PostState>(
                                        bloc: _postBloc,
                                        builder: (context, state) {
                                          List<Comment> comments = [];
                                          if (state is CommentsLoaded &&
                                              state.postId == post.id) {
                                            comments =
                                                state.comments.reversed
                                                    .toList();
                                          } else if (state is CommentAdded &&
                                              state.postId == post.id) {
                                            comments =
                                                state.comments.reversed
                                                    .toList();
                                          } else if (post.comments != null) {
                                            comments =
                                                post.comments!.reversed
                                                    .toList();
                                          }
                                          final TextEditingController
                                          _commentController =
                                              TextEditingController();

                                          return Padding(
                                            padding:
                                                MediaQuery.of(
                                                  context,
                                                ).viewInsets,
                                            child: SizedBox(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.6,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(16),
                                                    child: Text(
                                                      'Comments',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(height: 1),
                                                  Expanded(
                                                    child:
                                                        comments.isEmpty
                                                            ? const Center(
                                                              child: Text(
                                                                'No comments yet',
                                                              ),
                                                            )
                                                            : ListView.builder(
                                                              itemCount:
                                                                  comments
                                                                      .length,
                                                              itemBuilder: (
                                                                context,
                                                                idx,
                                                              ) {
                                                                final comment =
                                                                    comments[idx];
                                                                // Adjust this if your comment is an object
                                                                return ListTile(
                                                                  leading: const CircleAvatar(
                                                                    child: Icon(
                                                                      Icons
                                                                          .person,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      size: 18,
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey,
                                                                    radius: 18,
                                                                  ),
                                                                  title: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (comment.author !=
                                                                              null &&
                                                                          comment.author?.firstName !=
                                                                              null)
                                                                        Text(
                                                                          '${comment.author!.firstName} ${comment.author!.lastName ?? ''}',
                                                                          style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.grey,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      Text(
                                                                        comment.body ??
                                                                            '',
                                                                        style: const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  trailing: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      IconButton(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        constraints:
                                                                            const BoxConstraints(),
                                                                        icon: Icon(
                                                                          comment.likedBy !=
                                                                                      null &&
                                                                                  comment.likedBy!.contains(
                                                                                    userId,
                                                                                  )
                                                                              ? Icons.favorite
                                                                              : Icons.favorite_border,
                                                                          color:
                                                                              comment.likedBy !=
                                                                                          null &&
                                                                                      comment.likedBy!.contains(
                                                                                        userId,
                                                                                      )
                                                                                  ? Colors.red
                                                                                  : Colors.grey,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                        onPressed: () {
                                                                          if (comment.likedBy !=
                                                                                  null &&
                                                                              comment.likedBy!.contains(
                                                                                userId,
                                                                              )) {
                                                                            _postBloc.add(
                                                                              UnlikeComment(
                                                                                post.id!,
                                                                                comment.id!,
                                                                                userId,
                                                                                posts,
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            _postBloc.add(
                                                                              LikeComment(
                                                                                post.id!,
                                                                                comment.id!,
                                                                                userId,
                                                                                posts,
                                                                              ),
                                                                            );
                                                                          }
                                                                        },
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        '${comment.likedBy?.length ?? 0}',
                                                                        style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            2,
                                                                      ),
                                                                  minVerticalPadding:
                                                                      0,
                                                                  dense: true,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    side: BorderSide(
                                                                      color:
                                                                          Colors
                                                                              .grey[200]!,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                  ),
                                                  const Divider(height: 1),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 8,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextField(
                                                            controller:
                                                                _commentController,
                                                            decoration: const InputDecoration(
                                                              hintText:
                                                                  'Add a comment...',
                                                              border:
                                                                  OutlineInputBorder(),
                                                              isDense: true,
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        12,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.send,
                                                            color: Colors.blue,
                                                          ),
                                                          onPressed: () {
                                                            final text =
                                                                _commentController
                                                                    .text
                                                                    .trim();
                                                            if (text
                                                                .isNotEmpty) {
                                                              var comment = Comment(
                                                                '', // id
                                                                text, // text
                                                                null, // authorId
                                                                null,
                                                                post.id!, // postId
                                                                DateTime.now()
                                                                    .toIso8601String(),
                                                                null,
                                                                null,
                                                              );
                                                              _postBloc.add(
                                                                AddComment(
                                                                  post.id!,
                                                                  comment,
                                                                  userId,
                                                                  posts,
                                                                ),
                                                              );
                                                              _commentController
                                                                  .clear();
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
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
      ),
    );
  }

  @override
  void dispose() {
    _postBloc.close();
    super.dispose();
  }
}

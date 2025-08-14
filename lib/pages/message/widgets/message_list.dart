import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';
import 'package:teamshare/pages/message/widgets/view_message.dart';

class MessageList extends StatefulWidget {
  final String userId;
  final String? teamId;
  final bool isTeamMessages;

  const MessageList({
    super.key,
    required this.userId,
    this.teamId,
    required this.isTeamMessages,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  // No local bloc refs needed; provided by parent

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is LoadingMessages) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatLoaded) {
          if (state.messages.isEmpty) {
            return const Center(
              child: Text(
                'No messages available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            itemCount: state.messages.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = state.messages[index];

              final participants =
                  (chat.participants ?? [])
                      .where((u) => _userId(u) != widget.userId)
                      .map<String>((u) => _userDisplayName(u))
                      .where((name) => name.isNotEmpty)
                      .toList();

              final chatTitle =
                  participants.isNotEmpty
                      ? participants.join(', ')
                      : (chat.groupName ?? 'Unknown chat');

              final lastBody = chat.lastMessage?.body ?? '';
              final timeLabel = _formatTimestamp(
                chat.lastMessage?.createdAt ?? chat.updatedAt,
              );

              final initials = _initialsFromName(chatTitle);

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blueGrey.shade100,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chatTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    lastBody.isEmpty ? 'No messages yet' : lastBody,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                ),
                onTap: () {
                  final bloc =
                      context.read<MessageBloc>(); // capture before nav
                  final teamId = widget.teamId;
                  final isTeamMessages = widget.isTeamMessages;
                  final userId = widget.userId;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider<MessageBloc>.value(
                            value: bloc,
                            child: ViewMessage(
                              chatId: chat.id ?? 'ohhhhNO',
                              currentUserId: userId,
                              chatTitle: chat.groupName ?? chatTitle,
                            ),
                          ),
                    ),
                  ).then((_) {
                    if (!mounted) return; // prevent using deactivated context
                    bloc.add(LoadChats(teamId, isTeamMessages, userId));
                  });
                },
              );
            },
          );
        } else if (state is ErrorLoadingMessages) {
          return Center(
            child: Text(
              'Error loading messages: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(
          child: Text(
            'No Messages available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }

  String _userDisplayName(dynamic user) {
    try {
      // Works with json_serializable User via toJson()
      final m = user.toJson() as Map<String, dynamic>;
      final first = (m['firstName'] ?? m['givenName'] ?? '').toString();
      final last = (m['lastName'] ?? m['familyName'] ?? '').toString();
      final combined = [first, last].where((s) => s.isNotEmpty).join(' ');
      if (combined.isNotEmpty) return combined;

      return (m['name'] ??
              m['fullName'] ??
              m['displayName'] ??
              m['username'] ??
              m['email'] ??
              m['phone'] ??
              m['_id'] ??
              m['id'] ??
              '')
          .toString();
    } catch (_) {
      return '';
    }
  }

  String _initialsFromName(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final s = parts.first;
      return s.substring(0, s.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String _formatTimestamp(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    DateTime? dt;
    try {
      dt = DateTime.parse(iso).toLocal();
    } catch (_) {
      return '';
    }
    final now = DateTime.now();
    final isSameDay =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;

    String two(int n) => n.toString().padLeft(2, '0');
    String ampm(int h) => h < 12 ? 'AM' : 'PM';
    int h12(int h) {
      final v = h % 12;
      return v == 0 ? 12 : v;
    }

    if (isSameDay) {
      return '${h12(dt.hour)}:${two(dt.minute)} ${ampm(dt.hour)}';
    }

    final diff = now.difference(dt).inDays;
    if (diff < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dt.weekday - 1];
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  String _userId(dynamic user) {
    try {
      final m = user.toJson() as Map<String, dynamic>;
      return (m['_id'] ?? m['id'] ?? m['userId'] ?? m['uid'] ?? '').toString();
    } catch (_) {
      return '';
    }
  }
}

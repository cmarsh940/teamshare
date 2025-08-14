import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../message/bloc/message_bloc.dart';
import 'package:teamshare/models/message.dart';
import 'package:teamshare/models/user.dart';

class ViewMessage extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String? chatTitle;

  const ViewMessage({
    super.key,
    required this.chatId,
    required this.currentUserId,
    this.chatTitle,
  });

  @override
  State<ViewMessage> createState() => _ViewMessageState();
}

class _ViewMessageState extends State<ViewMessage> {
  late final MessageBloc _bloc;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DateFormat _timeFmt = DateFormat('h:mm a');
  final DateFormat _dateHeaderFmt = DateFormat('EEE, MMM d, y');

  // optimistic pending messages (not yet confirmed by server)
  final List<Message> _pending = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<MessageBloc>();
  }

  @override
  void initState() {
    super.initState();
    // Defer bloc event to first frame to avoid ancestor lookup issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MessageBloc>().add(LoadMessages(widget.chatId));
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Message _buildLocalOutgoingMessage(String body) {
    return Message(
      chatId: widget.chatId,
      body: body,
      sender: User.fromJson({'_id': widget.currentUserId}),
      createdAt: DateTime.now().toIso8601String(),
      attachments: const [],
    );
  }

  void _send() {
    final raw = _textController.text.trim();
    if (raw.isEmpty) return;
    final message = _buildLocalOutgoingMessage(raw);
    setState(() => _pending.add(message));
    _scrollToBottom();
    _bloc.add(
      SendMessage(message, widget.currentUserId, chatId: widget.chatId),
    );
    _textController.clear();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _senderId(Message m) {
    final s = m.sender;
    if (s == null) return '';
    return s.id ?? (s.toJson()['_id']?.toString() ?? '');
  }

  String _senderDisplayName(Message m) {
    final s = m.sender;
    if (s == null) return 'Unknown';
    final json = s.toJson();
    return (json['firstName'] != null || json['lastName'] != null)
        ? [
          json['firstName'] ?? '',
          json['lastName'] ?? '',
        ].where((e) => (e as String).isNotEmpty).join(' ')
        : (json['name'] ??
                json['fullName'] ??
                json['username'] ??
                json['email'] ??
                json['_id'] ??
                json['id'] ??
                'User')
            .toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatTitle ?? 'Chat'),
        backgroundColor: Colors.grey[300],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessageBloc, MessageState>(
              listenWhen:
                  (p, c) => c is MessagesLoaded || c is ErrorLoadingMessages,
              listener: (context, state) {
                if (!mounted) return;
                if (state is MessagesLoaded) {
                  // Clear pending that were confirmed (match by body & createdAt proximity)
                  _pending.removeWhere(
                    (pending) => state.messages.any(
                      (srv) =>
                          srv.body == pending.body &&
                          (_senderId(srv) == _senderId(pending)),
                    ),
                  );
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is LoadingMessages && _pending.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ErrorLoadingMessages) {
                  return Center(
                    child: TextButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        'Retry\n${state.error}',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => _bloc.add(LoadMessages(widget.chatId)),
                    ),
                  );
                }

                final loaded =
                    state is MessagesLoaded ? state.messages : <Message>[];
                final all = [...loaded, ..._pending];

                all.sort((a, b) {
                  final ad =
                      DateTime.tryParse(a.createdAt ?? '') ??
                      DateTime.fromMillisecondsSinceEpoch(0);
                  final bd =
                      DateTime.tryParse(b.createdAt ?? '') ??
                      DateTime.fromMillisecondsSinceEpoch(0);
                  return ad.compareTo(bd);
                });

                if (all.isEmpty) {
                  return const Center(child: Text('No messages yet. Say hi!'));
                }

                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: all.length,
                    itemBuilder: (ctx, idx) {
                      final m = all[idx];
                      final isMe = _senderId(m) == widget.currentUserId;
                      final created =
                          DateTime.tryParse(m.createdAt ?? '') ??
                          DateTime.fromMillisecondsSinceEpoch(0);
                      final showDateHeader =
                          idx == 0 ||
                          _dateHeaderFmt.format(
                                DateTime.tryParse(
                                      all[idx - 1].createdAt ?? '',
                                    ) ??
                                    DateTime.fromMillisecondsSinceEpoch(0),
                              ) !=
                              _dateHeaderFmt.format(created);

                      final isPending = _pending.contains(m);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showDateHeader)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _dateHeaderFmt.format(created),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment:
                                isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      isMe
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(18),
                                    topRight: const Radius.circular(18),
                                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                                    bottomRight: Radius.circular(isMe ? 4 : 18),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        14,
                                        10,
                                        14,
                                        6,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!isMe)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 2,
                                              ),
                                              child: Text(
                                                _senderDisplayName(m),
                                                style: theme
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color:
                                                          isMe
                                                              ? Colors.white70
                                                              : theme
                                                                  .colorScheme
                                                                  .primary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          if ((m.body ?? '').isNotEmpty)
                                            Text(
                                              m.body!,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        isMe
                                                            ? Colors.white
                                                            : theme
                                                                .colorScheme
                                                                .onSurfaceVariant,
                                                  ),
                                            ),
                                          if (m.attachments.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Wrap(
                                                spacing: 4,
                                                runSpacing: 4,
                                                children:
                                                    m.attachments
                                                        .map(
                                                          (a) => Chip(
                                                            label: Text(
                                                              a.split('/').last,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            materialTapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    _timeFmt.format(created),
                                                    style: theme
                                                        .textTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                          fontSize: 10,
                                                          color:
                                                              isMe
                                                                  ? Colors
                                                                      .white70
                                                                  : theme
                                                                      .colorScheme
                                                                      .onSurfaceVariant
                                                                      .withOpacity(
                                                                        .6,
                                                                      ),
                                                        ),
                                                  ),
                                                  if (isPending) ...[
                                                    const SizedBox(width: 4),
                                                    SizedBox(
                                                      height: 10,
                                                      width: 10,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 1.5,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              isMe
                                                                  ? Colors
                                                                      .white70
                                                                  : theme
                                                                      .colorScheme
                                                                      .primary,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          _InputBar(controller: _textController, onSend: _send),
        ],
      ),
    );
  }
}

class _InputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  bool _canSend = false;

  void _onChanged() {
    final next = widget.controller.text.trim().isNotEmpty;
    if (next != _canSend && mounted) {
      setState(() => _canSend = next);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Material(
        elevation: 4,
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) {
                    if (_canSend) widget.onSend();
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _canSend ? widget.onSend : null,
                icon: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

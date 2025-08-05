import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';

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
  late MessageBloc _messageBloc;

  @override
  void initState() {
    super.initState();
    _messageBloc = BlocProvider.of<MessageBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is MessageInitial) {
          _messageBloc.add(
            LoadMessages(widget.teamId, widget.isTeamMessages, widget.userId),
          );
        }
        if (state is LoadingMessages) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessageLoaded) {
          if (state.messages.isEmpty) {
            return const Center(
              child: Text(
                'No messages available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              return ListTile(
                title: Text(message.title ?? 'No Title'),
                subtitle: Text(message.body ?? ''),
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

  @override
  void dispose() {
    _messageBloc.close();
    super.dispose();
  }
}

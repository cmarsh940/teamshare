import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';
import 'package:teamshare/pages/message/widgets/add_message.dart';
import 'package:teamshare/pages/message/widgets/message_list.dart';

class MessagePage extends StatelessWidget {
  final String? teamId;
  final String userId;
  final bool isTeamMessages;

  const MessagePage({
    super.key,
    this.teamId,
    required this.userId,
    required this.isTeamMessages,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create:
          (_) =>
              GetIt.I<MessageBloc>()
                ..add(LoadChats(teamId, isTeamMessages, userId)),
      child: Scaffold(
        body: Center(
          child: MessageList(
            teamId: teamId,
            isTeamMessages: isTeamMessages,
            userId: userId,
          ),
        ),
        floatingActionButton: Builder(
          builder:
              (ctx) => FloatingActionButton(
                onPressed: () {
                  final bloc = ctx.read<MessageBloc>();
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider<MessageBloc>.value(
                            value: bloc,
                            child: AddMessageWidget(
                              teamId: teamId,
                              userId: userId,
                            ),
                          ),
                    ),
                  );
                },
                tooltip: 'Create Message',
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }
}

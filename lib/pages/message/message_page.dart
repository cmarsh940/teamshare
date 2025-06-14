import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';
import 'package:teamshare/pages/message/widgets/message_list.dart';

class MessagePage extends StatelessWidget {
  final String? teamId;

  const MessagePage({super.key, this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(),
          child: MessageList(teamId: teamId),
        ),
      ),
    );
  }
}

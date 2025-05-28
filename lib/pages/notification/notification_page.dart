import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/notification/bloc/notification_bloc.dart';
import 'package:teamshare/pages/notification/widgets/notification_list.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
          child: NotificationList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/notification_repository.dart';
import 'package:teamshare/pages/notification/bloc/notification_bloc.dart';
import 'package:teamshare/pages/notification/widgets/notification_list.dart';

class NotificationPage extends StatelessWidget {
  NotificationRepository notificationRepository =
      GetIt.I<NotificationRepository>();

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(notificationRepository),
          child: NotificationList(),
        ),
      ),
    );
  }
}

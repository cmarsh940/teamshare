import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/notification/bloc/notification_bloc.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationInitial) {
          _notificationBloc.add(LoadNotifications());
        }
        if (state is LoadingNotifications) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedNotifications) {
          if (state.notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return ListTile(
                title: Text(notification.title ?? 'No Title'),
                subtitle: Text(notification.body ?? ''),
              );
            },
          );
        } else if (state is ErrorLoadingNotifications) {
          return Center(
            child: Text(
              'Error loading notifications: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(
          child: Text(
            'No notifications available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _notificationBloc.close();
    super.dispose();
  }
}

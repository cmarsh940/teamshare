part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  LoadNotifications();
}

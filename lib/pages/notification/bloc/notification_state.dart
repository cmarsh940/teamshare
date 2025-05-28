part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

class LoadingNotifications extends NotificationState {}

class LoadedNotifications extends NotificationState {
  final List notifications;

  LoadedNotifications(this.notifications);
}

class ErrorLoadingNotifications extends NotificationState {
  final String error;

  ErrorLoadingNotifications(this.error);
}

class NotificationEmpty extends NotificationState {}

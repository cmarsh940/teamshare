import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_mapLoadNotificationsToState);
  }

  _mapLoadNotificationsToState(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(LoadingNotifications());
    try {
      // Simulate fetching notifications
      await Future.delayed(Duration(seconds: 2));
      final notifications =
          []; // Replace with actual notification fetching logic
      if (notifications.isEmpty) {
        emit(NotificationEmpty());
      } else {
        emit(LoadedNotifications(notifications));
      }
    } catch (error) {
      emit(ErrorLoadingNotifications(error.toString()));
    }
  }
}

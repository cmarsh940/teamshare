import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/notification_repository.dart';
import 'package:teamshare/data/user_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  UserRepository userRepository = GetIt.instance<UserRepository>();

  NotificationBloc(this._notificationRepository)
    : super(NotificationInitial()) {
    on<LoadNotifications>(_mapLoadNotificationsToState);
  }

  _mapLoadNotificationsToState(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(LoadingNotifications());
    try {
      final userId = await userRepository.getId();
      final notifications = await _notificationRepository.fetchNotifications(
        userId,
      );
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

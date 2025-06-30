part of 'calendar_bloc.dart';

@immutable
sealed class CalendarState {}

final class CalendarInitial extends CalendarState {}

final class CalendarLoading extends CalendarState {}

final class CalendarLoaded extends CalendarState {
  final List<TeamCalendar> events;

  CalendarLoaded({required this.events});
}

final class CalendarEmpty extends CalendarState {
  CalendarEmpty();
}

final class CalendarError extends CalendarState {
  final String message;

  CalendarError({required this.message});
}

class CalendarEventAdded extends CalendarState {
  CalendarEventAdded();
}

final class CalendarEventDeleted extends CalendarState {
  final String eventId;

  CalendarEventDeleted({required this.eventId});
}

final class CalendarEventUpdated extends CalendarState {
  final TeamCalendar event;

  CalendarEventUpdated({required this.event});
}

final class UserAcceptedEvent extends CalendarState {
  final String userId;

  UserAcceptedEvent({required this.userId});
}

final class UserDeclinedEvent extends CalendarState {
  final String userId;

  UserDeclinedEvent({required this.userId});
}

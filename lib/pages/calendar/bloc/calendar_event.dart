part of 'calendar_bloc.dart';

@immutable
sealed class CalendarEvent {}

class LoadCalendar extends CalendarEvent {
  final String teamId;

  LoadCalendar({required this.teamId});
}

class AddCalendarEvent extends CalendarEvent {
  final String teamId;
  TeamCalendar event;

  AddCalendarEvent({required this.teamId, required this.event});
}

class AcceptEvent extends CalendarEvent {
  final String eventId;

  AcceptEvent({required this.eventId});
}

class DeclineEvent extends CalendarEvent {
  final String eventId;

  DeclineEvent({required this.eventId});
}

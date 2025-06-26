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

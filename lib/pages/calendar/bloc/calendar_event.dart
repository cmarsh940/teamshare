part of 'calendar_bloc.dart';

@immutable
sealed class CalendarEvent {}

class LoadCalendar extends CalendarEvent {
  final String teamId;

  LoadCalendar({required this.teamId});
}

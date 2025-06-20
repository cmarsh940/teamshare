part of 'calendar_bloc.dart';

@immutable
sealed class CalendarState {}

final class CalendarInitial extends CalendarState {}

final class CalendarLoading extends CalendarState {}

final class CalendarLoaded extends CalendarState {
  final List<String> events; // Replace with your actual event model

  CalendarLoaded({required this.events});
}

final class CalendarError extends CalendarState {
  final String message;

  CalendarError({required this.message});
}

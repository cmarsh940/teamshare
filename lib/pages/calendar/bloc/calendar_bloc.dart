import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<LoadCalendar>(_mapLoadCalendarToState);
  }

  _mapLoadCalendarToState(
    LoadCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    print('Load calendar for team: ${event.teamId}');
    try {
      // Simulate a network call or data fetching
      await Future.delayed(Duration(seconds: 2), () {
        // Generate some dummy events
        final events = List.generate(
          10,
          (index) => 'Event ${index + 1} for team ${event.teamId}',
        );
        emit(CalendarLoaded(events: events));
      });
    } catch (e) {
      emit(CalendarError(message: 'Failed to load calendar'));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/models/calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final TeamRepository teamRepository;

  CalendarBloc(this.teamRepository) : super(CalendarInitial()) {
    on<LoadCalendar>(_mapLoadCalendarToState);
    on<AddCalendarEvent>(_mapAddCalendarEventToState);
    on<AcceptEvent>(_mapAcceptEventToState);
    on<DeclineEvent>(_mapDeclineEventToState);
  }

  _mapLoadCalendarToState(
    LoadCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(CalendarLoading());
      final tempCalendar = await teamRepository.getTeamCalendar(event.teamId);
      print('Loaded calendar with ${tempCalendar.length} events');
      emit(CalendarLoaded(events: tempCalendar));
    } catch (e) {
      emit(CalendarError(message: 'Failed to load calendar'));
    }
  }

  _mapAddCalendarEventToState(
    AddCalendarEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      await teamRepository.addTeamCalendarEvent(event.teamId, event.event);
      emit(CalendarEventAdded());
    } catch (e) {
      emit(CalendarError(message: 'Failed to add calendar event'));
    }
  }

  _mapAcceptEventToState(AcceptEvent event, Emitter<CalendarState> emit) async {
    try {
      var response = await teamRepository.acceptTeamCalendarEvent(
        event.eventId,
      );
      emit(UserAcceptedEvent(userId: response));
    } catch (e) {
      emit(CalendarError(message: 'Failed to accept calendar event'));
    }
  }

  _mapDeclineEventToState(
    DeclineEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      var response = await teamRepository.declineTeamCalendarEvent(
        event.eventId,
      );
      emit(UserDeclinedEvent(userId: response));
    } catch (e) {
      emit(CalendarError(message: 'Failed to accept calendar event'));
    }
  }
}

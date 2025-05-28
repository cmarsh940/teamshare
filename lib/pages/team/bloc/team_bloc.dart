import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;

  TeamBloc(this._teamRepository) : super(TeamInitial()) {
    on<TeamCreateEvent>(_mapCreateTeamEventToState);
    on<LoadForm>(_mapLoadFormEventToState);
  }

  _mapCreateTeamEventToState(
    TeamCreateEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      await _teamRepository.createTeam(event.team);
      emit(TeamCreated());
    } catch (e) {
      emit(TeamCreationFailed());
    }
  }

  _mapLoadFormEventToState(LoadForm event, Emitter<TeamState> emit) async {
    emit(Loading());
    try {
      emit(Loaded());
    } catch (e) {
      emit(TeamLoadInProgress());
    }
  }
}

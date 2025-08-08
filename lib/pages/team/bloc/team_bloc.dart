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
    on<DeleteTeamEvent>(_mapDeleteTeamEventToState);
    on<JoinTeamEvent>(_mapJoinTeamEventToState);
  }

  _mapCreateTeamEventToState(
    TeamCreateEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      await _teamRepository.createTeam(event.team);
      emit(TeamCreatedSuccess());
    } catch (e) {
      emit(TeamCreationError());
    }
  }

  _mapLoadFormEventToState(LoadForm event, Emitter<TeamState> emit) async {
    emit(LoadingTeam());
    try {
      emit(Loaded());
    } catch (e) {
      emit(TeamLoadInProgress());
    }
  }

  _mapDeleteTeamEventToState(
    DeleteTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      await _teamRepository.deleteTeam(event.teamId);
      emit(TeamDeleted(teamId: event.teamId));
    } catch (e) {
      emit(TeamDeletionFailed());
    }
  }

  _mapJoinTeamEventToState(JoinTeamEvent event, Emitter<TeamState> emit) async {
    try {
      await _teamRepository.joinTeam(event.teamCode, event.userId);
      emit(TeamJoinedSuccess());
    } catch (e) {
      emit(TeamJoinError(message: e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/main.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/utils/app_logger.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository _teamRepository;

  TeamBloc(this._teamRepository) : super(TeamInitial()) {
    on<TeamCreateEvent>(_mapCreateTeamEventToState);
    on<LoadForm>(_mapLoadFormEventToState);
    on<DeleteTeamEvent>(_mapDeleteTeamEventToState);
    on<JoinTeamEvent>(_mapJoinTeamEventToState);
    on<GetTeamMembers>(_mapGetTeamMembersToState);
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

  _mapGetTeamMembersToState(
    GetTeamMembers event,
    Emitter<TeamState> emit,
  ) async {
    try {
      AppLogger.debug('Fetching team members for team: ${event.teamId}');
      final members = await _teamRepository.getTeamMembers(event.teamId);
      AppLogger.debug(
        'Fetched ${members.members.length} members for team: ${event.teamId}',
      );
      emit(TeamMembersLoaded(members));
    } catch (e) {
      emit(TeamMembersError(e.toString()));
    }
  }
}

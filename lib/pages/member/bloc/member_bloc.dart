import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/models/user.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final TeamRepository _teamRepository;

  MemberBloc(this._teamRepository) : super(MemberInitial()) {
    on<LoadMembers>(_mapLoadMembersToState);
    on<RemoveMemberFromTeam>(_mapRemoveMemberToState);
  }

  _mapLoadMembersToState(LoadMembers event, Emitter<MemberState> emit) async {
    // Here you would typically fetch the members from a repository or service
    // For now, we will just emit a loading state and then a loaded state with dummy data

    emit(MembersLoading());
    try {
      final team = await _teamRepository.getTeamMembers(event.teamId);
      emit(MembersLoaded(team));
    } catch (e) {
      print('Error loading members: $e');
    }
  }

  _mapRemoveMemberToState(
    RemoveMemberFromTeam event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await _teamRepository.removeMember(event.teamId, event.userId);
      final team = await _teamRepository.getTeamMembers(event.teamId);
      emit(MembersLoaded(team));
    } catch (e) {
      print('Error removing member: $e');
    }
  }
}

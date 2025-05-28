import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/data/user_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  TeamRepository teamRepository = GetIt.instance<TeamRepository>();
  UserRepository userRepository = GetIt.instance<UserRepository>();

  DashboardBloc() : super(DashboardInitial()) {
    on<LoadTeams>(_mapLoadTeamsToState);
  }

  _mapLoadTeamsToState(LoadTeams event, Emitter<DashboardState> emit) async {
    emit(LoadingTeams());
    final userId = await userRepository.getId();
    final teams = await teamRepository.fetchTeams(userId);
    emit(Loaded(teams));
  }
}

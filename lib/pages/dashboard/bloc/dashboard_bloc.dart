import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/utils/app_logger.dart';

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
    AppLogger.info('Dashboard: Retrieved user ID for teams fetch: $userId');
    AppLogger.info('Dashboard: User ID length: ${userId.length}');

    try {
      final teams = await teamRepository.fetchTeams(userId);
      emit(Loaded(teams));
    } catch (e) {
      AppLogger.error('Dashboard: Failed to load teams', error: e);
      emit(LoadingTeams()); // or create an error state
    }
  }
}

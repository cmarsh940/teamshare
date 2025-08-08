import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/models/user.dart';
import 'package:teamshare/pages/dashboard/bloc/dashboard_bloc.dart';
import '../utils/app_logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(Uninitialized()) {
    on<AppStarted>(_mapAppStartedToState);
    on<LoggedIn>(_mapLoggedInToState);
    on<LogOut>(_mapLoggedOutToState);
    on<FirstTime>(_mapFirstTimeToState);
    on<Profile>(_mapProfileToState);
    on<ChangePage>(_mapChangePageToState);
  }

  _mapAppStartedToState(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final isSignedIn = await _userRepository.isSignedIn();

      if (isSignedIn == null || !isSignedIn) {
        emit(Unauthenticated());
      } else {
        final String? id = await _userRepository.getId();
        if (id == null || id.isEmpty) {
          emit(Unauthenticated());
          return;
        }
        emit(Authenticated(id));
      }
    } catch (e) {
      AppLogger.error('Error during app startup: $e');
      emit(Unauthenticated());
    }
  }

  _mapLoggedInToState(LoggedIn event, Emitter<AuthState> emit) async {
    try {
      final String? id = await _userRepository.getId();
      if (id == null || id.isEmpty) {
        emit(Unauthenticated());
        return;
      }
      emit(Authenticated(id));
    } catch (e) {
      AppLogger.error('Error during login: $e');
      emit(Unauthenticated());
    }
  }

  _mapLoggedOutToState(LogOut event, Emitter<AuthState> emit) async {
    try {
      // Clear all repository caches
      try {
        final teamRepository = GetIt.instance<TeamRepository>();
        teamRepository.clearCache();

        // Clear and reset DashboardBloc
        if (GetIt.instance.isRegistered<DashboardBloc>()) {
          final dashboardBloc = GetIt.instance<DashboardBloc>();
          dashboardBloc.close();
          GetIt.instance.unregister<DashboardBloc>();

          // Re-register with fresh instance
          final newDashboardBloc = DashboardBloc();
          GetIt.instance.registerSingleton<DashboardBloc>(newDashboardBloc);
        }
      } catch (cacheError) {
        AppLogger.error('Error clearing repository cache: $cacheError');
      }

      // Clear SharedPreferences directly
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      } catch (prefsError) {
        AppLogger.error('Error clearing SharedPreferences: $prefsError');
      }

      // Clear user repository and sign out user
      await _userRepository.signOut();

      emit(Unauthenticated());
    } catch (e) {
      AppLogger.error('Error during logout: $e');
      emit(Unauthenticated());
    }
  }

  _mapProfileToState(Profile event, Emitter<AuthState> emit) async {
    try {
      final user = await _userRepository.getUser();
      if (user == null) {
        emit(Unauthenticated());
        return;
      }
      final Map<String, dynamic> userMap = jsonDecode(user);
      final User newUser = User.fromJson(userMap);
      emit(UserProfile(newUser));
    } catch (e) {
      AppLogger.error('Error fetching user profile: $e');
      emit(Unauthenticated());
    }
  }

  _mapFirstTimeToState(FirstTime event, Emitter<AuthState> emit) async {
    try {
      final String? id = await _userRepository.getId();
      if (id == null || id.isEmpty) {
        emit(Unauthenticated());
        return;
      }
      emit(Authenticated(id));
    } catch (e) {
      AppLogger.error('Error during first time setup: $e');
      emit(Unauthenticated());
    }
  }

  _mapChangePageToState(ChangePage event, Emitter<AuthState> emit) async {
    try {
      if (event.page == '0') {
        final String? id = await _userRepository.getId();
        if (id == null) {
          emit(Unauthenticated());
          return;
        }
        emit(Authenticated(id));
      } else {
        emit(ShowTeamPage(event.page));
      }
    } catch (e) {
      AppLogger.error('Error during page change: $e');
      emit(Unauthenticated());
    }
  }
}

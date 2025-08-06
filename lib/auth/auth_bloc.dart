import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/models/user.dart';
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
        final firstTime = await _userRepository.checkFirstTime();
        if (firstTime) {
          final user = await _userRepository.getUser();
          if (user == null) {
            AppLogger.error('User data is null despite being signed in');
            emit(Unauthenticated());
            return;
          }
          final Map<String, dynamic> userMap = jsonDecode(user);
          final User newUser = User.fromJson(userMap);
          emit(FirstTimeForm(newUser));
        } else {
          final String? id = await _userRepository.getId();
          if (id == null) {
            AppLogger.error('User ID is null despite being authenticated');
            emit(Unauthenticated());
            return;
          }
          emit(Authenticated(id));
        }
      }
    } catch (e) {
      AppLogger.error('Error during app startup: $e');
      emit(Unauthenticated());
    }
  }

  _mapLoggedInToState(LoggedIn event, Emitter<AuthState> emit) async {
    try {
      final bool firstTime = await _userRepository.checkFirstTime();
      AppLogger.info('First time user: $firstTime');

      if (firstTime) {
        final user = await _userRepository.getUser();
        if (user == null) {
          AppLogger.error('User data is null during login');
          emit(Unauthenticated());
          return;
        }
        final Map<String, dynamic> userMap = jsonDecode(user);
        final User newUser = User.fromJson(userMap);
        emit(FirstTimeForm(newUser));
      } else {
        final String? id = await _userRepository.getId();
        if (id == null) {
          AppLogger.error('User ID is null during login');
          emit(Unauthenticated());
          return;
        }
        emit(Authenticated(id));
      }
    } catch (e) {
      AppLogger.error('Error during login: $e');
      emit(Unauthenticated());
    }
  }

  _mapLoggedOutToState(LogOut event, Emitter<AuthState> emit) async {
    try {
      AppLogger.info('User logging out');
      await _userRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      AppLogger.error('Error during logout: $e');
      // Still emit unauthenticated state even if signOut fails
      emit(Unauthenticated());
    }
  }

  _mapProfileToState(Profile event, Emitter<AuthState> emit) async {
    try {
      final user = await _userRepository.getUser();
      if (user == null) {
        AppLogger.error('User data is null when fetching profile');
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
      final user = await _userRepository.getUser();
      if (user == null) {
        AppLogger.error('User data is null during first time setup');
        emit(Unauthenticated());
        return;
      }
      final Map<String, dynamic> userMap = jsonDecode(user);
      final User newUser = User.fromJson(userMap);
      emit(FirstTimeForm(newUser));
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
          AppLogger.error('User ID is null during page change');
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

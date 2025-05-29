import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(Uninitialized()) {
    on<AppStarted>(_mapAppStartedToState);
    on<LoggedIn>(_mapLoggedInToState);
    on<LoggedOut>(_mapLoggedOutToState);
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
          var user = await _userRepository.getUser();
          Map<String, dynamic> userMap = jsonDecode(user);
          final User newUser = new User.fromJson(userMap);
          emit(FirstTimeForm(newUser));
        } else {
          final String id = (await _userRepository.getId())!;
          emit(Authenticated(id));
        }
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  _mapLoggedInToState(LoggedIn event, Emitter<AuthState> emit) async {
    bool firstTime = await _userRepository.checkFirstTime();
    print('first time in state: $firstTime');
    if (firstTime) {
      var user = await _userRepository.getUser();
      Map<String, dynamic> userMap = jsonDecode(user);
      final User newUser = new User.fromJson(userMap);
      emit(FirstTimeForm(newUser));
    } else {
      emit(Authenticated((await _userRepository.getId())!));
    }
  }

  _mapLoggedOutToState(LoggedOut event, Emitter<AuthState> emit) async {
    emit(Unauthenticated());
    _userRepository.signOut();
  }

  _mapProfileToState(Profile event, Emitter<AuthState> emit) async {
    var user = await _userRepository.getUser();
    Map<String, dynamic> userMap = jsonDecode(user);
    final User newUser = new User.fromJson(userMap);
    emit(UserProfile(newUser));
  }

  _mapFirstTimeToState(FirstTime event, Emitter<AuthState> emit) async {
    var user = await _userRepository.getUser();
    Map<String, dynamic> userMap = jsonDecode(user);
    final User newUser = new User.fromJson(userMap);
    emit(FirstTimeForm(newUser));
  }

  _mapChangePageToState(ChangePage event, Emitter<AuthState> emit) async {
    if (event.page == '0') {
      emit(Authenticated((await _userRepository.getId())!));
    } else {
      emit(ShowTeamPage(event.page));
    }
  }
}

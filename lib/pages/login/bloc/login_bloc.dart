import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/utils/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(LoginState.loading()) {
    on<EmailChanged>(_mapEmailChangedToState);
    on<PasswordChanged>(_mapPasswordChangedToState);
    on<LoginButtonPressed>(_mapLoginWithCredentialsPressedToState);
  }

  LoginState get initialState => LoginState.empty();

  _mapEmailChangedToState(EmailChanged event, Emitter<LoginState> emit) async {
    emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
  }

  _mapPasswordChangedToState(
    PasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.update(isPasswordValid: Validators.isValidPassword(event.password)),
    );
  }

  _mapLoginWithCredentialsPressedToState(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginState.loading());

    var response = await _userRepository.authenticate(
      email: event.email,
      password: event.password,
    );

    if (response != null) {
      emit(LoginState.success());
    } else {
      emit(LoginState.failure());
    }
  }
}

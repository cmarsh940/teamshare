import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/utils/validators.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(RegisterState.loading()) {
    on<EmailChanged>(_mapEmailChangedToState);
    on<PasswordChanged>(_mapPasswordChangedToState);
    on<ConfirmPasswordChanged>(_mapConfirmPasswordChangedToState);
    on<Submitted>(_mapFormSubmittedToState);
  }

  RegisterState get initialState => RegisterState.empty();

  _mapEmailChangedToState(
    EmailChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
  }

  _mapPasswordChangedToState(
    PasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.update(isPasswordValid: Validators.isValidPassword(event.password)),
    );
  }

  _mapConfirmPasswordChangedToState(
    ConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.update(
        passwordsMatch: Validators.passwordsMatch(
          event.password,
          event.confirmPassword,
        ),
      ),
    );
  }

  _mapFormSubmittedToState(Submitted event, Emitter<RegisterState> emit) async {
    emit(RegisterState.loading());
    var response = await _userRepository.signUp(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      confirmPass: event.confirmPass,
    );
    print('response $response');
    if (response != null) {
      emit(RegisterState.success());
    } else {
      emit(RegisterState.failure());
    }
  }
}

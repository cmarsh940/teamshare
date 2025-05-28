import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/models/user.dart';

part 'first_time_event.dart';
part 'first_time_state.dart';

class FirstTimeBloc extends Bloc<FirstTimeEvent, FirstTimeState> {
  final UserRepository _userRepository;

  FirstTimeBloc({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(FirstTimeState.loading());

  FirstTimeState get initialState => FirstTimeState.empty();

  Stream<FirstTimeState> mapEventToState(FirstTimeEvent event) async* {
    if (event is Submitted) {
      yield* _mapFormSubmittedToState(user: event.user, changed: event.changed);
    }
  }

  Stream<FirstTimeState> _mapFormSubmittedToState({
    required User user,
    bool? changed,
  }) async* {
    print('change is: $changed');
    yield FirstTimeState.loading();
    if (changed == true) {
      var response = await _userRepository.finishSetup(user);
      if (response != null) {
        yield FirstTimeState.success();
      } else {
        yield FirstTimeState.failure();
      }
    } else {
      yield FirstTimeState.checkFailure();
    }
  }
}

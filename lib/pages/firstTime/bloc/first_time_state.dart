part of 'first_time_bloc.dart';

@immutable
class FirstTimeState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isChannelValid;

  FirstTimeState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    required this.isChannelValid,
  });

  factory FirstTimeState.empty() {
    return FirstTimeState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isChannelValid: false,
    );
  }

  factory FirstTimeState.loading() {
    return FirstTimeState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isChannelValid: false,
    );
  }

  factory FirstTimeState.failure() {
    return FirstTimeState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isChannelValid: false,
    );
  }

  factory FirstTimeState.checkFailure() {
    return FirstTimeState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isChannelValid: true,
    );
  }

  factory FirstTimeState.success() {
    return FirstTimeState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isChannelValid: false,
    );
  }

  FirstTimeState update() {
    return copyWith(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isChannelValid: false,
    );
  }

  FirstTimeState copyWith({
    bool? isSubmitEnabled,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    bool? isChannelValid,
  }) {
    return FirstTimeState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isChannelValid: isChannelValid ?? this.isChannelValid
    );
  }

  @override
  String toString() {
    return '''FirstTimeState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isChannelValid: $isChannelValid,
    }''';
  }
}


class CheckPassed extends FirstTimeState {
  CheckPassed() : super(isFailure: false, isChannelValid: true, isSubmitting: true, isSuccess: true);

  @override
  String toString() => 'CheckPassed';
}

class CheckFailed extends FirstTimeState {
  CheckFailed() : super(isFailure: true, isChannelValid: false, isSubmitting: false, isSuccess: false);

  @override
  String toString() => 'CheckFailed';
}

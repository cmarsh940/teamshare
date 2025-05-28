part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  final String password;

  ConfirmPasswordChanged({required this.confirmPassword, required this.password});

  @override
  String toString() =>
      'ConfirmPasswordChanged { confirmPassword: $confirmPassword, password: $password }';
}

class Submitted extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPass;

  Submitted(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.confirmPass});

  @override
  String toString() {
    return 'Submitted { firstName: $firstName, lastName: $lastName, email: $email, password: $password, confirm: $confirmPass }';
  }
}

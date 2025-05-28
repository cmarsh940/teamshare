part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  String toString() =>
      'LoginButtonPressed { email: $email, password: $password }';
}

class AppleLoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  AppleLoginButtonPressed({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  String toString() =>
      'AppleLoginButtonPressed { email: $email, password: $password, fistName: $firstName, lastName: $lastName }';
}
class GoogleLoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  GoogleLoginButtonPressed({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  String toString() =>
      'GoogleLoginButtonPressed { email: $email, password: $password, fistName: $firstName, lastName: $lastName }';
}

class FacebookLoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  FacebookLoginButtonPressed({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  String toString() =>
      'FacebookLoginButtonPressed { email: $email, password: $password, fistName: $firstName, lastName: $lastName }';
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({required this.email});

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends LoginEvent {
  final String email;
  final String password;

  Submitted({required this.email, required this.password});

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}
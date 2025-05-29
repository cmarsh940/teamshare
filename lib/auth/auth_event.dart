part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AppStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthEvent {
  @override
  String toString() => 'LoggedOut';
}

class FirstTime extends AuthEvent {
  @override
  String toString() => 'FirstTime';
}

class Profile extends AuthEvent {
  @override
  String toString() => 'Profile';
}

class ChangePage extends AuthEvent {
  final String page;

  ChangePage(this.page);

  @override
  String toString() => 'ChangePage { page: $page }';
}

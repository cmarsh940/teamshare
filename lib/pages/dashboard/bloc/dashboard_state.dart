part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class LoadingTeams extends DashboardState {}

final class Loaded extends DashboardState {
  final List teams;

  Loaded(this.teams);
}

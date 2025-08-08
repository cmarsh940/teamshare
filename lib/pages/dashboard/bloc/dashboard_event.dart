part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class LoadTeams extends DashboardEvent {
  LoadTeams();
}

class ForceRefreshTeams extends DashboardEvent {
  ForceRefreshTeams();
}

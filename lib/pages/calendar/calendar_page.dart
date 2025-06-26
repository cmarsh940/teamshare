import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';
import 'package:teamshare/pages/calendar/widgets/add_calendar_event.dart';
import 'package:teamshare/pages/calendar/widgets/calendar_layout.dart';

class CalendarPage extends StatelessWidget {
  final String teamId;
  final TeamRepository teamRepository;

  const CalendarPage({
    super.key,
    required this.teamId,
    required this.teamRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(teamRepository),
          child: CalendarLayout(teamId: teamId),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigate to the AddCalendarEvent page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider<CalendarBloc>.value(
                    value: GetIt.I<CalendarBloc>(),
                    child: AddCalendarEventPage(teamId: teamId),
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

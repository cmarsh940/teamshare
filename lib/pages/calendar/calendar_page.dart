import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';
import 'package:teamshare/pages/calendar/widgets/calendar_layout.dart';

class CalendarPage extends StatelessWidget {
  final String teamId;

  const CalendarPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(),
          child: CalendarLayout(teamId: teamId),
        ),
      ),
    );
  }
}

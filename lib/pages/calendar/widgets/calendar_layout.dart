import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';

class CalendarLayout extends StatefulWidget {
  final String teamId;

  const CalendarLayout({super.key, required this.teamId});

  @override
  State<CalendarLayout> createState() => _CalendarLayoutState();
}

class _CalendarLayoutState extends State<CalendarLayout> {
  late CalendarBloc _calendarBloc;

  @override
  void initState() {
    super.initState();
    _calendarBloc = BlocProvider.of<CalendarBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is CalendarInitial) {
          _calendarBloc.add(LoadCalendar(teamId: widget.teamId));
        }
        if (state is CalendarLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CalendarLoaded) {
          return Placeholder(child: Text('hello'));
        }
        return const Center(
          child: Text(
            'No Calendar Available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }
}

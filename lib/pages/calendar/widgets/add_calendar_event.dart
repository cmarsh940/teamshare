import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/repositories.dart';
import 'package:teamshare/models/calendar.dart';
import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';

class AddCalendarEventPage extends StatefulWidget {
  final String teamId;

  const AddCalendarEventPage({super.key, required this.teamId});

  @override
  State<AddCalendarEventPage> createState() => _AddCalendarEventPageState();
}

class _AddCalendarEventPageState extends State<AddCalendarEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String userId = '';
  UserRepository get _userRepository => GetIt.I<UserRepository>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    userId = await _userRepository.getId();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarBloc>.value(
      value: GetIt.I<CalendarBloc>(),
      child: BlocListener<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarEventAdded) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Event added')));
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('New Calendar Event')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter a title'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      _startDate == null
                          ? 'Select Start Date & Time'
                          : 'Start: ${_startDate.toString()}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _startDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: Text(
                      _endDate == null
                          ? 'Select End Date & Time'
                          : 'End: ${_endDate.toString()}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _endDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _startDate != null &&
                          _endDate != null) {
                        print('Adding event: ${_titleController.text}');
                        var newCalendarEvent = TeamCalendar(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          start: _startDate!,
                          end: _endDate!,
                          team: widget.teamId,
                          createdBy: userId,
                        );
                        context.read<CalendarBloc>().add(
                          AddCalendarEvent(
                            teamId: widget.teamId,
                            event: newCalendarEvent,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Event'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

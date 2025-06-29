import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/local_storage.dart';
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
  final _locationNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  String? _selectedState;
  DateTime? _startDate;
  DateTime? _endDate;
  String userId = '';
  UserRepository get _userRepository => GetIt.I<UserRepository>();
  List<Map<String, String>> _locationSuggestions = [];
  bool _showSuggestions = false;

  final List<String> _usStates = [
    'AL',
    'AK',
    'AZ',
    'AR',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'ID',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'ME',
    'MD',
    'MA',
    'MI',
    'MN',
    'MS',
    'MO',
    'MT',
    'NE',
    'NV',
    'NH',
    'NJ',
    'NM',
    'NY',
    'NC',
    'ND',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VT',
    'VA',
    'WA',
    'WV',
    'WI',
    'WY',
  ];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void _onLocationChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        _locationSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    final allLocations = await getSavedLocations();
    setState(() {
      _locationSuggestions =
          allLocations
              .where(
                (loc) => loc['location']!.toLowerCase().contains(
                  value.toLowerCase(),
                ),
              )
              .toList();
      _showSuggestions = _locationSuggestions.isNotEmpty;
    });
  }

  void _fillLocation(Map<String, String> loc) {
    _locationNameController.text = loc['location'] ?? '';
    final parts = (loc['address'] ?? '').split(',');
    _streetController.text = parts.isNotEmpty ? parts[0].trim() : '';
    _cityController.text = parts.length > 1 ? parts[1].trim() : '';
    _selectedState = parts.length > 2 ? parts[2].trim() : null;
    _zipController.text = parts.length > 3 ? parts[3].trim() : '';
    setState(() {
      _showSuggestions = false;
    });
  }

  getUser() async {
    userId = await _userRepository.getId();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 16),
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
                  TextFormField(
                    controller: _locationNameController,
                    decoration: const InputDecoration(
                      labelText: 'Location Name (optional)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onLocationChanged,
                  ),
                  if (_showSuggestions)
                    ..._locationSuggestions.map(
                      (loc) => ListTile(
                        title: Text(loc['location'] ?? ''),
                        subtitle: Text(loc['address'] ?? ''),
                        onTap: () => _fillLocation(loc),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Address fields
                  TextFormField(
                    controller: _streetController,
                    decoration: const InputDecoration(
                      labelText: 'Street Address',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_streetController.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedState,
                      items:
                          _usStates
                              .map(
                                (state) => DropdownMenuItem(
                                  value: state,
                                  child: Text(state),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedState = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_streetController.text.isNotEmpty &&
                            (value == null || value.isEmpty)) {
                          return 'Please select a state';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _zipController,
                      decoration: const InputDecoration(
                        labelText: 'Zip Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
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
                    onPressed: () async {
                      bool addressFilled =
                          _streetController.text.isNotEmpty ||
                          _cityController.text.isNotEmpty ||
                          (_selectedState != null &&
                              _selectedState!.isNotEmpty) ||
                          _zipController.text.isNotEmpty;

                      // Validation: If any address field is filled, city and state must be filled
                      if (_formKey.currentState!.validate() &&
                          _startDate != null &&
                          _endDate != null) {
                        if (addressFilled &&
                            (_cityController.text.isEmpty ||
                                _selectedState == null ||
                                _selectedState!.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please fill out city and state if entering an address.',
                              ),
                            ),
                          );
                          return;
                        }

                        String? fullAddress;
                        if (addressFilled) {
                          fullAddress =
                              '${_streetController.text}, ${_cityController.text}, ${_selectedState ?? ''}, ${_zipController.text}';
                        }

                        if (_locationNameController.text.isNotEmpty &&
                            fullAddress != null &&
                            fullAddress.isNotEmpty) {
                          await saveLocationToPrefs(
                            _locationNameController.text,
                            fullAddress,
                          );
                        }

                        var newCalendarEvent = TeamCalendar(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          start: _startDate!,
                          end: _endDate!,
                          team: widget.teamId,
                          createdBy: userId,
                          location:
                              _locationNameController.text.isNotEmpty
                                  ? _locationNameController.text
                                  : null,
                          address: fullAddress,
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

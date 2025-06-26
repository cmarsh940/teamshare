import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';

class CalendarLayout extends StatefulWidget {
  final String teamId;

  const CalendarLayout({super.key, required this.teamId});

  @override
  State<CalendarLayout> createState() => _CalendarLayoutState();
}

class _CalendarLayoutState extends State<CalendarLayout> {
  late CalendarBloc _calendarBloc;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ScrollController _scrollController = ScrollController();

  // Add your holidays here
  final Map<DateTime, List<String>> holidays = {
    DateTime(2025, 1, 1): ["New Year's Day"],
    DateTime(2025, 7, 4): ["Independence Day"],
    DateTime(2025, 12, 25): ["Christmas Day"],
    // Add more as needed
  };

  @override
  void initState() {
    super.initState();
    _calendarBloc = BlocProvider.of<CalendarBloc>(context);
  }

  int _findEventIndexForDate(List events, DateTime date) {
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      if (event.start != null &&
          event.start.year == date.year &&
          event.start.month == date.month &&
          event.start.day == date.day) {
        return i;
      }
    }
    return -1;
  }

  void _scrollToIndex(int index) {
    if (index >= 0 && _scrollController.hasClients) {
      _scrollController.animateTo(
        index * 72.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
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
          final events = List.of(state.events)..sort((a, b) {
            if (a.start == null && b.start == null) return 0;
            if (a.start == null) return 1;
            if (b.start == null) return -1;
            return a.start!.compareTo(b.start!);
          });

          // Map for TableCalendar eventLoader
          Map<DateTime, List<dynamic>> eventMap = {};
          for (var event in events) {
            final date = DateTime(
              event.start?.year ?? 0,
              event.start?.month ?? 1,
              event.start?.day ?? 1,
            );
            eventMap.putIfAbsent(date, () => []).add(event);
          }

          // Merge holidays into eventMap for eventLoader
          Map<DateTime, List<dynamic>> combinedMap = {...eventMap};
          holidays.forEach((date, hols) {
            combinedMap.update(
              date,
              (list) => [...list, ...hols],
              ifAbsent: () => [...hols],
            );
          });

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader:
                    (day) =>
                        combinedMap[DateTime(day.year, day.month, day.day)] ??
                        [],
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  final idx = _findEventIndexForDate(events, selectedDay);
                  if (idx != -1) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToIndex(idx);
                    });
                  }
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final hols =
                        holidays[DateTime(date.year, date.month, date.day)];
                    if (hols != null && hols.isNotEmpty) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Icon(
                            Icons.flag,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final allDates =
                        <DateTime>{
                            ...events
                                .where((e) => e.start != null)
                                .map(
                                  (e) => DateTime(
                                    e.start!.year,
                                    e.start!.month,
                                    e.start!.day,
                                  ),
                                ),
                            ...holidays.keys,
                          }.toList()
                          ..sort((a, b) => a.compareTo(b));

                    // Map events by date for quick lookup
                    final Map<DateTime, List<dynamic>> eventMap = {};
                    for (var event in events) {
                      if (event.start != null) {
                        final date = DateTime(
                          event.start!.year,
                          event.start!.month,
                          event.start!.day,
                        );
                        eventMap.putIfAbsent(date, () => []).add(event);
                      }
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: allDates.length,
                      itemBuilder: (context, index) {
                        final date = allDates[index];
                        final items = eventMap[date] ?? [];
                        final holidayNames = holidays[date];
                        final isSelected =
                            _selectedDay != null &&
                            date.year == _selectedDay!.year &&
                            date.month == _selectedDay!.month &&
                            date.day == _selectedDay!.day;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header with holiday chips if any
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "${date.day.toString().padLeft(2, '0')} ${_monthShort(date.month)} ${date.year}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isSelected
                                              ? Colors.black
                                              : Colors.grey[700],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Events for this date
                            ...items.map((event) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDay = date;
                                    _focusedDay = date;
                                  });
                                },
                                child: Container(
                                  color:
                                      isSelected
                                          ? Colors.black.withOpacity(0.07)
                                          : Colors.transparent,
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${date.day.toString().padLeft(2, '0')}\n${_monthShort(date.month)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isSelected
                                                    ? Colors.black
                                                    : Colors.grey[700],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      event.title ?? 'No Title',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? Colors.black
                                                : Colors.grey[900],
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${_formatTime(event.start)} - ${_formatTime(event.end)}",
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            // Holidays styled like events but light grey
                            if (holidayNames != null)
                              ...holidayNames.map(
                                (h) => Container(
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: Colors.grey[500],
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      h,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      "Holiday",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
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

  String _monthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(month - 1).clamp(0, 11)];
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}

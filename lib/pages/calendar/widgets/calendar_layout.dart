import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teamshare/models/holidays.dart';
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

  @override
  void initState() {
    super.initState();
    _calendarBloc = BlocProvider.of<CalendarBloc>(context);
  }

  void _scrollToIndex(int index) {
    if (index >= 0 && _scrollController.hasClients) {
      final itemHeight = 88.0;
      final viewHeight = _scrollController.position.viewportDimension;
      final offset = (index * itemHeight) - (viewHeight / 2) + (itemHeight / 2);
      _scrollController.animateTo(
        offset < 0 ? 0 : offset,
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

          // Combine events and holidays for TableCalendar markers
          Map<DateTime, List<dynamic>> combinedMap = {};
          for (var event in events) {
            if (event.start != null) {
              final date = DateTime(
                event.start!.year,
                event.start!.month,
                event.start!.day,
              );
              combinedMap.putIfAbsent(date, () => []).add(event);
            }
          }
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

                  // Find the index in the displayList for scrolling
                  final selectedDate = DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                  );

                  // Build the same displayList as below to find the index
                  final List<Map<String, dynamic>> allItems = [
                    ...events
                        .where((e) => e.start != null)
                        .map(
                          (e) => {
                            'type': 'event',
                            'date': DateTime(
                              e.start!.year,
                              e.start!.month,
                              e.start!.day,
                            ),
                            'data': e,
                          },
                        ),
                    ...holidays.entries.expand(
                      (entry) => entry.value.map(
                        (h) => {
                          'type': 'holiday',
                          'date': entry.key,
                          'data': h,
                        },
                      ),
                    ),
                  ];

                  final Map<String, List<Map<String, dynamic>>> monthMap = {};
                  for (final item in allItems) {
                    final date = item['date'] as DateTime;
                    final monthKey =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}";
                    monthMap.putIfAbsent(monthKey, () => []).add(item);
                  }

                  final List<dynamic> displayList = [];
                  monthMap.forEach((monthKey, items) {
                    if (items.isNotEmpty) {
                      final parts = monthKey.split('-');
                      final year = int.parse(parts[0]);
                      final month = int.parse(parts[1]);
                      displayList.add(DateTime(year, month, 1));
                      items.sort(
                        (a, b) => (a['date'] as DateTime).compareTo(
                          b['date'] as DateTime,
                        ),
                      );
                      displayList.addAll(items);
                    }
                  });

                  final dateIdx = displayList.indexWhere(
                    (item) =>
                        item is Map &&
                        (item['date'] as DateTime).year == selectedDate.year &&
                        (item['date'] as DateTime).month ==
                            selectedDate.month &&
                        (item['date'] as DateTime).day == selectedDate.day,
                  );
                  if (dateIdx != -1) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToIndex(dateIdx);
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
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Builder(
                  builder: (context) {
                    // 1. Combine events and holidays into a unified list
                    final List<Map<String, dynamic>> allItems = [
                      ...events
                          .where((e) => e.start != null)
                          .map(
                            (e) => {
                              'type': 'event',
                              'date': DateTime(
                                e.start!.year,
                                e.start!.month,
                                e.start!.day,
                              ),
                              'data': e,
                            },
                          ),
                      ...holidays.entries.expand(
                        (entry) => entry.value.map(
                          (h) => {
                            'type': 'holiday',
                            'date': entry.key,
                            'data': h,
                          },
                        ),
                      ),
                    ];

                    // 2. Group by month
                    final Map<String, List<Map<String, dynamic>>> monthMap = {};
                    for (final item in allItems) {
                      final date = item['date'] as DateTime;
                      final monthKey =
                          "${date.year}-${date.month.toString().padLeft(2, '0')}";
                      monthMap.putIfAbsent(monthKey, () => []).add(item);
                    }

                    // 3. Build displayList: [monthHeader, ...itemsForMonth], sorted by month
                    final List<dynamic> displayList = [];
                    final sortedMonthKeys =
                        monthMap.keys.toList()..sort((a, b) {
                          // Parse year and month for comparison
                          final aParts = a.split('-');
                          final bParts = b.split('-');
                          final aDate = DateTime(
                            int.parse(aParts[0]),
                            int.parse(aParts[1]),
                          );
                          final bDate = DateTime(
                            int.parse(bParts[0]),
                            int.parse(bParts[1]),
                          );
                          return aDate.compareTo(bDate);
                        });

                    for (final monthKey in sortedMonthKeys) {
                      final items = monthMap[monthKey]!;
                      if (items.isNotEmpty) {
                        final parts = monthKey.split('-');
                        final year = int.parse(parts[0]);
                        final month = int.parse(parts[1]);
                        displayList.add(
                          DateTime(year, month, 1),
                        ); // month header
                        items.sort(
                          (a, b) => (a['date'] as DateTime).compareTo(
                            b['date'] as DateTime,
                          ),
                        );
                        displayList.addAll(items);
                      }
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final item = displayList[index];
                        if (item is DateTime && item.day == 1) {
                          // Month header
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16,
                            ),
                            child: Text(
                              "${_monthLong(item.month)} ${item.year}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        // Unified event/holiday rendering
                        final type = item['type'];
                        final date = item['date'] as DateTime;
                        final isSelected =
                            _selectedDay != null &&
                            date.year == _selectedDay!.year &&
                            date.month == _selectedDay!.month &&
                            date.day == _selectedDay!.day;

                        if (type == 'event') {
                          final event = item['data'];
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        } else if (type == 'holiday') {
                          final holiday = item['data'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDay = date;
                                _focusedDay = date;
                              });
                            },
                            child: Container(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      color: Colors.grey[500],
                                      size: 20,
                                    ),
                                  ],
                                ),
                                title: Text(
                                  holiday,
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
                          );
                        }
                        return const SizedBox.shrink();
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

  String _monthLong(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[(month - 1).clamp(0, 11)];
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
    int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    String minute = dt.minute.toString().padLeft(2, '0');
    String period = dt.hour < 12 ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }
}

import 'package:intl/intl.dart';

String formatEventDateTime(DateTime? start, DateTime? end) {
  if (start == null) return '';
  // final dayFormat = DateFormat('E, MMM d');
  final timeFormat = DateFormat('h:mm a');

  // Ordinal suffix
  String ordinal(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String startDay =
      DateFormat('E, MMM').format(start) + ' ${start.day}${ordinal(start.day)}';
  String startTime = timeFormat.format(start);

  if (end != null) {
    bool sameDay =
        start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    String endDay =
        DateFormat('E, MMM').format(end) + ' ${end.day}${ordinal(end.day)}';
    String endTime = timeFormat.format(end);

    if (sameDay) {
      // Show day and time range on one line
      return '$startDay $startTime - $endTime';
    } else {
      // Show start and end on separate lines
      return '$startDay $startTime\n$endDay $endTime';
    }
  } else {
    return '$startDay $startTime';
  }
}

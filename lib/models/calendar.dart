import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/models/user.dart';

part 'calendar.g.dart';

@JsonSerializable()
class Recurrence {
  final String type; // 'none', 'daily', 'weekly', 'monthly', 'yearly'
  final int interval;
  final List<int>? daysOfWeek;

  Recurrence({this.type = 'none', this.interval = 1, this.daysOfWeek});

  factory Recurrence.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceFromJson(json);
  Map<String, dynamic> toJson() => _$RecurrenceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CalendarEvent {
  @JsonKey(name: '_id')
  final String? id;
  final Team team;
  final String title;
  final String? description;
  final DateTime start;
  final DateTime end;
  final Recurrence? recurrence;
  final User createdBy;
  final bool notified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CalendarEvent({
    this.id,
    required this.team,
    required this.title,
    this.description,
    required this.start,
    required this.end,
    this.recurrence,
    required this.createdBy,
    this.notified = false,
    this.createdAt,
    this.updatedAt,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}

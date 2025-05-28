import 'package:json_annotation/json_annotation.dart';

import 'schedule_activity.dart';


part 'schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  @JsonKey(name: '_id')
  String id;
  DateTime date;
  List<ScheduleActivity> activities;
  String user;
  
  Schedule(this.id, this.date, this.activities, this.user);

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
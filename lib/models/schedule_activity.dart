import 'package:json_annotation/json_annotation.dart';

part 'schedule_activity.g.dart';

@JsonSerializable(explicitToJson: true)
class ScheduleActivity {
  String? id;
  String? activity;
  String? startTime;
  String? endTime;

  ScheduleActivity(this.id, this.activity, this.startTime, this.endTime);

  factory ScheduleActivity.fromJson(Map<String, dynamic> json) => _$ScheduleActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleActivityToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'activity_log.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivityLog {
  @JsonKey(name: '_id')
  String? id;
  String? activity;
  bool? completed;
  int? duration;
  int? distance;
  DateTime? endTime;
  String? note;
  int? sets;
  DateTime? startTime;
  String? time;
  String? user;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  ActivityLog(
    this.id,
    this.activity,
    this.completed,
    this.duration,
    this.distance,
    this.endTime,
    this.note,
    this.sets,
    this.startTime,
    this.time,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v
  );

  factory ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityLogToJson(this);
}
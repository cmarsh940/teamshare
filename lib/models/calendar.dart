import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/models/user.dart';

part 'calendar.g.dart';

@JsonSerializable()
@JsonSerializable(explicitToJson: true)
class TeamCalendar {
  @JsonKey(name: '_id')
  final String? id;
  final List<String>? attachments;
  final List<String>? accepted;
  final List<String>? declined;
  final String? team;
  final String? title;
  final String? description;
  final DateTime? start;
  final DateTime? end;
  final String? createdBy;
  final String? picture;
  final bool? notified;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TeamCalendar({
    this.id,
    this.attachments,
    this.accepted,
    this.declined,
    required this.team,
    required this.title,
    this.description,
    required this.start,
    required this.end,
    required this.createdBy,
    this.picture,
    this.notified = false,
    this.location,
    this.latitude,
    this.longitude,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory TeamCalendar.fromJson(Map<String, dynamic> json) =>
      _$TeamCalendarFromJson(json);
  Map<String, dynamic> toJson() => _$TeamCalendarToJson(this);
}

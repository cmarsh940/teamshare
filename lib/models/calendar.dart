import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/models/user.dart';

part 'calendar.g.dart';

@JsonSerializable()
@JsonSerializable(explicitToJson: true)
class TeamCalendar {
  @JsonKey(name: '_id')
  final String? id;
  List<String>? attachments;
  List<String>? accepted;
  List<String>? declined;
  String? team;
  String? title;
  String? description;
  DateTime? start;
  DateTime? end;
  String? createdBy;
  String? picture;
  bool? notified;
  String? location;
  double? latitude;
  double? longitude;
  String? address;
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

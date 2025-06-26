import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/calendar.dart';
import 'package:teamshare/models/user.dart';

part 'team.g.dart';

// Custom converter for events
class TeamCalendarListConverter
    implements JsonConverter<List<TeamCalendar>, dynamic> {
  const TeamCalendarListConverter();

  @override
  List<TeamCalendar> fromJson(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json
          .map<TeamCalendar?>((item) {
            if (item is String) {
              // If it's just an ID, create a TeamCalendar with only the id set
              return TeamCalendar(
                id: item,
                team: null,
                title: null,
                start: null,
                end: null,
                createdBy: null,
              );
            } else if (item is Map<String, dynamic>) {
              return TeamCalendar.fromJson(item);
            } else if (item != null && item.toString().isNotEmpty) {
              // Try to parse item if it's not null and not empty
              try {
                return TeamCalendar.fromJson(Map<String, dynamic>.from(item));
              } catch (_) {
                // Ignore and fall through to exception
              }
            }
            // Skip invalid items instead of throwing
            // Explicitly return null to avoid "body might complete normally" error
            return null;
          })
          .whereType<TeamCalendar>()
          .toList();
    }
    throw Exception('Invalid events format');
  }

  @override
  dynamic toJson(List<TeamCalendar> events) {
    return events.map((e) => e.toJson()).toList();
  }
}

@JsonSerializable(explicitToJson: true)
class Team {
  @JsonKey(name: '_id')
  String? id;
  List<String> admins;
  List<String> attachments;
  String? description;
  @TeamCalendarListConverter()
  List<TeamCalendar> events;
  List<User> members;
  String name;
  String? picture;
  List<String> posts;
  bool private;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Team({
    this.id,
    this.admins = const [],
    this.attachments = const [],
    this.description,
    this.events = const [],
    this.members = const [],
    required this.name,
    this.picture,
    this.posts = const [],
    this.private = false,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}

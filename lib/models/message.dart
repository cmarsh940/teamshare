import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/user.dart';

part 'message.g.dart';

class ParticipantsConverter implements JsonConverter<List<User>?, dynamic> {
  const ParticipantsConverter();

  @override
  List<User>? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is List) {
      final result = <User>[];
      for (final e in json) {
        if (e == null) continue;
        if (e is String) {
          // Treat string entries as user ids; adjust the key if your User expects a different one
          result.add(User.fromJson({'_id': e}));
        } else if (e is Map<String, dynamic>) {
          result.add(User.fromJson(e));
        } else if (e is Map) {
          result.add(User.fromJson(Map<String, dynamic>.from(e)));
        } else {
          throw FormatException(
            'Unsupported participants entry: ${e.runtimeType}',
          );
        }
      }
      return result;
    }
    throw FormatException(
      'participants should be a List, got ${json.runtimeType}',
    );
  }

  @override
  dynamic toJson(List<User>? users) {
    if (users == null) return null;
    // Prefer list of ids when available, otherwise full user objects
    return users.map((u) {
      final m = u.toJson();
      return m['_id'] ?? m['id'] ?? m['userId'] ?? m['uid'] ?? m;
    }).toList();
  }
}

@JsonSerializable()
class Message {
  @JsonKey(name: '_id')
  String? id;
  String? chatId;
  String? body;
  User? sender;

  @ParticipantsConverter()
  List<User>? participants;
  String? teamId;
  List<String> attachments;
  List<String>? readBy;
  String? groupName;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Message({
    this.id,
    this.chatId,
    this.body,
    this.sender,
    this.teamId,
    this.participants,
    this.attachments = const [],
    this.readBy,
    this.groupName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

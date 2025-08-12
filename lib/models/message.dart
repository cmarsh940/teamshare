import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/user.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  @JsonKey(name: '_id')
  String? id;
  String? chatId;
  String? body;
  User? sender;
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

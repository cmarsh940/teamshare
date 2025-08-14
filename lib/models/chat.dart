import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/message.dart';
import 'package:teamshare/models/user.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  @JsonKey(name: '_id')
  String? id;
  String? groupName;
  List<User>? participants;
  List<String>? messages;
  String? createdAt;
  String? updatedAt;
  Message? lastMessage;
  String? teamId;
  @JsonKey(name: '__v')
  int? v;

  Chat({
    this.id,
    this.groupName,
    this.participants,
    this.messages,
    this.createdAt,
    this.updatedAt,
    this.lastMessage,
    this.teamId,
    this.v,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

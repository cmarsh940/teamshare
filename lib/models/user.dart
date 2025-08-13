import 'package:json_annotation/json_annotation.dart';
import 'notification.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
  String? id;
  String? email;
  String? firstName;
  bool? firstTime;
  String? lastName;
  List<String>? notifications;
  String? phone;
  String? picture;
  String? token;
  bool? verified;
  List<String>? chats;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  User(
    this.id,
    this.email,
    this.firstName,
    this.firstTime,
    this.lastName,
    this.notifications,
    this.phone,
    this.picture,
    this.token,
    this.verified,
    this.chats,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

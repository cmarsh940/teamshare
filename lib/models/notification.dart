import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/user.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification {
  @JsonKey(name: '_id')
  String? id;
  bool? viewed;
  String? viewedDatge;
  String? status;
  String? title;
  String? message;
  User? user;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Notification(
    this.id,
    this.viewed,
    this.status,
    this.title,
    this.message,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

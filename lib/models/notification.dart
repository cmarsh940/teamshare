import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)

class Notification {
  @JsonKey(name: '_id')
  String? id;
  bool? viewed;
  String? status;
  String? title;
  String? message;
  String? user;
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
    this.v
  );

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
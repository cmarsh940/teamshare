import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/user.dart';

part 'team.g.dart';

@JsonSerializable(explicitToJson: true)
class Team {
  @JsonKey(name: '_id')
  String? id;
  List<User> admins;
  List<String> attachments;
  String? description;
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
    this.members = const [],
    required this.name,
    this.picture,
    this.posts = const [],
    this.private = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}

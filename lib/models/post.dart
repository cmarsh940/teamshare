import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/comment.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/models/user.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: '_id')
  String? id;
  List<String>? attatchments;
  User? author;
  String? body;
  List<Comment>? comments;
  Team? team;
  String? title;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Post(
    this.id,
    this.attatchments,
    this.author,
    this.body,
    this.comments,
    this.team,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/comment.dart';
import 'package:teamshare/models/user.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: '_id')
  String? id;
  List<String>? attachments;
  User? author;
  String? body;
  List<Comment>? comments;
  List<String>? likes;
  List<String>? dislikes;
  String? teamId;
  String? title;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Post(
    this.id,
    this.attachments,
    this.author,
    this.body,
    this.comments,
    this.likes,
    this.dislikes,
    this.teamId,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

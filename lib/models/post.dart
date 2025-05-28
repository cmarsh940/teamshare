import 'package:json_annotation/json_annotation.dart';

import 'comment.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: '_id')
  String? id;
  String? body;
  List<Comment>? comments;
  String? description;
  num? dislikes;
  num? likes;
  String? thumbnail;
  bool? video;
  String? user;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;
  
  Post(
      this.id,
      this.body,
      this.comments,
      this.description,
      this.dislikes,
      this.likes,
      this.thumbnail,
      this.video,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.v);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
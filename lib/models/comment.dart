import 'package:json_annotation/json_annotation.dart';
import 'package:teamshare/models/user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(name: '_id')
  String? id;
  String? body;
  User? author;
  List<String>? likedBy;
  String? postId;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Comment(
    this.id,
    this.body,
    this.author,
    this.likedBy,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  Comment copyWith({
    String? id,
    String? body,
    User? author,
    List<String>? likedBy,
    String? postId,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return Comment(
      id ?? this.id,
      body ?? this.body,
      author ?? this.author,
      likedBy ?? this.likedBy,
      postId ?? this.postId,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
      v ?? this.v,
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

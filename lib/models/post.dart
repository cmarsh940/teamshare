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
  @CommentOrIdConverter()
  final List<Comment>? comments;
  List<String>? likes;
  List<String>? dislikes;
  String? teamId;
  String? title;
  String? createdAt;
  String? updatedAt;
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

  Post copyWith({
    String? id,
    List<String>? attachments,
    User? author,
    String? body,
    List<Comment>? comments,
    List<String>? likes,
    List<String>? dislikes,
    String? teamId,
    String? title,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return Post(
      id ?? this.id,
      attachments ?? this.attachments,
      author ?? this.author,
      body ?? this.body,
      comments ?? this.comments,
      likes ?? this.likes,
      dislikes ?? this.dislikes,
      teamId ?? this.teamId,
      title ?? this.title,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
      v ?? this.v,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

class CommentOrIdConverter
    implements JsonConverter<List<Comment>?, List<dynamic>?> {
  const CommentOrIdConverter();

  @override
  List<Comment>? fromJson(List<dynamic>? json) {
    if (json == null) return null;
    return json.map((e) {
      if (e is String) {
        // Set postId to '' or a placeholder if you don't have it
        return Comment(
          e, // id
          null, // body
          null, // authorId
          null, // author
          '', // postId <-- set to empty string or a placeholder
          null, // createdAt
          null, // likedBy
          null, // dislikes
        );
      } else if (e is Map<String, dynamic>) {
        return Comment.fromJson(e);
      }
      throw Exception('Unknown comment type');
    }).toList();
  }

  @override
  List<dynamic>? toJson(List<Comment>? object) =>
      object?.map((e) => e.toJson()).toList();
}

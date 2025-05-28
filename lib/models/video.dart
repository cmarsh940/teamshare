import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable(explicitToJson: true)
class Video {
  @JsonKey(name: '_id')
  String? id;
  String? category;
  List<String>? comments;
  String? description;
  int? dislikes;
  int? likes;
  String? streamerId;
  String? streamerName;
  String? streamerPic;
  bool? streaming;
  String? thumbnail;
  String? title;
  String? url;
  bool? usingApp;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Video(
    this.id,
    this.category,
    this.comments,
    this.description,
    this.dislikes,
    this.likes,
    this.streamerId,
    this.streamerName,
    this.streamerPic,
    this.streaming,
    this.thumbnail,
    this.title,
    this.url,
    this.usingApp,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

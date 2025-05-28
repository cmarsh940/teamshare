import 'package:json_annotation/json_annotation.dart';

part 'nutrition.g.dart';

@JsonSerializable(explicitToJson: true)
class Nutrition {
  @JsonKey(name: '_id')
  String? id;
  String? day;
  String? user;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Nutrition(this.id, this.day, this.user, this.createdAt, this.updatedAt, this.v);

  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'food_log.g.dart';

@JsonSerializable(explicitToJson: true)
class FoodLog {
  @JsonKey(name: '_id')
  String? id;
  String? date;
  List<String>? items;
  String? meal;
  List<String>? notes;
  int? section;
  int? totalCal;
  String? user;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  FoodLog(
    this.id, 
    this.date, 
    this.items, 
    this.meal, 
    this.notes, 
    this.section, 
    this.totalCal, 
    this.user, 
    this.createdAt, 
    this.updatedAt, 
    this.v
  );

  factory FoodLog.fromJson(Map<String, dynamic> json) =>
      _$FoodLogFromJson(json);

  Map<String, dynamic> toJson() => _$FoodLogToJson(this);
}

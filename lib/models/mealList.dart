import 'package:json_annotation/json_annotation.dart';

import 'meal.dart';


part 'mealList.g.dart';

@JsonSerializable(explicitToJson: true)
class MealList {
  @JsonKey(name: '_id')
  String? id;
  DateTime? date;
  List<Meal>? meals;
  String? user;

  MealList(
    this.id, 
    this.date, 
    this.meals, 
    this.user
  );

  factory MealList.fromJson(Map<String, dynamic> json) =>
      _$MealListFromJson(json);

  Map<String, dynamic> toJson() => _$MealListToJson(this);
}
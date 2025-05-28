import 'package:json_annotation/json_annotation.dart';

import 'mealList.dart';

part 'subsMeals.g.dart';

@JsonSerializable(explicitToJson: true)
class SubsMeals {
  List<MealList>? meals;
  String? channel;
  
  SubsMeals(this.meals, this.channel);

  factory SubsMeals.fromJson(Map<String, dynamic> json) =>
      _$SubsMealsFromJson(json);

  Map<String, dynamic> toJson() => _$SubsMealsToJson(this);
}
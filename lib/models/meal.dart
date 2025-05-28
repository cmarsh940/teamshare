import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonSerializable(explicitToJson: true)
class Meal {
  String? id;
  String? name;
  String? category;
  String? calories;

  Meal(
    this.id, 
    this.name, 
    this.category, 
    this.calories
  );

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}

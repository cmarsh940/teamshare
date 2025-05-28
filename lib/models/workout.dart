import 'package:json_annotation/json_annotation.dart';

part 'workout.g.dart';

@JsonSerializable(explicitToJson: true)
class Workout {
  String? id;
  String? name;
  String? reps;
  String? sets;
  String? completed;

  Workout(this.id, this.name, this.reps, this.sets, this.completed);

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}
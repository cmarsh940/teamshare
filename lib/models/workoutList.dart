import 'package:json_annotation/json_annotation.dart';

import 'workout.dart';

part 'workoutList.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkoutList {
  @JsonKey(name: '_id')
  String? id;
  DateTime? date;
  List<Workout>? workouts;
  String? user;
  
  WorkoutList(this.id, this.date, this.workouts, this.user);

  factory WorkoutList.fromJson(Map<String, dynamic> json) =>
      _$WorkoutListFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutListToJson(this);
}

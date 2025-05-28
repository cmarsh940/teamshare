import 'package:json_annotation/json_annotation.dart';

import 'workoutList.dart';

part 'subsWorkouts.g.dart';

@JsonSerializable(explicitToJson: true)
class SubsWorkouts {
  List<WorkoutList>? workouts;
  String? channel;
  
  SubsWorkouts(this.workouts, this.channel);

  factory SubsWorkouts.fromJson(Map<String, dynamic> json) =>
      _$SubsWorkoutsFromJson(json);

  Map<String, dynamic> toJson() => _$SubsWorkoutsToJson(this);
}
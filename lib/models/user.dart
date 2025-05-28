import 'package:json_annotation/json_annotation.dart';

import 'activity_log.dart';
import 'food_log.dart';
import 'mealList.dart';
import 'notification.dart';
import 'nutrition.dart';
import 'post.dart';
import 'schedule.dart';
import 'subscription.dart';
import 'video.dart';
import 'weightList.dart';
import 'workoutList.dart';


part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
  String? id;
  List<String>? achievments;
  List<ActivityLog>? activityLogs;
  int? age;
  List<User>? blocked;
  int? calorieGoal;
  String? channel;
  String? channelDescription;
  int? coins;
  String? dob;
  String? email;
  List<String>? events;
  String? experience;
  String? firstName;
  bool? firstTime;
  List<String>? followers;
  List<String>? following;
  List<FoodLog>? foodLogs;
  String? gender;
  String? goal;
  String? habit;
  String? height;
  String? lastLive;
  String? lastName;
  bool? live;
  List<MealList>? mealList;
  String? measurement;
  List<Notification>? notifications;
  List<Nutrition>? nutrition;
  String? overallGoal;
  String? phone;
  String? picture;
  List<Post>? posts;
  bool? private;
  List<String>? progress;
  List<Schedule>? schedule;
  String? streamKey;
  List<Subscription>? subscribedTo;
  List<String>? subscribers;
  String? token;
  int? totalViews;
  bool? verified;
  List<Video>? videos;
  int? weight;
  int? weightGoal;
  List<WeightList>? weightList;
  List<WorkoutList>? workoutLists;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  User(
    this.id,
    this.achievments,
    this.activityLogs,
    this.age,
    this.blocked,
    this.calorieGoal,
    this.channel,
    this.channelDescription,
    this.coins,
    this.dob,
    this.email,
    this.events,
    this.experience,
    this.firstName,
    this.firstTime,
    this.followers,
    this.following,
    this.foodLogs,
    this.gender,
    this.goal,
    this.habit,
    this.height,
    this.lastLive,
    this.lastName,
    this.live,
    this.measurement,
    this.notifications,
    this.nutrition,
    this.overallGoal,
    this.phone,
    this.picture,
    this.posts,
    this.private,
    this.progress,
    this.streamKey,
    this.subscribedTo,
    this.subscribers,
    this.token,
    this.totalViews,
    this.verified,
    this.videos,
    this.weight,
    this.weightGoal,
    this.workoutLists,
    this.createdAt,
    this.updatedAt,
    this.v,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

@JsonSerializable(explicitToJson: true)
class Subscription {
  @JsonKey(name: '_id')
  String? id;
  String? subscribedOn;
  String? renewalDate;
  String? subscriber;
  String? subscribedTo;
  String? createdAt;
  String? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Subscription(
    this.id,
    this.subscribedOn,
    this.renewalDate,
    this.subscriber,
    this.subscribedTo,
    this.createdAt,
    this.updatedAt,
    this.v
  );

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'weightList.g.dart';

@JsonSerializable(explicitToJson: true)
class WeightList {
  String? id;
  String? date;
  String? image;
  int? weight;

  WeightList(this.id, this.date, this.image, this.weight);

  factory WeightList.fromJson(Map<String, dynamic> json) =>
      _$WeightListFromJson(json);

  Map<String, dynamic> toJson() => _$WeightListToJson(this);
}

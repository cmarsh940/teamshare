class MuscleGroup {
  String? name;
  String? image;
  List<Exercises>? exercises;

  MuscleGroup({this.name, this.image, this.exercises});

  MuscleGroup.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    if (json['exercises'] != null) {
      exercises = <Exercises>[];
      json['exercises'].forEach((v) {
        exercises!.add(new Exercises.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.exercises != null) {
      data['exercises'] = this.exercises!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exercises {
  String? title;
  String? description;
  String? video;

  Exercises({this.title, this.description, this.video});

  Exercises.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['video'] = this.video;
    return data;
  }
}

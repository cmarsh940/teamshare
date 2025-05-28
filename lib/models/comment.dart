class Comment {
  String? message;
  String? channel;
  

  Comment({this.message, this.channel});

  factory Comment.fromJson(Map<String, dynamic> json) => new Comment(
      message: json['message'],
      channel: json['channel'],
      
    );

  Map<String, dynamic> toJson() => {
        'message': message,
        'channel': channel,
      };
}
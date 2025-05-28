class Message {
  String? id;
  String? avatar;
  String? body;
  String? channel;
  String? color;
  String? room;
  bool? subscribed;
  bool? joined;

  Message(
      {this.id,
      this.avatar,
      this.body,
      this.channel,
      this.color,
      this.room,
      this.subscribed,
      this.joined,
      });

  factory Message.fromJson(Map<String, dynamic> json) => new Message(
      id: json['id'],
      avatar: json['avatar'],
      body: json['body'],
      channel: json['channel'],
      color: json['color'],
      room: json['room'],
      subscribed: json['subscribed'],
      joined: json['joined'],
    );

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'body': body,
        'channel': channel,
        'color': color,
        'room': room,
        'subscribed': subscribed,
        'joined': joined,
      };
}
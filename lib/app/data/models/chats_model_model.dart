class ChatsModel {
  List<String>? connections;

  List<Chat>? chat;

  ChatsModel({
    this.connections,
    this.chat,
  });

  ChatsModel.fromJson(Map<String, dynamic> json) {
    connections = json['connections'].cast<String>();
    if (json['chat'] != null) {
      chat = <Chat>[];
      json['chat'].forEach((v) {
        chat?.add(Chat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connections'] = connections;
    if (chat != null) {
      data['chat'] = chat?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chat {
  String? from;
  String? to;
  String? message;
  String? time;
  bool? isRead;

  Chat({this.from, this.to, this.message, this.time, this.isRead});

  Chat.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    message = json['message'];
    time = json['time'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    data['message'] = message;
    data['time'] = time;
    data['isRead'] = isRead;
    return data;
  }
}

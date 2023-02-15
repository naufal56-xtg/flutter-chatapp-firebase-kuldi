class UserModel {
  String? uid;
  String? name;
  String? keyName;
  String? phoneNumber;
  String? email;
  String? creationTime;
  String? lastSignInTime;
  String? photoUrl;
  String? status;
  String? updatedTime;
  List<Chats>? chats;

  UserModel({
    this.uid,
    this.name,
    this.keyName,
    this.phoneNumber,
    this.email,
    this.creationTime,
    this.lastSignInTime,
    this.photoUrl,
    this.status,
    this.updatedTime,
    this.chats,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    keyName = json['keyName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    creationTime = json['creationTime'];
    lastSignInTime = json['lastSignInTime'];
    photoUrl = json['photoUrl'];
    status = json['status'];
    updatedTime = json['updatedTime'];
    // if (json['chats'] != null) {
    //   chats = <Chats>[];
    //   json['chats'].forEach((v) {
    //     chats?.add(Chats.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['keyName'] = keyName;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['creationTime'] = creationTime;
    data['lastSignInTime'] = lastSignInTime;
    data['photoUrl'] = photoUrl;
    data['status'] = status;
    data['updatedTime'] = updatedTime;
    // if (chats != null) {
    //   data['chats'] = chats?.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Chats {
  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;

  Chats({this.connection, this.chatId, this.lastTime, this.totalUnread});

  Chats.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    chatId = json['chat_id'];
    lastTime = json['lastTime'];
    totalUnread = json['total_unread'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connection'] = connection;
    data['chat_id'] = chatId;
    data['lastTime'] = lastTime;
    data['total_unread'] = totalUnread;
    return data;
  }
}

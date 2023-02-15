import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  // var readChat = true.obs;
  var emojiShowing = false.obs;
  late FocusNode focus;
  late TextEditingController textC;
  late ScrollController scrollC;
  int total_unread = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addEmoji(Emoji emoji) {
    textC.text = textC.text + emoji.emoji;
  }

  void deleteEmoji() {
    textC.text = textC.text.substring(0, textC.text.length - 2);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chat_id) {
    CollectionReference chats = firestore.collection('chats');

    return chats.doc(chat_id).collection('chat').orderBy('time').snapshots();
  }

  Stream<DocumentSnapshot<Object?>> streamData(String fEmail) {
    CollectionReference users = firestore.collection('users');

    return users.doc(fEmail).snapshots();
  }

  void newChats(
      String chat, String email, String chat_id, String fEmail) async {
    if (chat != '') {
      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');
      String time = DateTime.now().toIso8601String();

      await chats.doc(chat_id).collection('chat').add({
        'from': email,
        'to': fEmail.toString(),
        'message': chat,
        'time': time,
        'isRead': false,
        'groupTime': DateFormat.yMMMMd('en_US').format(DateTime.parse(time)),
      });

      Timer(
        Duration.zero,
        () => scrollC.jumpTo(scrollC.position.maxScrollExtent),
      );

      textC.clear();

      await users.doc(email).collection('chats').doc(chat_id).update(
        {
          'lastTime': time,
        },
      );

      final checkChatFriend =
          await users.doc(fEmail).collection('chats').doc(chat_id).get();

      if (checkChatFriend.exists) {
        final checkTotalUnread = await chats
            .doc(chat_id)
            .collection('chat')
            .where("isRead", isEqualTo: false)
            .where('from', isEqualTo: email)
            .get();

        // final checkTotalUnread = await users
        //     .doc(fEmail)
        //     .collection('chats')
        //     .doc(chat_id)
        //     .get();

        total_unread = checkTotalUnread.docs.length;
        // total_unread = (checkTotalUnread.data()!['total_unread'] as int) + 1;
        print(total_unread);

        await users.doc(fEmail).collection('chats').doc(chat_id).update(
          {
            'lastTime': time,
            'total_unread': total_unread,
          },
        );
      } else {
        await users.doc(fEmail).collection('chats').doc(chat_id).set(
          {
            'connection': email,
            'lastTime': time,
            'total_unread': 1,
          },
        );
      }
    }
  }

  @override
  void onInit() {
    textC = TextEditingController();
    scrollC = ScrollController();
    focus = FocusNode();
    focus.addListener(() {
      if (focus.hasFocus) {
        emojiShowing.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    textC.dispose();
    scrollC.dispose();
    focus.dispose();
    super.onClose();
  }
}

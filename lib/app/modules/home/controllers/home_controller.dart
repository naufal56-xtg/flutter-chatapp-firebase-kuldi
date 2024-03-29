import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatapp_project/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> listChat(String email) {
    return firestore
        .collection('users')
        .doc(email)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listFriends(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  void goToChatRoom(String chat_id, String email, String fEmail) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');
    final updateRead = await chats
        .doc(chat_id)
        .collection('chat')
        .where('isRead', isEqualTo: false)
        .where('to', isEqualTo: email)
        .get();

    updateRead.docs.forEach((element) async {
      await chats.doc(chat_id).collection('chat').doc(element.id).update(
        {
          'isRead': true,
        },
      );
    });

    await users.doc(email).collection('chats').doc(chat_id).update(
      {
        'total_unread': 0,
      },
    );

    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        'chat_id': "$chat_id",
        'fEmail': fEmail,
      },
    );
  }
}

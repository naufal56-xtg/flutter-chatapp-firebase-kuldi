import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatapp_project/app/data/models/users_model_model.dart';
import 'package:flutter_chatapp_project/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var skipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var user = UserModel().obs;

  Future<void> firstInit() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipInt().then((value) {
      if (value) {
        skipIntro.value = true;
      }
    });
  }

  Future<bool> skipInt() async {
    final box = GetStorage();
    if (box.read('skipintro') != null || box.read('skipintro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final isLogin = await _googleSignIn.isSignedIn();
      if (isLogin) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        CollectionReference users = firestore.collection('users');

        await users.doc(_currentUser!.email).update({
          'lastSignInTime':
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();

        final userModel = currUser.data() as Map<String, dynamic>;

        user(UserModel.fromJson(userModel));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.length != 0) {
          List<Chats> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChats = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              Chats(
                chatId: dataDocChatId,
                connection: dataDocChats['connection'],
                lastTime: dataDocChats['lastTime'],
                totalUnread: dataDocChats['totalUnread'],
              ),
            );
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }
        user.refresh();

        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);
      final isLogin = await _googleSignIn.isSignedIn();
      if (isLogin) {
        // print(_currentUser);
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);
        // print(userCredential);
        final box = GetStorage();
        if (box.read('skipintro') != null) {
          box.remove('skipintro');
        }

        CollectionReference users = firestore.collection('users');

        final checkUser = await users.doc(_currentUser!.email).get();

        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            'uid': userCredential!.user!.uid,
            'name': _currentUser!.displayName,
            'email': _currentUser!.email,
            'keyName': _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            'photoUrl': _currentUser!.photoUrl ?? 'noimage',
            'phoneNumber': userCredential!.user!.phoneNumber,
            'status': '',
            'creationTime':
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            'updateTime': DateTime.now().toIso8601String(),
            // 'chats': [],
          });
          await users.doc(_currentUser!.email).collection('chats');
        } else {
          await users.doc(_currentUser!.email).update({
            'lastSignInTime': userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }
        final currUser = await users.doc(_currentUser!.email).get();

        final userModel = currUser.data() as Map<String, dynamic>;

        user(UserModel.fromJson(userModel));

        user.refresh();

        // user(UserModel(
        //   uid: userModel['uid'],
        //   email: userModel['email'],
        //   name: userModel['name'],
        //   keyName: userModel['keyName'],
        //   lastSignInTime: userModel['lastSignInTime'],
        //   creationTime: userModel['creationTime'],
        //   phoneNumber: userModel['phoneNumber'],
        //   status: userModel['status'],
        //   photoUrl: userModel['photoUrl'],
        //   updatedTime: userModel['updatedTime'],
        // ));

        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.length != 0) {
          List<Chats> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChats = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              Chats(
                chatId: dataDocChatId,
                connection: dataDocChats['connection'],
                lastTime: dataDocChats['lastTime'],
                totalUnread: dataDocChats['totalUnread'],
              ),
            );
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }
        user.refresh();
        box.write('skipintro', true);
        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {}
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    // await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void changeProfile(String name, String status, String phoneNumber) {
    CollectionReference users = firestore.collection('users');
    users.doc(_currentUser!.email).update({
      'lastSignInTime':
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'name': name,
      'keyName': name.substring(0, 1).toUpperCase(),
      'status': status,
      'phoneNumber': phoneNumber,
      'updateTime': DateTime.now().toIso8601String(),
    });

    user.update((user) {
      user!.name = name;
      user.status = status;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.phoneNumber = phoneNumber;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = DateTime.now().toIso8601String();
    });

    user.refresh();
    Get.defaultDialog(
      title: 'Success',
      middleText: 'Change Profile Success',
      onConfirm: () => Get.back(),
      textConfirm: 'Yes',
    );
  }

  void updateStatus(String status) async {
    CollectionReference users = firestore.collection('users');
    await users.doc(_currentUser!.email).update({
      'lastSignInTime':
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      'status': status,
      'updateTime': DateTime.now().toIso8601String(),
    });

    user.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = DateTime.now().toIso8601String();
    });

    user.refresh();
    Get.defaultDialog(
      title: 'Success',
      middleText: 'Update Status Success',
      onConfirm: () => Get.back(),
      textConfirm: 'Yes',
    );
  }

  void uploadPhotoUrl(String url) async {
    CollectionReference users = firestore.collection('users');
    await users.doc(_currentUser!.email).update({
      'photoUrl': url,
      'updateTime': DateTime.now().toIso8601String(),
    });

    user.update((user) {
      user!.photoUrl = url;
      user.updatedTime = DateTime.now().toIso8601String();
    });

    user.refresh();
    Get.defaultDialog(
      title: 'Success',
      middleText: 'Update Photo Profile Success',
      onConfirm: () => Get.back(),
      textConfirm: 'Yes',
    );
  }

  void addConnection(String fEmail) async {
    bool newConnect = false;
    var chat_id;
    String dateLastTime = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final dataChat =
        await users.doc(_currentUser!.email).collection('chats').get();

    if (dataChat.docs.length != 0) {
      final checkConnect = await users
          .doc(_currentUser!.email)
          .collection('chats')
          .where('connection', isEqualTo: fEmail)
          .get();

      if (checkConnect.docs.length != 0) {
        newConnect;
        chat_id = checkConnect.docs[0].id;
      } else {
        newConnect = true;
      }
    } else {
      newConnect = true;
    }

    if (newConnect) {
      final chatDocs = await chats.where(
        'connections',
        whereIn: [
          [_currentUser!.email, fEmail],
          [
            fEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatDocs.docs.length != 0) {
        final chatDataId = chatDocs.docs[0].id;
        final chatData = chatDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection('chats')
            .doc(chatDataId)
            .set({
          'connection': fEmail,
          'chat_id': chatDataId,
          'lastTime': chatData['lastTime'],
          'total_unread': 0
        });

        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.length != 0) {
          List<Chats> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChats = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              Chats(
                chatId: dataDocChatId,
                connection: dataDocChats['connection'],
                lastTime: dataDocChats['lastTime'],
                totalUnread: dataDocChats['totalUnread'],
              ),
            );
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        // dataChat.add({
        //   'connection': fEmail,
        //   'chat_id': chatDataId,
        //   'lastTime': chatData['lastTime'],
        //   'total_unread': 0
        // });

        // await users.doc(_currentUser!.email).update({'chats': dataChat});

        // user.update((user) {
        //   user!.chats = dataChat as List<Chats>;
        //   user!.chats = dataChat.map((e) => Chats.fromJson(e)).toList();
        // });

        chat_id = chatDataId;
        user.refresh();
      } else {
        final newChat = await chats.add({
          'connections': [
            _currentUser!.email,
            fEmail,
          ],
        });

        await chats.doc(newChat.id).collection('chats');

        await users
            .doc(_currentUser!.email)
            .collection('chats')
            .doc(newChat.id)
            .set({
          'connection': fEmail,
          'chat_id': newChat.id,
          'lastTime': dateLastTime,
          'total_unread': 0
        });

        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.length != 0) {
          List<Chats> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChats = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(
              Chats(
                chatId: dataDocChatId,
                connection: dataDocChats['connection'],
                lastTime: dataDocChats['lastTime'],
                totalUnread: dataDocChats['totalUnread'],
              ),
            );
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        // dataChat.add({
        //   'connection': fEmail,
        //   'chat_id': newChat.id,
        //   'lastTime': dateLastTime,
        //   'total_unread': 0
        // });

        // await users.doc(_currentUser!.email).update({'chats': dataChat});

        // user.update((user) {
        //   user!.chats = dataChat as List<Chats>;
        // });

        chat_id = newChat.id;
        user.refresh();
      }
    }

    final updateRead = await chats
        .doc(chat_id)
        .collection('chat')
        .where('isRead', isEqualTo: false)
        .where('to', isEqualTo: _currentUser!.email)
        .get();

    updateRead.docs.forEach((element) async {
      await chats.doc(chat_id).collection('chat').doc(element.id).update(
        {
          'isRead': true,
        },
      );
    });

    await users
        .doc(_currentUser!.email)
        .collection('chats')
        .doc(chat_id)
        .update(
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

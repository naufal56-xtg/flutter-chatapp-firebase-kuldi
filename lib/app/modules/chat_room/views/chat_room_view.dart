import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_chatapp_project/app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final AuthController authC = Get.find();
    final chat_id = (Get.arguments! as Map<String, dynamic>)['chat_id'];
    final fEmail = (Get.arguments! as Map<String, dynamic>)['fEmail'];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          leadingWidth: 88,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: StreamBuilder<DocumentSnapshot<Object?>>(
                      stream: controller.streamData(fEmail),
                      builder: (context, snapshotAva) {
                        if (snapshotAva.connectionState ==
                            ConnectionState.active) {
                          final dataAva =
                              snapshotAva.data!.data() as Map<String, dynamic>;
                          if (dataAva['photoUrl'] == 'noimage') {
                            return Image.asset(
                              'assets/logo/noimage.png',
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Image.network(
                              dataAva['photoUrl'],
                              fit: BoxFit.cover,
                            );
                          }
                        }
                        return Image.asset(
                          'assets/logo/noimage.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: InkWell(
            onTap: () {},
            child: StreamBuilder<DocumentSnapshot<Object?>>(
              stream: controller.streamData(fEmail),
              builder: (context, snapshotAva) {
                if (snapshotAva.connectionState == ConnectionState.active) {
                  final data = snapshotAva.data!.data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data['name']}",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        "${data['status']}",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            if (controller.emojiShowing.isTrue) {
              controller.emojiShowing.value = false;
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamChats(chat_id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final chatsMsg = snapshot.data!.docs;
                        Timer(
                          Duration.zero,
                          () => controller.scrollC.jumpTo(
                              controller.scrollC.position.maxScrollExtent),
                        );
                        return ListView.builder(
                          controller: controller.scrollC,
                          itemCount: chatsMsg.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Card(
                                    color: Colors.grey[200],
                                    shadowColor: Colors.grey[850],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(top: 5),
                                      width: 140,
                                      height: 25,
                                      child: Text(
                                        '${chatsMsg[index]['groupTime']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ChatWidget(
                                    isSend: chatsMsg[index]['from'] ==
                                            authC.user.value.email!
                                        ? true
                                        : false,
                                    msg: '${chatsMsg[index]['message']}',
                                    time: '${chatsMsg[index]['time']}',
                                  )
                                ],
                              );
                            } else {
                              if (chatsMsg[index]['groupTime'] ==
                                  chatsMsg[index - 1]['groupTime']) {
                                return ChatWidget(
                                  isSend: chatsMsg[index]['from'] ==
                                          authC.user.value.email!
                                      ? true
                                      : false,
                                  msg: '${chatsMsg[index]['message']}',
                                  time: '${chatsMsg[index]['time']}',
                                );
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      color: Colors.grey[200],
                                      shadowColor: Colors.grey[850],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        width: 140,
                                        height: 25,
                                        child: Text(
                                          '${chatsMsg[index]['groupTime']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ChatWidget(
                                      isSend: chatsMsg[index]['from'] ==
                                              authC.user.value.email!
                                          ? true
                                          : false,
                                      msg: '${chatsMsg[index]['message']}',
                                      time: '${chatsMsg[index]['time']}',
                                    )
                                  ],
                                );
                              }
                            }
                          },
                        );
                      }
                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: controller.emojiShowing.isTrue
                        ? 5
                        : context.mediaQueryPadding.bottom),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          autocorrect: false,
                          // onEditingComplete: () {
                          //   controller.newChats(
                          //     controller.textC.text,
                          //     authC.user.value.email!,
                          //     chat_id,
                          //     fEmail,
                          //   );
                          // },
                          controller: controller.textC,
                          focusNode: controller.focus,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              onPressed: () {
                                controller.focus.unfocus();
                                controller.emojiShowing.toggle();
                              },
                              icon: const Icon(
                                Icons.emoji_emotions_outlined,
                                size: 30,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        controller.newChats(
                          controller.textC.text,
                          authC.user.value.email!,
                          chat_id,
                          fEmail,
                        );
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.red[900],
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => controller.emojiShowing.isTrue
                    ? SizedBox(
                        height: 250,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            controller.addEmoji(emoji);
                          },
                          onBackspacePressed: () => controller.deleteEmoji(),
                          textEditingController: _controller,
                          config: Config(
                            columns: 7,
                            // Issue: https://github.com/flutter/flutter/issues/28894
                            emojiSizeMax: 32 *
                                (foundation.defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                    ? 1.30
                                    : 1.0),
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            gridPadding: EdgeInsets.zero,
                            initCategory: Category.RECENT,
                            bgColor: const Color(0xFFF2F2F2),
                            indicatorColor: Color(0xFFB71C1C),
                            iconColor: Colors.grey,
                            iconColorSelected: Color(0xFFB71C1C),
                            backspaceColor: Color(0xFFB71C1C),
                            skinToneDialogBgColor: Colors.white,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: true,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            replaceEmojiOnLimitExceed: false,
                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ),
                            loadingIndicator: const SizedBox.shrink(),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                            checkPlatformCompatibility: true,
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ));
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.isSend,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSend;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment:
            isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSend ? Colors.red[900] : Colors.redAccent,
              borderRadius: isSend
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            padding: EdgeInsets.all(15),
            child: Text(
              '$msg',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            DateFormat.Hm().format(
              DateTime.parse(time),
            ),
          ),
        ],
      ),
      alignment: isSend ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}

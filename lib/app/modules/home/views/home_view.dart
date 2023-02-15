import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp_project/app/controllers/auth_controller.dart';
import 'package:flutter_chatapp_project/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              // color: Colors.red,
              // margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: BoxDecoration(
                color: Colors.red[900],
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                    width: 2,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 30, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.PROFILE),
                    child: Icon(
                      Icons.settings,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.listChat(authC.user.value.email!),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.active) {
                    final chats = snapshot1.data!.docs;
                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: controller
                              .listFriends(chats[index]['connection']),
                          builder: (context, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.active) {
                              final data = snapshot2.data!.data();
                              return data!['status'] == ''
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          controller.goToChatRoom(
                                            "${chats[index].id}",
                                            authC.user.value.email!,
                                            chats[index]['connection'],
                                          );
                                        },
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.black38,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: data['photoUrl'] == 'noimage'
                                                ? Image.asset(
                                                    'assets/logo/noimage.png',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    data['photoUrl'],
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        title: Text(
                                          "${data['name']}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        trailing:
                                            chats[index]['total_unread'] == 0
                                                ? SizedBox()
                                                : Chip(
                                                    label: Text(
                                                      "${chats[index]['total_unread']}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Colors.red[900],
                                                  ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          controller.goToChatRoom(
                                            "${chats[index].id}",
                                            authC.user.value.email!,
                                            chats[index]['connection'],
                                          );
                                        },
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.black38,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: data['photoUrl'] == 'noimage'
                                                ? Image.asset(
                                                    'assets/logo/noimage.png',
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    data['photoUrl'],
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        title: Text(
                                          "${data['name']}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${data['status']}",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        trailing:
                                            chats[index]['total_unread'] == 0
                                                ? SizedBox()
                                                : Chip(
                                                    label: Text(
                                                      "${chats[index]['total_unread']}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Colors.red[900],
                                                  ),
                                      ),
                                    );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: Icon(Icons.search),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}

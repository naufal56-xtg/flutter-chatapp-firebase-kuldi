import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp_project/app/controllers/auth_controller.dart';
import 'package:flutter_chatapp_project/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => authC.logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Container(
                child: Column(
                  children: [
                    AvatarGlow(
                      endRadius: 110,
                      glowColor: Colors.black,
                      duration: Duration(seconds: 2),
                      child: Container(
                        height: 175,
                        width: 175,
                        child: Obx(
                          () => ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: authC.user.value.photoUrl == 'noimage'
                                ? Image.asset(
                                    'assets/logo/noimage.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    authC.user.value.photoUrl!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => Text(
                        "${authC.user.value.name}",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${authC.user.value.email}",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                      leading: Icon(
                        Icons.person,
                        size: 30,
                      ),
                      title: Text(
                        "Change Profile",
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                        size: 30,
                      ),
                    ),
                    ListTile(
                      onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                      leading: Icon(
                        Icons.note_add_outlined,
                        size: 30,
                      ),
                      title: Text(
                        "Update Status",
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                        size: 30,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        Icons.color_lens,
                        size: 30,
                      ),
                      title: Text(
                        "Change Theme",
                        style: TextStyle(
                          fontSize: 22.0,
                        ),
                      ),
                      trailing: Text('Light'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: context.mediaQueryPadding.bottom + 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ChatApp",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "V 1.2.0",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

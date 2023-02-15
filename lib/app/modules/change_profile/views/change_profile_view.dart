import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp_project/app/controllers/auth_controller.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  const ChangeProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find();
    controller.emailC.text = authC.user.value.email!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status ?? '';
    controller.phoneC.text = authC.user.value.phoneNumber ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Colors.red[900],
        title: Text(
          "Change Profile",
          style: TextStyle(
            fontSize: 28.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authC.changeProfile(controller.nameC.text,
                  controller.statusC.text, controller.phoneC.text);
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            AvatarGlow(
              endRadius: 90,
              glowColor: Colors.black,
              duration: Duration(seconds: 2),
              child: Container(
                height: 150,
                width: 150,
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
            TextField(
              readOnly: true,
              autofocus: false,
              controller: controller.emailC,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Input Update Status In Here ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              autofocus: false,
              controller: controller.nameC,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Name Profile',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Input Update Status In Here ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              autofocus: false,
              controller: controller.phoneC,
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Input Update Status In Here ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              autofocus: false,
              controller: controller.statusC,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              onEditingComplete: () => authC.changeProfile(
                  controller.nameC.text,
                  controller.statusC.text,
                  controller.phoneC.text),
              decoration: InputDecoration(
                labelText: 'Status',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Input Update Status In Here ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<ChangeProfileController>(
                  builder: (c) => c.pickImage != null
                      ? Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(c.pickImage!.path),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IconButton(
                                      onPressed: () => c.deleteImage(),
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        controller
                                            .uploadImage(authC.user.value.uid!)
                                            .then((value) {
                                          if (value != null) {
                                            authC.uploadPhotoUrl(value);
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.upload,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   child: Text(
                                  //     "Update",
                                  //     style: TextStyle(
                                  //       fontSize: 14.0,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Text('No Image'),
                ),
                TextButton(
                  onPressed: () {
                    controller.selectImage();
                  },
                  child: Text(
                    "Choose File ...",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              // width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  authC.changeProfile(controller.nameC.text,
                      controller.statusC.text, controller.phoneC.text);
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

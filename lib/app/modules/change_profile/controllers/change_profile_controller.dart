import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late TextEditingController phoneC;
  // late ImagePicker imageC;
  final ImagePicker _picker = ImagePicker();

  fs.FirebaseStorage firebaseStorage = fs.FirebaseStorage.instance;

  XFile? pickImage = null;

  Future<String?> uploadImage(String uid) async {
    String ext = p.extension(pickImage!.path);
    fs.Reference ref = firebaseStorage.ref('users/profile/$uid.$ext');

    File file = File(pickImage!.path);
    try {
      await ref.putFile(file);
      pickImage = null;
      final photoUrl = ref.getDownloadURL();
      return photoUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void selectImage() async {
    try {
      final dataImage = await _picker.pickImage(source: ImageSource.gallery);
      if (dataImage != null) {
        pickImage = dataImage;
      }
      update();
    } catch (e) {
      print(e);
      pickImage = null;
      update();
    }
  }

  void deleteImage() {
    pickImage = null;
    update();
  }

  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    phoneC = TextEditingController();
    // imageC = ImagePicker();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    phoneC.dispose();
    super.onClose();
  }
}

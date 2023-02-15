import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStatusController extends GetxController {
  late TextEditingController updateStatusC;
  @override
  void onInit() {
    updateStatusC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    updateStatusC.dispose();
    super.onClose();
  }
}

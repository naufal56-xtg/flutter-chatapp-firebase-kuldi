import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  const UpdateStatusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find();
    controller.updateStatusC.text = authC.user.value.status ?? '';
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
          "Update Status",
          style: TextStyle(
            fontSize: 28.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: controller.updateStatusC,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              onEditingComplete: () =>
                  authC.updateStatus(controller.updateStatusC.text),
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
              height: 25,
            ),
            Container(
              // width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  authC.updateStatus(controller.updateStatusC.text);
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

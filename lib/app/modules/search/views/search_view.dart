import 'package:flutter/material.dart';
import 'package:flutter_chatapp_project/app/controllers/auth_controller.dart';
import 'package:flutter_chatapp_project/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.red[900],
          title: Text(
            "Search",
            style: TextStyle(
              fontSize: 28.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Padding(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: TextField(
                  onChanged: (value) {
                    controller.searchField(value, authC.user.value.email!);
                  },
                  controller: controller.searchC,
                  autocorrect: false,
                  cursorColor: Colors.red[900],
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search New Friend Here ...',
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      child: Icon(
                        Icons.search,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.tempSearch.length == 0
            ? Center(
                child: Container(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  child: Lottie.asset('assets/lottie/empty.json'),
                ),
              )
            : ListView.builder(
                itemCount: controller.tempSearch.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3.2,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black38,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: controller.tempSearch[index]['photoUrl'] ==
                                  'noimage'
                              ? Image.asset(
                                  'assets/logo/noimage.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  controller.tempSearch[index]['photoUrl'],
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      title: Text(
                        "${controller.tempSearch[index]['name']}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "${controller.tempSearch[index]['email']}",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          authC.addConnection(
                            controller.tempSearch[index]['email'],
                          );
                        },
                        child: Chip(
                          padding: EdgeInsets.symmetric(horizontal: -1),
                          label: Text(
                            "Message",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red[900],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}

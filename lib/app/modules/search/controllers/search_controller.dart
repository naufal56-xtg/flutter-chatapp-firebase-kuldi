import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchC;

  var firstQuery = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchField(String data, String email) async {
    if (data.length == 0) {
      firstQuery.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalized);

      if (firstQuery.length == 0 && data.length == 1) {
        CollectionReference users = await firestore.collection('users');
        final keyWordResult = await users
            .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: email)
            .get();

        if (keyWordResult.docs.length > 0) {
          for (int i = 0; i < keyWordResult.docs.length; i++) {
            firstQuery
                .add(keyWordResult.docs[i].data() as Map<String, dynamic>);

            print('Query Result : $firstQuery');
          }
        } else {
          print('Tidak Ada Query');
        }
      }
      if (firstQuery.length != 0) {
        tempSearch.value = [];
        firstQuery.forEach((element) {
          if (element['name'].startsWith(capitalized)) {
            tempSearch.add(element);
          }
        });
      }
    }
    firstQuery.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}

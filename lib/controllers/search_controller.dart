import 'package:flutter/cupertino.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final searchKey = ''.obs;
  TextEditingController textEditingController = TextEditingController();
  FireStoreDB fireStoreDB = FireStoreDB.getInstance();
  Rx streamQuery = new Rx();

  @override
  void onInit() {
    streamQuery.value = fireStoreDB.searchDefaultResults();
    super.onInit();
  }

  onChangedSearch(String value) {
    searchKey.value = value.toUpperCase();
    streamQuery.value = fireStoreDB.searchOnChanged(searchKey.value);
    update();
  }

  searchDefault() {
    searchKey.value = '';
    streamQuery.value = fireStoreDB.searchDefaultResults();
    textEditingController.clear();
    update();
  }
}

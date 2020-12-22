import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:foreign_movie_watch/models/serie.dart';
import 'package:get/get.dart';

class SerieController extends GetxController {
  FireStoreDB fireStoreDB = FireStoreDB.getInstance();
  ScrollController scrollController = new ScrollController();
  var serieList = <Serie>[].obs;
  RxBool isLoading = true.obs;
  QuerySnapshot collectionState;
  Serie selectedSerie;
  @override
  void onInit() {
    getDocuments();
    listenScrolll();
    super.onInit();
  }

  void listenScrolll() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('Serie ListView scroll at top');
        else {
          print('Serie ListView scroll at bottom');
          getDocumentsNext();
        }
      }
    });
  }

  Future<void> getDocuments() async {
    isLoading.value = true;
    var collection = fireStoreDB.getSeries();
    fetchDocuments(collection);
  }

  Future<void> getDocumentsNext() async {
    if (collectionState.docs.length > 0) {
      var lastVisible = collectionState.docs[collectionState.docs.length - 1];
      print('Serie List legnth: ${collectionState.size} last: $lastVisible');
      var collection = fireStoreDB.getNextSeries(lastVisible);
      fetchDocuments(collection);
    }
  }

  fetchDocuments(Query collection) {
    collection.get().then((value) {
      collectionState = value;
      value.docs.forEach((element) {
        print('getSeries ${element.data()}');
        serieList.add(Serie.fromJson(element.id, element.data()));
      });
      isLoading.value = false;
      update();
    });
  }
}

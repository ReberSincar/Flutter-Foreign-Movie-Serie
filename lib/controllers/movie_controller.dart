import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:foreign_movie_watch/models/movie.dart';
import 'package:get/get.dart';

class MovieController extends GetxController {
  FireStoreDB fireStoreDB = FireStoreDB.getInstance();
  ScrollController scrollController = new ScrollController();
  var documentList = <Movie>[].obs;
  var isLoading = true.obs;
  QuerySnapshot collectionState;
  Movie selectedMovie;
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
          print('Movie ListView scroll at top');
        else {
          print('Movie ListView scroll at bottom');
          getDocumentsNext();
        }
      }
    });
  }

  Future<void> getDocuments() async {
    isLoading.value = true;
    var collection = fireStoreDB.getMovies();
    fetchDocuments(collection);
  }

  Future<void> getDocumentsNext() async {
    if (collectionState.docs.length > 0) {
      var lastVisible = collectionState.docs[collectionState.docs.length - 1];
      print('Movie List legnth: ${collectionState.size} last: $lastVisible');
      var collection = fireStoreDB.getNextMovies(lastVisible);
      fetchDocuments(collection);
    }
  }

  fetchDocuments(Query collection) {
    collection.get().then((value) {
      collectionState = value;
      value.docs.forEach((element) {
        print('getMovies ${element.data()}');
        documentList.add(Movie.fromJson(element.id, element.data()));
      });
      isLoading.value = false;
      update();
      print(documentList.length.toString());
    });
  }
}

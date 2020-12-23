import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:foreign_movie_watch/models/episode.dart';
import 'package:foreign_movie_watch/models/serie.dart';
import 'package:get/get.dart';

class EpisodeController extends GetxController {
  FireStoreDB fireStoreDB = FireStoreDB.getInstance();
  Serie selectedSerie;
  var seasonID = "Season-1".obs;
  ScrollController scrollController = new ScrollController();
  var documentList = <Episode>[].obs;
  Episode selectedEpisode;
  QuerySnapshot collectionState;
  List<DropdownMenuItem> seasonItems = [];

  @override
  void onInit() {
    listenScrolll();
    super.onInit();
  }

  fillSeasonDropdown() {
    seasonItems.clear();
    for (var i = 1; i <= selectedSerie.seasonsCount; i++) {
      seasonItems.add(
        DropdownMenuItem(
          child: Text(
            "season".tr + " $i",
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          value: "Season-$i",
        ),
      );
    }
  }

  changeSerie(Serie newSerie) {
    selectedSerie = newSerie;
    getDocuments();
    seasonID.value = "Season-1";
  }

  changeSeason(String newSeasonID) {
    seasonID.value = newSeasonID;
    getDocuments();
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
    documentList.clear();
    var collection =
        fireStoreDB.getEpisodes(selectedSerie.documentID, seasonID.value);
    fetchDocuments(collection);
  }

  Future<void> getDocumentsNext() async {
    if (collectionState.docs.length > 0) {
      var lastVisible = collectionState.docs[collectionState.docs.length - 1];
      print('Movie List legnth: ${collectionState.size} last: $lastVisible');
      var collection = fireStoreDB.getNextEpisodes(
          selectedSerie.documentID, seasonID.value, lastVisible);
      fetchDocuments(collection);
    }
  }

  fetchDocuments(Query collection) {
    collection.get().then((value) {
      collectionState = value;
      value.docs.forEach((element) {
        print('getMovies ${element.data()}');
        documentList.add(Episode.fromJson(element.data()));
        update();
      });
      print(documentList.length.toString());
    });
  }
}

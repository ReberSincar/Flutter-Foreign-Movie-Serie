import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/controllers/episode_controller.dart';
import 'package:foreign_movie_watch/controllers/movie_controller.dart';
import 'package:foreign_movie_watch/controllers/search_controller.dart';
import 'package:foreign_movie_watch/controllers/serie_controller.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:foreign_movie_watch/models/movie.dart';
import 'package:foreign_movie_watch/models/serie.dart';
import 'package:foreign_movie_watch/ui/pages/serie_detail.dart';
import 'package:get/get.dart';

import 'movie_detail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController searchController = Get.find();
  final SerieController serieController = Get.find();
  final EpisodeController episodeController = Get.find();
  final MovieController movieController = Get.find();
  FireStoreDB fireStoreDB = FireStoreDB.getInstance();

  @override
  void initState() {
    searchController.textEditingController.clear();
    searchController.searchKey.value = "";
    searchController.streamQuery.value = fireStoreDB.searchDefaultResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: buildSearchBar(context),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: buildSearchResults(),
      ),
    );
  }

  Obx buildSearchResults() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(top: 15),
        child: StreamBuilder<QuerySnapshot>(
          stream: searchController.streamQuery.value,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: buildLoading());
              default:
                return snapshot.data.docs.length != 0
                    ? buildResultList(snapshot)
                    : buildNoResult();
            }
          },
        ),
      ),
    );
  }

  Center buildNoResult() {
    return Center(
      child: Text(
        'search_no_result'.tr,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  ListView buildResultList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.separated(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: snapshot.data.docs.length,
      itemBuilder: (BuildContext context, int index) {
        var document = snapshot.data.docs[index];
        var model;
        bool isSerie = document.data()["type"] == 0 ? true : false;
        if (isSerie) {
          model = new Serie.fromJson(document.id, document.data());
        } else {
          model = new Movie.fromJson(document.id, document.data());
        }
        return buildSearchResultContainer(isSerie, model);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Divider(color: Colors.white, indent: 15, endIndent: 15),
        );
      },
    );
  }

  InkWell buildSearchResultContainer(bool isSerie, model) {
    return InkWell(
      onTap: () {
        if (isSerie) {
          serieController.selectedSerie = model;
          episodeController.changeSerie(model);
          Get.to(SerieDetailsPage());
        } else {
          movieController.selectedMovie = model;
          Get.to(MovieDetailPage());
        }
      },
      focusColor: Colors.red,
      child: Row(
        children: [
          Container(
            child: CachedNetworkImage(
                imageUrl: model.contentImage,
                width: 100,
                height: 100,
                placeholder: (context, url) {
                  return Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: RefreshProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  );
                },
                fit: BoxFit.cover),
          ),
          Text(
            model.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Container buildLoading() {
    return Container(
      width: 100,
      height: 200,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          child: RefreshProgressIndicator(),
        ),
      ),
    );
  }

  Theme buildSearchBar(BuildContext context) {
    return Theme(
      data: new ThemeData(
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
        hintColor: Colors.grey,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
      ),
      child: Obx(
        () => TextField(
            controller: searchController.textEditingController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "search_bar_hint".tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(),
              ),
              prefixIcon: BackButton(),
              suffixIcon: searchController.searchKey.value.length == 0
                  ? IconButton(
                      onPressed: () {},
                      focusColor: Colors.blue,
                      icon: Icon(Icons.search),
                    )
                  : IconButton(
                      onPressed: () {
                        searchController.searchDefault();
                      },
                      focusColor: Colors.red,
                      icon: Icon(Icons.clear),
                    ),
            ),
            onChanged: (value) {
              if (value.length == 0) {
                searchController.searchDefault();
              } else {
                searchController.onChangedSearch(value);
              }
            }),
      ),
    );
  }
}

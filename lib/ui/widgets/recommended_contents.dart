import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/controllers/episode_controller.dart';
import 'package:foreign_movie_watch/controllers/movie_controller.dart';
import 'package:foreign_movie_watch/controllers/serie_controller.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:foreign_movie_watch/models/movie.dart';
import 'package:foreign_movie_watch/models/serie.dart';
import 'package:foreign_movie_watch/ui/pages/movie_detail.dart';
import 'package:foreign_movie_watch/ui/pages/serie_detail.dart';
import 'package:get/get.dart';

class RecommendedContainer extends StatelessWidget {
  final MovieController movieController = Get.find();
  final FireStoreDB fireStoreDB = FireStoreDB.getInstance();
  final EpisodeController episodeController = Get.find();
  final SerieController serieController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 16.0),
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: fireStoreDB
            .getRecommendedMovies(movieController.selectedMovie.genre),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null)
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: RefreshProgressIndicator(),
              ),
            );
          if (snapshot.hasError)
            return new Text(
              'Error: ${snapshot.error}',
              overflow: TextOverflow.ellipsis,
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              return ListView.builder(
                scrollDirection: Axis.horizontal,
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
                  if (document.id == movieController.selectedMovie.documentID) {
                    return Container();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (isSerie) {
                            movieController.selectedMovie = model;
                            Get.to(MovieDetailPage());
                          } else {
                            serieController.selectedSerie = model;
                            episodeController.changeSerie(model);
                            Get.to(SerieDetailsPage());
                          }
                        },
                        focusColor: Colors.blue,
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 120,
                                child: CachedNetworkImage(
                                  imageUrl: model.contentImage,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  placeholder: (context, url) {
                                    return Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: RefreshProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 115,
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  model.name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
          }
        },
      ),
    );
  }
}

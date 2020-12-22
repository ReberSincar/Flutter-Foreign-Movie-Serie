import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/constants/styles.dart';
import 'package:foreign_movie_watch/controllers/movie_controller.dart';
import 'package:foreign_movie_watch/models/movie.dart';
import 'package:foreign_movie_watch/ui/pages/movie_detail.dart';
import 'package:get/get.dart';

class MovieContainer extends StatelessWidget {
  MovieContainer({Key key, this.index}) : super(key: key);
  final index;
  final MovieController movieController = Get.find();
  @override
  Widget build(BuildContext context) {
    Movie movie = movieController.documentList[index];
    return InkWell(
      onTap: () {
        movieController.selectedMovie = movie;
        Get.to(MovieDetailPage());
      },
      focusColor: Colors.blue,
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: GridTile(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
                imageUrl: movie.contentImage,
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
          footer: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              movie.name,
              style: whiteTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

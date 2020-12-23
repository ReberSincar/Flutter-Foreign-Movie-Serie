import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/constants/styles.dart';
import 'package:foreign_movie_watch/controllers/serie_controller.dart';
import 'package:foreign_movie_watch/controllers/episode_controller.dart';
import 'package:foreign_movie_watch/models/serie.dart';
import 'package:foreign_movie_watch/ui/pages/serie_detail.dart';
import 'package:foreign_movie_watch/ui/widgets/custom_cached_image.dart';
import 'package:get/get.dart';

class SerieContainer extends StatelessWidget {
  SerieContainer({Key key, this.index}) : super(key: key);
  final EpisodeController episodeController = Get.find();
  final SerieController serieController = Get.find();
  final index;
  @override
  Widget build(BuildContext context) {
    Serie serie = serieController.serieList[index];
    return InkWell(
      onTap: () {
        serieController.selectedSerie = serie;
        episodeController.changeSerie(serie);
        Get.to(SerieDetailsPage());
      },
      focusColor: Colors.blue,
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: GridTile(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomCachedImage(imageUrl: serie.contentImage),
          ),
          footer: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              serie.name,
              overflow: TextOverflow.ellipsis,
              style: whiteTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

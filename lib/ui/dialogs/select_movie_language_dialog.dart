import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/ads/ironsource_ads.dart';
import 'package:foreign_movie_watch/controllers/movie_controller.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class SelectMovieLanguageDialog extends StatelessWidget {
  SelectMovieLanguageDialog();
  final MovieController movieController = Get.find();
  final IronSourceAdsController adsController = Get.find();
  final FireStoreDB fireStoreDB = FireStoreDB.getInstance();

  @override
  Widget build(BuildContext context) {
    return DialogBackground(
      blur: 2,
      dismissable: true,
      dialog: StatefulBuilder(
        builder: (context, setState) => Container(
          width: Get.width / 2,
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(30),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: Colors.white);
            },
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: movieController.selectedMovie.flags.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  adsController.videoLink =
                      movieController.selectedMovie.videoLink;
                  adsController.subtitleLink =
                      movieController.selectedMovie.subtitles[index];
                  adsController.title = movieController.selectedMovie.name;
                  adsController.desc = "";
                  adsController.showRewardedVideo();
                  fireStoreDB.addViewCount(
                      movieController.selectedMovie.documentID,
                      movieController.selectedMovie.watchCount);
                },
                focusColor: Colors.blue,
                child: Image.network(
                  movieController.selectedMovie.flags[index],
                  width: 40,
                  height: 30,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

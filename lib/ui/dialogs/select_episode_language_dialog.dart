import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/ads/ironsource_ads.dart';
import 'package:foreign_movie_watch/controllers/episode_controller.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class SelectEpisodeLanguageDialog extends StatelessWidget {
  final EpisodeController episodeController = Get.find();
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
            itemCount: episodeController.selectedEpisode.episodeFlags.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  adsController.videoLink =
                      episodeController.selectedEpisode.episodeLink;
                  adsController.subtitleLink =
                      episodeController.selectedEpisode.episodeSubtitles[index];
                  adsController.title = episodeController.selectedSerie.name;
                  adsController.desc =
                      episodeController.selectedEpisode.episodeName;
                  adsController.showRewardedVideo();
                  fireStoreDB.addViewCount(
                      episodeController.selectedSerie.documentID,
                      episodeController.selectedSerie.watchCount);
                },
                focusColor: Colors.blue,
                child: Image.network(
                  episodeController.selectedEpisode.episodeFlags[index],
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

import 'package:flutter/material.dart';
import 'package:iqplayer/iqplayer.dart';
import 'package:get/get.dart';

class IQPlayerPage extends StatelessWidget {
  IQPlayerPage(
      {Key key,
      this.videoLink,
      this.subtitleLink,
      this.title,
      this.description});
  final String subtitleLink;
  final String videoLink;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back();
        Get.back();
        return null;
      },
      child: IQScreen(
        title: title,
        description: description,
        videoPlayerController: VideoPlayerController.network(videoLink),
        subtitleProvider: SubtitleProvider.fromNetwork(subtitleLink),
        iqTheme: IQTheme(
          loadingProgress: Center(
            child: RefreshProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          playButtonColor: Colors.transparent,
          videoPlayedColor: Colors.red,
          backgroundProgressColor: Colors.white,
          playButton: (context, isPlay, animationController) {
            if (isPlay) {
              return Icon(
                Icons.pause_circle_filled,
                color: Colors.red,
                size: 50,
              );
            }
            return Icon(
              Icons.play_circle_outline,
              color: Colors.red,
              size: 50,
            );
          },
        ),
      ),
    );
  }
}

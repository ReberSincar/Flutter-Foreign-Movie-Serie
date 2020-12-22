import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/controllers/episode_controller.dart';
import 'package:foreign_movie_watch/ui/dialogs/select_episode_language_dialog.dart';
import 'package:foreign_movie_watch/ui/widgets/custom_cached_image.dart';
import 'package:get/get.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

class SerieDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SerieDetailsPageState();
  }
}

class _SerieDetailsPageState extends State<SerieDetailsPage> {
  final EpisodeController episodeController = Get.find();
  Orientation orientation;
  @override
  void initState() {
    episodeController.fillSeasonDropdown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        this.orientation = orientation;
        return orientation == Orientation.portrait
            ? buildPortraitScaffold(context)
            : buildLandscapeScaffold(context);
      },
    );
  }

  Scaffold buildLandscapeScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 50,
        title: Text(
          episodeController.selectedSerie.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      body: ListView(
        children: [
          buildDescPhotoContainer(context),
          sezonsDropdown(),
          Divider(color: Colors.white),
          buildEpisodeList(),
        ],
      ),
    );
  }

  Scaffold buildPortraitScaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          buildSliverAppBar(context),
          new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                buildDescPhotoContainer(context),
                sezonsDropdown(),
                Divider(color: Colors.white),
                buildEpisodeList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sezonsDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "serie_detail_seasons".tr,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.grey.shade900,
                ),
                child: Obx(
                  () => OutlineDropdownButton(
                    elevation: 1,
                    items: episodeController.seasonItems,
                    onChanged: (value) async {
                      if (episodeController.seasonID.value != value) {
                        episodeController.seasonID.value = value;
                        episodeController.changeSeason(value);
                      }
                    },
                    value: episodeController.seasonID.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Obx buildEpisodeList() {
    return Obx(
      () => episodeController.documentList.length == 0
          ? Padding(
              padding: EdgeInsets.only(top: 15),
              child: Center(
                child: RefreshProgressIndicator(),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              controller: episodeController.scrollController,
              itemCount: episodeController.documentList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    episodeController.selectedEpisode =
                        episodeController.documentList[index];
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => SelectEpisodeLanguageDialog(),
                    );
                  },
                  focusColor: Colors.blue,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: orientation == Orientation.portrait ? 10 : 5,
                            child: Image.asset("assets/play_icon.png"),
                          ),
                          Spacer(
                            flex: 5,
                          ),
                          Expanded(
                            flex: 40,
                            child: Text(
                              "episode".tr +
                                  " " +
                                  episodeController
                                      .documentList[index].episodeSeq
                                      .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Spacer(
                            flex: 5,
                          ),
                          Expanded(
                            flex: 45,
                            child: Text(
                              episodeController.selectedSerie.duration +
                                  " " +
                                  'duration_min'.tr,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      buildFlagGrid(index),
                      Divider(color: Colors.white),
                    ],
                  ),
                );
              },
            ),
    );
  }

  GridView buildFlagGrid(int index) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: orientation == Orientation.portrait
          ? SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10, mainAxisSpacing: 5, crossAxisSpacing: 5)
          : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 15, mainAxisSpacing: 1, crossAxisSpacing: 1),
      itemCount: episodeController.documentList[index].episodeFlags.length,
      itemBuilder: (context, subIndex) {
        return CustomCachedImage(
            imageUrl:
                episodeController.documentList[index].episodeFlags[subIndex]);
      },
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0,
      backgroundColor: Colors.black,
      pinned: true,
      elevation: 50,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(episodeController.selectedSerie.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            )),
        background: SizedBox(
          child: Stack(children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: CustomCachedImage(
                imageUrl: episodeController.selectedSerie.contentImage,
              ),
            ),
            SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.5, 1.0],
                      colors: [Colors.black38, Colors.black]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Container buildDescPhotoContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 124,
                height: 180,
                child: CustomCachedImage(
                    imageUrl: episodeController.selectedSerie.contentImage),
              ),
              SizedBox(width: 10),
              Container(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 190,
                      margin: EdgeInsets.only(left: 16, right: 16.0),
                      child: Text(
                        episodeController.selectedSerie.desc,
                        maxLines: 10,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

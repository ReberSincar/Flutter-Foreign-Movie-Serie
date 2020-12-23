import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/ads/ironsource_ads.dart';
import 'package:foreign_movie_watch/controllers/movie_controller.dart';
import 'package:foreign_movie_watch/db/firestore_db.dart';
import 'package:foreign_movie_watch/ui/dialogs/select_movie_language_dialog.dart';
import 'package:foreign_movie_watch/ui/widgets/custom_cached_image.dart';
import 'package:foreign_movie_watch/ui/widgets/recommended_contents.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MovieDetailPage extends StatelessWidget {
  MovieDetailPage({Key key}) : super(key: key);
  final MovieController movieController = Get.find();
  final IronSourceAdsController adsController = Get.find();
  final FireStoreDB fireStoreDB = FireStoreDB.getInstance();
  Orientation orientation;
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
          movieController.selectedMovie.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: buildDescPhotoContainer(context),
              ),
              Expanded(
                flex: 2,
                child: buildMovieFlags(),
              )
            ],
          ),
          Divider(color: Colors.white),
          buildPlayButton(context),
          RecommendedContainer(),
        ],
      ),
    );
  }

  InkWell buildPlayButton(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(width: 10),
          Text(
            "movie_detail_play".tr,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          )
        ],
      ),
      focusColor: Colors.blue,
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return SelectMovieLanguageDialog();
          },
        );
      },
    );
  }

  Scaffold buildPortraitScaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              buildSliverAppBar(context),
              new SliverList(
                delegate: new SliverChildListDelegate(
                  <Widget>[
                    buildDescPhotoContainer(context),
                    Divider(color: Colors.white),
                    buildMovieFlags(),
                    SizedBox(height: 15),
                    buildPlayButton(context),
                    RecommendedContainer(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildMovieFlags() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: orientation == Orientation.portrait
            ? SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.6,
                crossAxisCount: 10,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5)
            : SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.6,
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
        itemCount: movieController.selectedMovie.flags.length,
        itemBuilder: (context, subIndex) {
          return CustomCachedImage(
            imageUrl: movieController.selectedMovie.flags[subIndex],
          );
        },
      ),
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
        title: Text(movieController.selectedMovie.name,
            overflow: TextOverflow.ellipsis,
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
                imageUrl: movieController.selectedMovie.contentImage,
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
                  imageUrl: movieController.selectedMovie.contentImage,
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width / 2.8,
                margin: EdgeInsets.only(left: 16, right: 16.0),
                child: Text(
                  movieController.selectedMovie.desc,
                  maxLines: 15,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

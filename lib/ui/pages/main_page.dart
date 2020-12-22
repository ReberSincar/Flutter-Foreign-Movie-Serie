import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/constants/colors.dart';
import 'package:foreign_movie_watch/controllers/main_controller.dart';
import 'package:foreign_movie_watch/ui/pages/search_page.dart';
import 'package:foreign_movie_watch/ui/pages/series_page.dart';
import 'package:get/get.dart';

import 'movies_page.dart';

class MainPages extends StatefulWidget {
  MainPages({Key key}) : super(key: key);

  @override
  _MainPagesState createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  MainController mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: mainColor,
      appBar: buildAppBar(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                flex: orientation == Orientation.portrait ? 1 : 2,
                child: buildTabBar(),
              ),
              Expanded(
                flex: 20,
                child: PageView(
                  controller: mainController.pageController,
                  onPageChanged: (value) {
                    mainController.selectedIndex.value = value;
                  },
                  children: [
                    SeriesPage(),
                    MoviesPage(),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Obx(
              () => MaterialButton(
                child: Text(
                  "appbar_serie_tab".tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                focusColor: Colors.white.withOpacity(0.2),
                onPressed: () {
                  mainController.selectedIndex.value = 0;
                  mainController.animatePage(0);
                },
                color: mainController.selectedIndex.value == 0
                    ? mainController.selectedColor
                    : mainController.unSelectedColor,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => MaterialButton(
                child: Text(
                  "appbar_movie_tab".tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                focusColor: Colors.white.withOpacity(0.2),
                onPressed: () {
                  mainController.selectedIndex.value = 1;
                  mainController.animatePage(1);
                },
                color: mainController.selectedIndex.value == 1
                    ? mainController.selectedColor
                    : mainController.unSelectedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      title: Text("appbar_title".tr),
      actions: [
        IconButton(
          focusColor: Colors.blue,
          onPressed: () {
            Get.to(SearchPage());
          },
          icon: Icon(Icons.search),
        )
      ],
    );
  }
}

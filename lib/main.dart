import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/pages/main_page.dart';
import 'package:flutter/services.dart';
import 'package:foreign_movie_watch/ads/ironsource_ads.dart';
import 'package:foreign_movie_watch/controllers/episode_controller.dart';
import 'package:foreign_movie_watch/controllers/movie_controller.dart';
import 'dart:ui' as ui;
import 'package:foreign_movie_watch/controllers/search_controller.dart';
import 'localization.dart';
import 'package:foreign_movie_watch/controllers/serie_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(MovieController());
    Get.put(SerieController());
    Get.put(EpisodeController());
    Get.put(SearchController());
    Get.put(IronSourceAdsController());

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: GetMaterialApp(
        title: 'appbar_title'.tr,
        debugShowCheckedModeBanner: false,
        translations: Localization(),
        locale: ui.window.locale,
        fallbackLocale: Locale('en', 'US'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPages(),
      ),
    );
  }
}

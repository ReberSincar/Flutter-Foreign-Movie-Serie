import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/controllers/serie_controller.dart';
import 'package:foreign_movie_watch/ui/widgets/serie_container.dart';
import 'package:get/get.dart';
import 'package:foreign_movie_watch/ui/widgets/custom_circular_progress.dart';

class SeriesPage extends StatefulWidget {
  SeriesPage({key}) : super(key: key);

  @override
  _SeriesPageState createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage>
    with AutomaticKeepAliveClientMixin {
  final SerieController serieController = Get.find();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => serieController.isLoading.value
          ? CustomCircularProgress()
          : serieController.serieList.length == 0
              ? buildNoSerie()
              : buildGridView(),
    );
  }

  OrientationBuilder buildGridView() {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Padding(
          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 3 : 6,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 9 / 13,
            ),
            controller: serieController.scrollController,
            itemCount: serieController.serieList.length,
            itemBuilder: (context, index) {
              return SerieContainer(index: index);
            },
          ),
        );
      },
    );
  }

  Center buildNoSerie() {
    return Center(
      child: Text(
        "series_no_serie".tr,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foreign_movie_watch/controllers/movie_controller.dart';
import 'package:get/get.dart';
import 'package:foreign_movie_watch/ui/widgets/custom_circular_progress.dart';
import 'package:foreign_movie_watch/ui/widgets/movie_container.dart';

class MoviesPage extends StatefulWidget {
  MoviesPage({key}) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>
    with AutomaticKeepAliveClientMixin {
  final MovieController movieController = Get.find();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => movieController.isLoading.value
          ? CustomCircularProgress()
          : movieController.documentList.length == 0
              ? buildNoMovie()
              : buildGridView(),
    );
  }

  Center buildNoMovie() {
    return Center(
      child: Text(
        "movies_no_movie".tr,
        style: TextStyle(color: Colors.white),
      ),
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
            controller: movieController.scrollController,
            itemCount: movieController.documentList.length,
            itemBuilder: (context, index) {
              return MovieContainer(index: index);
            },
          ),
        );
      },
    );
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MainController extends GetxController {
  final selectedIndex = 0.obs;
  PageController pageController;

  final selectedColor = Colors.blue;
  final unSelectedColor = Colors.black;

  @override
  void onInit() {
    pageController = new PageController();
    super.onInit();
  }

  animatePage(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
}

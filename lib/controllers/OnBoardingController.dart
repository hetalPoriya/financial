import 'package:financial/models/OnBoardingModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  var pageController = PageController();
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == sliderValue.sliderData.length - 1;

  forwardAction(){
    if (isLastPage) {
      Get.offNamed('/Login');
    } else {
      pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn);
   }
  }

  OnBoardingPageValue sliderValue = OnBoardingPageValue(
      imageLine1: 'assets/line1.png',
      imageLine2: 'assets/line2.png',
      sliderData: [
        SliderData(
          text: 'Welcome to \n   Finshark',
          description:
          'The game that will make you \na shark in your financial life! ',
          image: 'assets/introScreen1.png',
        ),
        SliderData(
          text: '',
          description:
          'The objective of the game is to optimize your spending so that you can live a good quality of life, while also hitting financial goals like saving up for emergencies, paying off credit cards, and meeting your daily expenses.',
          image: 'assets/introScreen2.png',
        ),
        SliderData(
          text: '',
          description:
          'Keep an eye out on the money you have left, as well as how many Quality of Life points you’re earning. At each level more complexities will be added to your financial life, till you become a pro at balancing all of them!',
          image: 'assets/introScreen3.png',
        ),
      ]);
}
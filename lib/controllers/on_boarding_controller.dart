import 'package:financial/models/OnBoardingModel.dart';
import 'package:financial/utils/AllImages.dart';
import 'package:financial/utils/AllStrings.dart';
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
      imageLine1: AllImages.onBoardingLineOne,
      imageLine2: AllImages.onBoardingLineTwo,
      sliderData: [
        SliderData(
          text: AllStrings.onBoardingSlider1Text,
          description:AllStrings.onBoardingSlider1Des,
          image: AllImages.introScreen1,
        ),
        SliderData(
          text: '',
          description:AllStrings.onBoardingSlider2Des,
          image: AllImages.introScreen2,
        ),
        SliderData(
          text: '',
          description:AllStrings.onBoardingSlider3Des,
          image: AllImages.introScreen3,
        ),
      ]);
}
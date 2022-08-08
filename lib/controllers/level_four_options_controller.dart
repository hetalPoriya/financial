import 'package:financial/models/level_four_options_model.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelFourOptionsController extends GetxController {
  var pageController = PageController();
  var levelFourIndex = 0.obs;
  var optionsIndex = 0.0.obs;

  bool get isLastPage => levelFourIndex.value == bills.length - 1;

  forwardFunction() {
    pageController.nextPage(
        duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  List<LevelFourOptions> bills = [
    LevelFourOptions(
        text: AllStrings.level4step1Text,
        step: AllStrings.level4Step1,
        options1: AllStrings.level4step1Option1,
        options2: AllStrings.level4step1Option2,
        options3: AllStrings.level4step1Option3,
        options4: AllStrings.level4step1Option4,
        options5: AllStrings.level4step1Option5,
        //isSelectedButton: 0,
        isSelectedOption: 0,
        optionsValue: [
          OptionsValue(
              description: AllStrings.level4step1Option1Des,
              rent: 200,
              //emi: 100,
              image: AllImages.level4Step1Image1,
              bottomText: AllStrings.level4step1Option1BottomText),
          OptionsValue(
              description: AllStrings.level4step1Option2Des,
              rent: 300,
              image: AllImages.level4Step1Image2,
              bottomText: AllStrings.level4step1Option2BottomText),
          OptionsValue(
              description: AllStrings.level4step1Option3Des,
              rent: 500,
              image: AllImages.level4Step1Image3,
              bottomText: AllStrings.level4step1Option3BottomText),
          OptionsValue(
              description: AllStrings.level4step1Option4Des,
              rent: 400,
              image: AllImages.level4Step1Image4,
              bottomText: AllStrings.level4step1Option4BottomText),
          OptionsValue(
              description: AllStrings.level4step1Option5Des,
              rent: 300,
              image: AllImages.level4Step1Image5,
              bottomText: AllStrings.level4step1Option5BottomText)
        ]),
    LevelFourOptions(
        step: AllStrings.level4Step2,
        text: AllStrings.level4step2Text,
        options1: AllStrings.level4step2Option1,
        options2: AllStrings.level4step2Option2,
        options3: AllStrings.level4step2Option3,
        //options4: 'New \nSUV car ',
        // isSelectedButton: 0,
        isSelectedOption: 0,
        optionsValue: [
          OptionsValue(
              description: AllStrings.level4step2Option1Des,
              rent: 200,
              image: AllImages.level4Step2Image1,
              bottomText: AllStrings.level4step2Option1BottomText),
          OptionsValue(
              description: AllStrings.level4step2Option2Des,
              rent: 350,
              image: AllImages.level4Step2Image2,
              bottomText: AllStrings.level4step2Option2BottomText),
          OptionsValue(
              description: AllStrings.level4step2Option3Des,
              rent: 500,
              image: AllImages.level4Step2Image3,
              bottomText: AllStrings.level4step2Option3BottomText),
          // OptionsValue(
          //     description:
          //     'This brand new vehicle has no prior owner. The car is in mint condition and has premium features and options, such as power windows, four-wheel drive, keyless entry and sunroof.',
          //     rent: 550,
          //     image: 'assets/luxuryHouse.png')
        ]),
    LevelFourOptions(
        text: AllStrings.level4step3Text,
        step: AllStrings.level4Step3,
        options1: AllStrings.level4step3Option1,
        options2: AllStrings.level4step3Option2,
        options3: AllStrings.level4step3Option3,
        //isSelectedButton: 0,
        isSelectedOption: 0,
        optionsValue: [
          OptionsValue(
              description: AllStrings.level4step3Option1Des,
              rent: 300,
              image: AllImages.level4Step3Image1,
              bottomText: ''
              // 'Tip: Distance from amenities & work will impact your monthly transport expense'
              ),
          OptionsValue(
              description: AllStrings.level4step3Option2Des,
              rent: 400,
              image: AllImages.level4Step3Image2,
              bottomText: ''
              // 'Tip: Distance from amenities & work will impact your monthly transport expense'
              ),
          OptionsValue(
              description: AllStrings.level4step3Option3Des,
              rent: 600,
              image: AllImages.level4Step3Image3,
              bottomText: ''
              // 'Tip: Distance from amenities & work will impact your monthly transport expense'
              )
        ]),
  ];
}

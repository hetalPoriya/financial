import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/views/LevelFourAndFiveOptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelFiveSetUpPage extends StatelessWidget {
   LevelFiveSetUpPage({Key? key}) : super(key: key);
  String text1 = '';
  String text2 = '';
  String text3 = '';
  @override
  Widget build(BuildContext context) {
    return SetUpPage(
        level: 'Level 5',
        levelText: 'Stock Play',
        buttonText: 'Let\'s Go',
        container: Container(),
        onPressed: () async {
          Get.off(
            () => LevelFourAndFiveOptions(),
            duration: Duration(milliseconds: 250),
            transition: Transition.downToUp,
          );
        });
  }
}

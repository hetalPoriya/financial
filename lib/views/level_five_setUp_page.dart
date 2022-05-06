
import 'package:financial/shareable_screens/setUp_page.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/views/level_four_and_five_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shareable_screens/globle_variable.dart';

class LevelFiveSetUpPage extends StatefulWidget {
  LevelFiveSetUpPage({Key? key}) : super(key: key);

  @override
  State<LevelFiveSetUpPage> createState() => _LevelFiveSetUpPageState();
}

class _LevelFiveSetUpPageState extends State<LevelFiveSetUpPage> {
   String text1 = '';
   String text2 = '';
   String text3 = '';
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SetUpPage(
      color: color,
        level: 'Level 5',
        levelText: AllStrings.level5,
        buttonText: AllStrings.letsGo,
        container: Container(),
        onPressed: () async {
        setState(() {
          color = AllColors.green;
        });
          Get.off(
            () => LevelFourAndFiveOptions(),
            duration: Duration(seconds: 1),
            transition: Transition.downToUp,
          );
        });
  }
}

import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/setUp_page.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:flutter/material.dart';

class LevelSixSetUpPage extends StatefulWidget {
  const LevelSixSetUpPage({Key? key}) : super(key: key);

  @override
  State<LevelSixSetUpPage> createState() => _LevelSixSetUpPageState();
}

class _LevelSixSetUpPageState extends State<LevelSixSetUpPage> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SetUpPage(
        color: color,
        level: 'Level 6',
        levelText: AllStrings.level6,
        buttonText: AllStrings.letsGo,
        container: Container(),
        onPressed: () {
          setState(() {
            color = AllColors.green;
          });
        });
  }
}

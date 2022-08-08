
import 'package:flutter/material.dart';

import '../../cutom_screens/custom_screens.dart';
import '../../utils/utils.dart';

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

import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:flutter/material.dart';

class LevelSixSetUpPage extends StatelessWidget {
  const LevelSixSetUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SetUpPage(
        level: 'Level 6',
        levelText: 'Super Sprint',
        buttonText: 'Let\'s Go',
        container: Container(),
        onPressed: () {});
  }
}

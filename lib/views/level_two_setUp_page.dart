import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/setUp_page.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/level_two_and_three_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LevelTwoSetUpPage extends StatefulWidget {
  LevelTwoSetUpPage({Key? key}) : super(key: key);

  @override
  State<LevelTwoSetUpPage> createState() => _LevelTwoSetUpPageState();
}

class _LevelTwoSetUpPageState extends State<LevelTwoSetUpPage> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SetUpPage(
        level: 'Level 2',
        color: color,
        levelText: AllStrings.level2,
        buttonText: AllStrings.letsGo,
        container: Container(
          child: Padding(
            padding: EdgeInsets.only(right: 04.w, left: 04.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Expanded(
                    child: Container(
                  //color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(
                    AllStrings.levelTwoText1,
                    textAlign: TextAlign.center,
                    style: AllTextStyles.workSansMedium(),
                  ),
                )),
                Expanded(
                    child: Container(
                  //color: Colors.green,
                  alignment: Alignment.center,
                  child: Text(
                    AllStrings.levelTwoText2,
                    textAlign: TextAlign.center,
                    style: AllTextStyles.workSansSmall(
                        fontWeight: FontWeight.w400),
                  ),
                )),
                Expanded(
                    child: Container(
                  //color: Colors.yellow,
                  alignment: Alignment.center,
                  child: Text(AllStrings.levelTwoText3,
                      textAlign: TextAlign.center,
                      style: AllTextStyles.workSansSmall(
                          fontWeight: FontWeight.w400)),
                )),
                Expanded(
                    child: Container(
                  //color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text(AllStrings.levelTwoText4,
                      textAlign: TextAlign.center,
                      style: AllTextStyles.workSansSmall(
                          fontWeight: FontWeight.w500)),
                )),
                Spacer(),
              ],
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            color = AllColors.green;
          });
          Get.off(
            () => LevelTwoAndThreeOptions(),
            duration: Duration(seconds: 1),
            transition: Transition.downToUp,
          );
        });
  }
}

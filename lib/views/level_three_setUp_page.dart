
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/setUp_page.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/level_two_and_three_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LevelThreeSetUpPage extends StatefulWidget {
  LevelThreeSetUpPage({Key? key}) : super(key: key);

  @override
  State<LevelThreeSetUpPage> createState() => _LevelThreeSetUpPageState();
}

class _LevelThreeSetUpPageState extends State<LevelThreeSetUpPage> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SetUpPage(
      color: color,
      level: 'Level 3',
      levelText: AllStrings.level3,
      buttonText: 'Let’s Go',
      container: Container(
        child: Padding(
          padding: EdgeInsets.only(right: 04.w, left: 04.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Text(
                  AllStrings.congratulations,
                textAlign: TextAlign.center,
                style: AllTextStyles.workSansMedium()
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    //color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(
                      AllStrings.levelThreeText1,
                      textAlign: TextAlign.center,
                      style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w500,fontSize: 13.sp)
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.green,
                    alignment: Alignment.center,
                    child: Text(
                        AllStrings.levelThreeText2,
                      textAlign: TextAlign.center,
                      style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w400,fontSize: 12.sp)
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    //color: Colors.yellow,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(right: 6.w, left: 6.w),
                      child: Text(
                          AllStrings.levelThreeText3,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w500,fontSize: 13.sp)
                      ),
                    ),
                  )),
              Expanded(
                  child: Container(
                      //color: Colors.red,
                      )),
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
      },
    );

  }
}

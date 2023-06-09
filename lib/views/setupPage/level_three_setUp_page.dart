
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../cutom_screens/custom_screens.dart';
import '../../utils/utils.dart';
import 'setup_page.dart';

class LevelThreeSetUpPage extends StatefulWidget {
  LevelThreeSetUpPage({Key? key}) : super(key: key);

  @override
  State<LevelThreeSetUpPage> createState() => _LevelThreeSetUpPageState();
}

class _LevelThreeSetUpPageState extends State<LevelThreeSetUpPage> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SetUpPage(
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
                Text(AllStrings.congratulations,
                    textAlign: TextAlign.center,
                    style: AllTextStyles.workSansMedium()),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      //color: Colors.red,
                      alignment: Alignment.center,
                      child: Text(AllStrings.levelThreeText1,
                          textAlign: TextAlign.center,
                          style: AllTextStyles.workSansSmallBlack(
                          ).copyWith( fontWeight: FontWeight.w500, fontSize: 13.sp)),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.green,
                      alignment: Alignment.center,
                      child: Text(AllStrings.levelThreeText2,
                          textAlign: TextAlign.center,
                          style: AllTextStyles.workSansSmallBlack(
                             ).copyWith( fontWeight: FontWeight.w400, fontSize: 12.sp)),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      //color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(right: 6.w, left: 6.w),
                        child: Text(AllStrings.levelThreeText3,
                            textAlign: TextAlign.center,
                            style: AllTextStyles.workSansSmallBlack(
                              ).copyWith(  fontWeight: FontWeight.w500, fontSize: 13.sp)),
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
          Get.offAll(
            () => LevelTwoAndThreeOptions(),
            duration: Duration(seconds: 1),
            transition: Transition.downToUp,
          );
        },
      ),
    );
  }
}


import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/LevelTwoAndThreeOptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LevelTwoSetUpPage extends StatelessWidget {
  LevelTwoSetUpPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return SetUpPage(level: 'Level 2',
        levelText:AllStrings.level2,
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
                        style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w400),
                      ),
                    )),
                Expanded(

                    child: Container(
                      //color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Text(
                          AllStrings.levelTwoText3,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w400)
                      ),
                    )),
                Expanded(
                    child: Container(
                      //color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                          AllStrings.levelTwoText4,
                        textAlign: TextAlign.center,
                        style:AllTextStyles.workSansSmall(fontWeight: FontWeight.w500)
                      ),
                    )),
                Spacer(),
              ],
            ),
          ),
        ),
        onPressed: ()async{
          Get.off(
                () => LevelTwoAndThreeOptions(),
            duration: Duration(milliseconds: 250),
            transition: Transition.downToUp,
          );
        });
  }
}

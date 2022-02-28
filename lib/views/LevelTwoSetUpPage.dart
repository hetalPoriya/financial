
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/views/LevelTwoAndThreeOptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class LevelTwoSetUpPage extends StatelessWidget {
  LevelTwoSetUpPage({Key? key}) : super(key: key);

  String text1 = ' Let\'s test your budgeting skills!';
  String text2 = 'You\'ve just taken up a new job and moved to a new city.';
  String text3 =
      'Your goal is to save 20% of your income while paying all your basic expenses';
  String text4 = 'Go to next screen to set up your basic expenses.';

  @override
  Widget build(BuildContext context) {
    return SetUpPage(level: 'Level 2',
        levelText: 'Smart Saver',
        buttonText: 'Let\'s Go',
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
                        text1,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.workSans(
                          color: Color(0xff6448E8),
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 17.sp,
                        ),
                      ),
                    )),
                Expanded(
                    child: Container(
                      //color: Colors.green,
                      alignment: Alignment.center,
                      child: Text(
                        text2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.workSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0.sp),
                      ),
                    )),
                Expanded(

                    child: Container(
                      //color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Text(
                        text3,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0.sp,
                        ),
                      ),
                    )),
                Expanded(
                    child: Container(
                      //color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        text4,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
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


import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/views/AllQueLevelOne.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class LevelOneSetUpPage extends StatelessWidget {
  LevelOneSetUpPage({Key? key,}) : super(key: key);

  var userId;
  final getData = GetStorage();
  String text1 = ' Do you think you are smart with your money?';
  String text2 = 'Let\'s test you';
  String text3 =
      'It\'s your birthday week and your generous Aunt has gifted you \$200!';
  String text4 = 'Let\'s see how smartly you spend it.';

  @override
  Widget build(BuildContext context) {
    return SetUpPage(
      level: 'Level 1',
      levelText: 'Smart Money',
      container: Container(
        child: Padding(
          padding: EdgeInsets.only(right: 04.w, left: 04.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 6.h,
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.red,
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
                  flex: 1,
                  child: Container(
                    // color: Colors.green,
                    alignment: Alignment.center,
                    child: Text(
                      text2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0.sp),
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    // color: Colors.yellow,
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
                  flex: 2,
                  child: Container(
                    // color: Colors.red,
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
              Spacer(),
            ],
          ),
        ),
      ),
      onPressed: () async {
        var storeValue = GetStorage();
        userId =  storeValue.read('uId');
        storeValue.write('update', 0);
        firestore.collection('User').doc(userId).get().then((doc) {
          bool value = doc.get('replay_level');
          firestore.collection('User').doc(userId).update({
            'account_balance': 200,
            'need': 0,
            'want': 0,
            'quality_of_life': 0,
            'level_id': 0,
            'level_1_id': 0,
            'previous_session_info': 'Level_1',
            if (value != true) 'last_level': 'Level_1',
          }).then((value) {
            storeValue.write('tBalance', 0);
            storeValue.write('tQol', 0);
            storeValue.write('tInvestment', 0);
            storeValue.write('tCredit', 0);
            storeValue.write('tUser', 0);
            getUser(1).then((value) =>  Get.off(
                  () => AllQueLevelOne(),
              duration: Duration(milliseconds: 250),
              transition: Transition.downToUp,
            ));
          });
        });
      },
      buttonText: 'Start Spending',
    );

  }
}

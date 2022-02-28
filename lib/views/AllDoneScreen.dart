
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class AllDone extends StatelessWidget {
  AllDone({
    Key? key,
  }) : super(key: key);

  //get user id
  var userId;
  int gameScore = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
            ),
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: boxDecoration,
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    child: Image.asset(
                      'assets/done.png',
                      height: 40.h,
                      width: 100.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'Yey! All done',
                    style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 28.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    'You can start playing now.',
                    style: GoogleFonts.workSans(
                      color: Color(0xffE7E7E7),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 8.h,
                    width: 75.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.w)),
                    child: TextButton(
                      onPressed: () {
                        getUserData();
                      },
                      child: GradientText(
                          text: 'let\'s go',
                          style: GoogleFonts.workSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          gradient: const LinearGradient(
                              colors: [Colors.white, Color(0xff6448E8)],
                              transform: GradientRotation(math.pi / 2))),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            )),
      ),
    );
  }

  getUserData() async {
    var storeValue = GetStorage();
    userId = storeValue.read('uId');
    storeValue.write('update', 0);
    storeValue.write('tBalance', 0);
    storeValue.write('tQol', 0);
    storeValue.write('tInvestment', 0);
    storeValue.write('tCredit', 0);
    storeValue.write('tUser', 0);

    String level;
    bool replayLevel;
    firestore
        .collection('User')
        .doc(userId)
        .get()
        .then((doc) => {
              level = doc.get("previous_session_info"),
              gameScore = doc.get("game_score"),
              replayLevel = doc.get("replay_level"),
              if (level == 'Level_2_setUp_page'){
                  firestore
                      .collection('User')
                      .doc(userId)
                      .update({
                    'bill_payment': globalVar,
                    'game_score' : gameScore,
                    'previous_session_info': 'Level_2',
                    if (replayLevel != true) 'last_level': 'Level_2',
                    'account_balance': 0,
                    'quality_of_life': 0,
                    'level_id': 0,
                    'need': 0,
                    'want': 0,
                    'level_2_id': 0,
                  }),
                  getUser(2).then((value) => Get.offNamed('/Level2')),
                },
              if (level == 'Level_3_setUp_page'){
                  firestore
                      .collection('User')
                      .doc(userId)
                      .update({
                    'bill_payment': globalVar,
                    'credit_card_bill': 0,
                    'previous_session_info': 'Level_3',
                    if (replayLevel != true) 'last_level': 'Level_3',
                    'game_score': gameScore,
                    'credit_card_balance': 2000,
                    'account_balance': 0,
                    'level_id': 0,
                    'credit_score': 350,
                    'quality_of_life': 0,
                    'payable_bill': 0,
                    'score': 350,
                    'need': 0,
                    'want': 0,
                    'level_3_id': 0,
                  }),
                getUser(3).then((value) => Get.offNamed('/Level3')),
                }
            });
  }
}

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class AllDone extends StatefulWidget {
  AllDone({
    Key? key,
  }) : super(key: key);

  @override
  State<AllDone> createState() => _AllDoneState();
}

class _AllDoneState extends State<AllDone> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(AllStrings.tapBack),
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
                      AllImages.done,
                      height: 40.h,
                      width: 100.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    AllStrings.allDoneText1,
                    style: AllTextStyles.dialogStyleExtraLarge(size: 28.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    AllStrings.allDoneText2,
                    style: AllTextStyles.dialogStyleMedium(
                        fontWeight: FontWeight.w400,
                        color: AllColors.whiteLight),
                  ),
                  Spacer(),
                  Container(
                    height: 8.h,
                    width: 75.w,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12.w)),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          color = AllColors.green;
                        });
                        getUserData();
                      },
                      child: GradientText(
                          text: AllStrings.letsGo,
                          style: AllTextStyles.dialogStyleLarge(
                              size: 16.sp, fontWeight: FontWeight.w700),
                          gradient: LinearGradient(
                              colors: color == AllColors.green
                                  ? [Colors.white, Colors.white]
                                  : [Colors.white, AllColors.purple],
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
    firestore.collection('User').doc(userId).get().then((doc) => {
          level = doc.get("previous_session_info"),
          gameScore = doc.get("game_score"),
          replayLevel = doc.get("replay_level"),
          if (level == 'Level_2_setUp_page')
            {
              firestore.collection('User').doc(userId).update({
                'bill_payment': globalVar,
                'game_score': gameScore,
                'previous_session_info': 'Level_2',
                if (replayLevel != true) 'last_level': 'Level_2',
                'account_balance': 0,
                'quality_of_life': 0,
                'level_id': 0,
                'need': 0,
                'want': 0,
                'level_2_id': 0,
                'level_2_qol': 0,
                'level_2_balance': 0,
              }),
              getUser(levelId: 2).then((value) => Get.offNamed('/Level2')),
            },
          if (level == 'Level_3_setUp_page')
            {
              firestore.collection('User').doc(userId).update({
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
                'level_3_creditScore': 350,
                'level_3_qol': 0,
                'level_3_balance': 0,
              }),
              getUser(levelId: 3).then((value) => Get.offNamed('/Level3')),
            }
        });
  }
}

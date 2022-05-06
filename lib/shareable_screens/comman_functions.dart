import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/coming_soon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

//button style for restart level or (creditbalance or debitbalance not enough) ok button
Widget restartOrOkButton(String text, VoidCallback onPressed,
    [Alignment? alignment]) =>
    Padding(
      padding: EdgeInsets.all(6.0),
      child: Align(
        alignment: alignment == null ? Alignment.centerRight : alignment,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w)))),
            child: Padding(
              padding: EdgeInsets.all(1.w),
              child: Text(text,
                  style: AllTextStyles.dialogStyleSmall(
                      color: AllColors.darkPurple,
                      fontWeight: FontWeight.normal)),
            )),
      ),
    );


level5BillPayment(Widget widget, String image) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Image.asset(image,
                height: 4.h, width: 10.w, fit: BoxFit.contain),
          ),
        ),
        Container(
          child: widget,
        ),
      ],
    ),
  );
}

Future<void> getUser(int levelId) async {
  int countForUser = 0;

  int accountBalanceForUser = 0;
  int totalBalanceForUser = 0;

  int creditScoreForUser = 0;
  int totalCreditForUser = 0;

  int qolForUser = 0;
  int totalQolForUser = 0;

  int investmentForUser = 0;
  int totalInvestmentForUser = 0;

  String level = '';
  var storeValue = GetStorage();
  var userId;

  userId = storeValue.read('uId');
  QuerySnapshot snap = await firestore.collection('User').get();
  DocumentSnapshot documentSnapshot;

  documentSnapshot = await firestore.collection('User').doc(userId).get();
  level = documentSnapshot.get('previous_session_info');

  // QuerySnapshot<Map<String, dynamic>>? l1 =
  //     await firestore.collection('Level_1').get();
  // QuerySnapshot<Map<String, dynamic>>? l2 =
  //     await firestore.collection('Level_2').get();
  // QuerySnapshot<Map<String, dynamic>>? l3 =
  //     await firestore.collection('Level_3').get();
  // QuerySnapshot<Map<String, dynamic>>? l4 =
  //     await firestore.collection('Level_4').get();
  // QuerySnapshot<Map<String, dynamic>>? l5 =
  //     await firestore.collection('Level_5').get();

  snap.docs.forEach((document) async {
    documentSnapshot =
        await firestore.collection('User').doc(document.id).get();
    //levelForUser = documentSnapshot.get('previous_session_info');
    if ((documentSnapshot.data() as Map<String, dynamic>)
        .containsKey("level_1_balance")) {
      if (documentSnapshot.get('level_$levelId\_balance') != 0 &&
          document.id != userId) {
        countForUser = countForUser + 1;
        accountBalanceForUser = documentSnapshot.get('level_$levelId\_balance');
        qolForUser = documentSnapshot.get('level_$levelId\_qol');

        totalBalanceForUser = totalBalanceForUser + accountBalanceForUser;
        totalQolForUser = totalQolForUser + qolForUser;

        if (level == 'Level_3') {
          creditScoreForUser =
              documentSnapshot.get('level_$levelId\_creditScore');
          totalCreditForUser = totalCreditForUser + creditScoreForUser;
        }

        if (level == 'Level_4' || level == 'Level_5') {
          investmentForUser =
              documentSnapshot.get('level_$levelId\_investment');
          totalInvestmentForUser = totalInvestmentForUser + investmentForUser;
        }
      }

      storeValue.write('tBalance', totalBalanceForUser);
      storeValue.write('tQol', totalQolForUser);
      storeValue.write('tInvestment', totalInvestmentForUser);
      storeValue.write('tCredit', totalCreditForUser);
      storeValue.write('tUser', countForUser);
    }
  });
}

calculationForProgress(VoidCallback onPressed) async {
  int abPer = 0;
  int qolPer = 0;
  int creditPer = 0;
  int investmentper = 0;
  String level = '';
  int qol = 0;
  int accountBalance = 0;
  int creditScore = 0;
  int investment = 0;
  var storeValue = GetStorage();

  var userId = storeValue.read('uId');
  int totalBalanceForUser = storeValue.read('tBalance');
  int totalQolForUser = storeValue.read('tQol');
  int totalInvestmentForUser = storeValue.read('tInvestment');
  int totalCreditForUser = storeValue.read('tCredit');
  int countForUser = storeValue.read('tUser');

  DocumentSnapshot documentSnapshot =
      await firestore.collection('User').doc(userId).get();

  level = documentSnapshot.get('previous_session_info');
  accountBalance = documentSnapshot.get('account_balance');
  qol = documentSnapshot.get('quality_of_life');
  creditScore = documentSnapshot.get('credit_score');
  investment = documentSnapshot.get('investment');

  totalBalanceForUser = (totalBalanceForUser / countForUser).round();

  totalQolForUser = (totalQolForUser / countForUser).round();
  totalCreditForUser = (totalCreditForUser / countForUser).round();
  totalInvestmentForUser = (totalInvestmentForUser / countForUser).round();

  abPer = accountBalance - totalBalanceForUser;

  totalBalanceForUser == 0
      ? abPer = 0
      : abPer = ((abPer / totalBalanceForUser) * 100).floor();

  qolPer = qol - totalQolForUser;
  totalQolForUser == 0
      ? qolPer = 0
      : qolPer = ((qolPer / totalQolForUser) * 100).floor();

  if (level == 'Level_3') {
    creditPer = creditScore - totalCreditForUser;
    totalCreditForUser == 0
        ? creditPer = 0
        : creditPer = ((creditPer / totalCreditForUser) * 100).floor();
  }
  if (level == 'Level_4' || level == 'Level_5') {
    investmentper = investment - totalInvestmentForUser;
    totalInvestmentForUser == 0
        ? investmentper = 0
        : investmentper =
            ((investmentper / totalInvestmentForUser) * 100).floor();
  }

  savingAndQolDialog(abPer, qolPer, creditPer, investmentper, level, onPressed);
}

savingDialogText(String text1, String text2, String text3, Color color) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: RichText(
                text: TextSpan(
                    text: text1,
                    style: AllTextStyles.dialogStyleMedium(
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: text2,
                        style: AllTextStyles.dialogStyleMedium(
                            fontWeight: FontWeight.w500, color: color),
                      ),
                      TextSpan(
                        text: text3,
                        style: AllTextStyles.dialogStyleMedium(
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );

savingAndQolDialog(int abPer, int qolPer, int creditPer, int investmentPer,
    String levelForUser, VoidCallback onPressed) {
  String level = levelForUser.substring(6, 7);
  int lev = int.parse(level);

  Get.defaultDialog(
    title: 'Level $lev Progress',
    titlePadding: EdgeInsets.only(top: 2.h, bottom: 1.h),
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: AllColors.darkBlue2,
    titleStyle: AllTextStyles.dialogStyleLarge(
        size: 16.sp, fontWeight: FontWeight.w600),
    content: Padding(
      padding: EdgeInsets.only(right: 3.w, left: 3.w),
      child: Column(
        children: [
          Text(AllStrings.levelProgressTitle,
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
          SizedBox(
            height: 1.h,
          ),
          // Text(
          //     abPer > 0
          //         ? 'Your savings are ${abPer.abs()}% higher than other players. '
          //         : abPer < 0
          //             ? 'Your savings are ${abPer.abs()}% lower than other players. '
          //             : 'Your savings are ${abPer.abs()}% same as other players. ',
          //     style: GoogleFonts.workSans(
          //       fontSize: 14.sp,
          //       color: Colors.white,
          //       fontWeight: FontWeight.w500,
          //     ),
          //     textAlign: TextAlign.center),
          if (levelForUser == 'Level_1' ||
              levelForUser == 'Level_2' ||
              levelForUser == 'Level_3' ||
              levelForUser == 'Level_4' ||
              levelForUser == 'Level_5')
            abPer > 0
                ? savingDialogText(
                    AllStrings.savingsAre,
                    '${abPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : abPer < 0
                    ? savingDialogText(
                        AllStrings.savingsAre,
                        '${abPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : abPer == 0
                        ? savingDialogText('Your savings is ', 'the same ',
                            AllStrings.asOthers, AllColors.white24)
                        : null,
          //
          // SizedBox(
          //   height: 1.h,
          // ),

          if (levelForUser == 'Level_1' ||
              levelForUser == 'Level_2' ||
              levelForUser == 'Level_3' ||
              levelForUser == 'Level_4' ||
              levelForUser == 'Level_5')
            qolPer > 0
                ? savingDialogText(
                    AllStrings.lifestyleIs,
                    '${qolPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : qolPer < 0
                    ? savingDialogText(
                        AllStrings.lifestyleIs,
                        '${qolPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : qolPer == 0
                        ? savingDialogText(AllStrings.lifestyleIs, 'the same ',
                            AllStrings.asOthers, AllColors.white24)
                        : null,

          // if (levelForUser == 'Level_3')
          //   SizedBox(
          //     height: 1.h,
          //   ),

          if (levelForUser == 'Level_3')
            creditPer > 0
                ? savingDialogText(
                    AllStrings.creditScoreIs,
                    '${creditPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : creditPer < 0
                    ? savingDialogText(
                        AllStrings.creditScoreIs,
                        '${creditPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : creditPer == 0
                        ? savingDialogText(AllStrings.creditScoreIs,
                            'the same ', AllStrings.asOthers, AllColors.white24)
                        : null,

          // if (levelForUser == 'Level_4' || levelForUser == 'Level_5')
          //   SizedBox(
          //     height: 1.h,
          //   ),

          if (levelForUser == 'Level_4' || levelForUser == 'Level_5')
            investmentPer > 0
                ? savingDialogText(
                    AllStrings.investmentIs,
                    '${investmentPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : investmentPer < 0
                    ? savingDialogText(
                        AllStrings.investmentIs,
                        '${investmentPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : investmentPer == 0
                        ? savingDialogText(AllStrings.investmentIs, 'the same ',
                            AllStrings.asOthers, AllColors.white24)
                        : null,
        ],
      ),
    ),
    confirm: restartOrOkButton('Keep Going', onPressed, Alignment.center),
  );
}

showDialogToShowIncreaseRent() {
  final storeValue = GetStorage();
  var userId = storeValue.read('uId');
  rentPrice = storeValue.read('rentPrice')!;
  transportPrice = storeValue.read('transportPrice')!;
  lifestylePrice = storeValue.read('lifestylePrice')!;

  rentPrice = rentPrice + ((rentPrice * 5) ~/ 100).toInt();
  transportPrice = transportPrice + ((transportPrice * 5) ~/ 100).toInt();
  lifestylePrice = lifestylePrice + ((lifestylePrice * 5) ~/ 100).toInt();

  storeValue.write('rentPrice', rentPrice);
  storeValue.write('transportPrice', transportPrice);
  storeValue.write('lifestylePrice', lifestylePrice);

  firestore
      .collection('User')
      .doc(userId)
      .update({'bill_payment': (rentPrice + transportPrice + lifestylePrice)});

  return Get.defaultDialog(
    title: 'Alert!',
    titlePadding: EdgeInsets.only(top: 2.w, bottom: 2.w),
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: AllColors.darkPurple,
    titleStyle: AllTextStyles.dialogStyleLarge(
        size: 16.sp, fontWeight: FontWeight.w800),
    content: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 1.w,
            right: 1.w,
            bottom: 4.w,
          ),
          child: Text(
            'Due to inflation, rent, transport and other prices have gone up by 5% over the last year. Your revised monthly expenses this year will be: ',
            textAlign: TextAlign.center,
            style: AllTextStyles.dialogStyleMedium(),
          ),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Home Rent ',
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '\$' + rentPrice.toString(),
                  style: AllTextStyles.dialogStyleMedium(
                    fontWeight: FontWeight.w500,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Transport ',
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '\$' + transportPrice.toString(),
                  style: AllTextStyles.dialogStyleMedium(
                    fontWeight: FontWeight.w500,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Lifestyle ',
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '\$' + lifestylePrice.toString(),
                  style: AllTextStyles.dialogStyleMedium(
                    fontWeight: FontWeight.w500,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
      ],
    ),
    confirm: restartOrOkButton(
      'Ok',
      () {
        Get.back();
      },
    ),
  );
}

popQuizDialog(
  VoidCallback onPlayPopQuizPressed,
  VoidCallback onPlayNextLevelPressed,
) {
  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    title:
        'Congrats! You’ve managed to achieve your savings goal! Mission accomplished!',
    titleStyle: AllTextStyles.workSansSmall(fontWeight: FontWeight.w500),
    titlePadding: EdgeInsets.all(2.w),

    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50.w,
          height: 5.h,
          child: ElevatedButton(
            onPressed: onPlayPopQuizPressed,
            child: Text(
              AllStrings.playPopQuiz,
              style: AllTextStyles.dialogStyleSmall(size: 13.sp),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AllColors.lightBlue2,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          width: 50.w,
          height: 5.h,
          child: ElevatedButton(
            onPressed: onPlayNextLevelPressed,
            child: Text(
              AllStrings.playNextLevel,
              style: AllTextStyles.dialogStyleSmall(size: 13.sp),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AllColors.lightBlue2,
              ),
            ),
          ),
        )
      ],
    ),
    contentPadding: EdgeInsets.all(4.w),
    // radius: 12.w,
  );
}

inviteDialog() async {
  var userId = GetStorage().read('uId');
  DocumentSnapshot snap = await firestore.collection('User').doc(userId).get();
  bool value = snap.get('replay_level');
  String level = snap.get('last_level');
  level = level.toString().substring(6, 7);
  int lev = int.parse(level);
  if (lev == 2 && value == true) {
    firestore.collection('User').doc(userId).update({'replay_level': false});
  }

  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    title: AllStrings.shareAppText,
    titleStyle: AllTextStyles.dialogStyleMedium(),
    backgroundColor: AllColors.darkPurple,
    titlePadding: EdgeInsets.all(4.w),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: ElevatedButton(
              onPressed: () async {
                //bool value = documentSnapshot.get('replay_level');
                // level = documentSnapshot.get('last_level');
                // int myBal = documentSnapshot.get('account_balance');
                // level = level.toString().substring(6, 7);
                // int lev = int.parse(level);
                // if (value == true) {
                //   Future.delayed(
                //       Duration(seconds: 1),
                //       () => showDialogForReplay(lev, userId),);
                // } else {
                FlutterShare.share(
                        title: 'https://finshark.page.link/finshark',
                        text: AllStrings.shareAppDesText,
                        linkUrl: 'https://finshark.page.link/finshark',
                        chooserTitle: 'https://finshark.page.link/finshark')
                    .then((value) {
                  // Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelThreeSetUpPage(controller: PageController()))));
                }).then((value) async {
                  Get.back();
                  FirebaseFirestore.instance
                      .collection('User')
                      .doc(userId)
                      .update({
                    //'previous_session_info': 'Level_5_setUp_page',
                    if (value != true) 'last_level': 'Level_5_setUp_page',
                    'previous_session_info': 'Coming_soon',
                    //if (value != true) 'last_level': 'Level_5_setUp_page',
                  });

                  Get.offAll(
                    () => ComingSoon(),
                    duration: Duration(milliseconds: 500),
                    transition: Transition.downToUp,
                  );
                  // Get.off(
                  //   () => LevelFiveSetUpPage(),
                  //   duration: Duration(milliseconds: 500),
                  //   transition: Transition.downToUp,
                  // );
                });
                // }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: Text(
                AllStrings.invite,
                style: AllTextStyles.dialogStyleSmall(
                  size: 13.sp,
                  color: AllColors.darkPurple,
                ),
              )),
          width: 51.w,
          height: 5.h,
        ),
        GestureDetector(
          child: Text(
            'Skip',
            style: GoogleFonts.workSans(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () {
            Get.back();
            var userId = GetStorage().read('uId');
            FirebaseFirestore.instance.collection('User').doc(userId).update({
              //'previous_session_info': 'Level_5_setUp_page',
              if (value != true) 'last_level': 'Level_5_setUp_page',
              'previous_session_info': 'Coming_soon',
              //if (value != true) 'last_level': 'Level_5_setUp_page',
            });
            Get.offAll(
              () => ComingSoon(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
            );
          },
        ),
      ],
    ),
    contentPadding: EdgeInsets.all(2.w),
    // radius: 12.w,
  );
}

restartLevelDialog(VoidCallback onPressed) {
  return Get.defaultDialog(
    title: '',
    titlePadding: EdgeInsets.zero,
    middleText: AllStrings.restartLevelText,
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: AllColors.darkPurple,
    middleTextStyle: AllTextStyles.dialogStyleMedium(),
    confirm: restartOrOkButton('Restart level', onPressed),
  );
}

richText(String text1, String text2, double paddingTop,
        [double? paddingLeft, double? paddingRight, TextAlign? textAlign]) =>
    Padding(
      padding: EdgeInsets.only(
          top: paddingTop,
          left: paddingLeft == null ? 0.0 : paddingLeft,
          right: paddingRight == null ? 0.0 : paddingRight),
      child: Center(
        child: RichText(
          textAlign: textAlign == null ? TextAlign.left : textAlign,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: text1,
              style: AllTextStyles.dialogStyleLarge(size: 16.sp),
              children: [
                TextSpan(
                  text: text2,
                  style: AllTextStyles.dialogStyleLarge(
                    size: 16.sp,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
      ),
    );

normalText(String text, [double? fontSize, FontWeight? fontWeight]) => Padding(
      padding: EdgeInsets.only(top: 3.h, left: 3.w, right: 3.w),
      child: Text(
        text,
        style: AllTextStyles.dialogStyleMedium(
          size: fontSize == null ? 16.sp : fontSize.toDouble(),
          fontWeight: fontWeight == null ? FontWeight.w500 : fontWeight,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );

buttonStyle(Color color, String text, VoidCallback onPressed,
        [TextAlign? textAlign, double? left]) =>
    Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Container(
          alignment: Alignment.centerLeft,
          width: 62.w,
          height: 7.h,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12.w)),
          child: TextButton(
              onPressed: onPressed,
              // color == AllColors.green ? (){} : () async {
              //   setState(() {
              //     color = AllColors.green;
              //   });
              //   bool value = documentSnapshot.get('replay_level');
              //   level = documentSnapshot.get('last_level');
              //   level = level.toString().substring(6, 7);
              //   int lev = int.parse(level);
              //   if(lev == 1 && value == true){
              //     firestore.collection('User').doc(userId).update({
              //       'replay_level' : false
              //     });
              //   }
              //   firestore
              //       .collection('User')
              //       .doc(userId)
              //       .update({
              //     if (value != true)'last_level': 'Level_2_setUp_page',
              //     'previous_session_info': 'Level_2_setUp_page',
              //   });
              //   Future.delayed(
              //       Duration(seconds: 3),
              //           () =>  Get.off(() => LevelTwoSetUpPage(),
              //         duration:Duration(milliseconds: 500),
              //         transition: Transition.downToUp,));
              //   // gameScore = documentSnapshot
              //   //     .get('game_score');
              //   // if (lev != 1 &&
              //   //     value == true) {
              //   //   Future.delayed(
              //   //       Duration(seconds: 1),
              //   //       () => showDialogForReplay(lev, userId),
              //   //   );
              //   // } else {
              //
              //   // }
              // },
              child: Padding(
                padding: EdgeInsets.only(left: left == null ? 3.w : left),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      text,
                      style: AllTextStyles.dialogStyleLarge(
                        color: color == AllColors.green
                            ? Colors.white
                            : AllColors.darkBlue,
                      ),
                      textAlign: textAlign == null ? TextAlign.left : textAlign,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              )),
        ));

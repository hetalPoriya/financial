import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/views/coming_soon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:numeral/numeral.dart';
import 'dart:math' as math;

import '../utils/utils.dart';
import 'custom_screens.dart';

//button style for restart level or (creditbalance or debitbalance not enough) ok button
Widget restartOrOkButton(
        {String? text,
        VoidCallback? onPressed,
        Alignment? alignment,
        Color? textColor,
        Color? buttonColor}) =>
    Padding(
      padding: EdgeInsets.all(6.0),
      child: Align(
        alignment: alignment ?? Alignment.centerRight,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(buttonColor ?? Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.w)))),
            child: Padding(
              padding: EdgeInsets.all(1.w),
              child: Text(text.toString(),
                  style: AllTextStyles.workSansExtraSmall().copyWith(
                      color: textColor ?? AllColors.darkPurple,
                      fontWeight: FontWeight.normal)),
            )),
      ),
    );

allLevelBillPaymentText(
    {String? text, String? text1, String? text2, String? image}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 1.w),
            child: Container(
              alignment: Alignment.centerRight,
              height: 4.h,
              width: 6.w,
              //color: AllColors.red,
              child: image != null
                  ? Image.asset(
                      image.toString(),
                      fit: BoxFit.contain,
                    )
                  : Text(
                      text.toString(),
                      style: AllTextStyles.workSansLarge()
                          .copyWith(fontSize: 20.sp),
                    ),
              // child: Image.asset(
              //   image.toString(),
              //   fit: BoxFit.contain,
              //   height: 4.h,
              //   width: 6.w,
              // ),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: Container(
            // height: 6.h,
            //color: AllColors.green,
            child: Text(
              text1.toString(),
              style: AllTextStyles.workSansLarge().copyWith(fontSize: 16.sp),
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: Container(
            //  height: 6.h,
            //color: AllColors.red,
            child: Text(
              text2.toString(),
              style: AllTextStyles.workSansLarge().copyWith(
                fontSize: 16.sp,
                color: AllColors.darkYellow,
              ),
            ),
          ),
          flex: 1,
        ),
      ],
    ),
  );
}

Future<void> getUser({int? levelId}) async {
  int countForUser = 0;
  num totalBalanceForUser = 0;
  num totalCreditForUser = 0;
  num totalQolForUser = 0;
  num totalInvestmentForUser = 0;

  String level = '';
  var userId;

  userId = Prefs.getString(PrefString.userId)!;
  DocumentSnapshot documentSnapshot =
      await firestore.collection('User').doc(userId).get();
  level = documentSnapshot.get('previous_session_info');
  level = level.substring(0, 7);

  // snap.docs.forEach((document) async {
  //   documentSnapshot =
  //       await firestore.collection('User').doc(document.id).get();
  //   //levelForUser = documentSnapshot.get('previous_session_info');
  //   if ((documentSnapshot.data() as Map<String, dynamic>)
  //       .containsKey("level_1_balance")) {
  //     if (documentSnapshot.get('level_$levelId\_balance') != 0 &&
  //         document.id != userId) {
  //       countForUser = countForUser + 1;
  //       accountBalanceForUser = documentSnapshot.get('level_$levelId\_balance');
  //       qolForUser = documentSnapshot.get('level_$levelId\_qol');
  //
  //       totalBalanceForUser = totalBalanceForUser + accountBalanceForUser;
  //       totalQolForUser = totalQolForUser + qolForUser;
  //
  //       if (level == 'Level_3') {
  //         creditScoreForUser =
  //             documentSnapshot.get('level_$levelId\_creditScore');
  //         totalCreditForUser = totalCreditForUser + creditScoreForUser;
  //       }
  //
  //       if (level == 'Level_4' || level == 'Level_5') {
  //         investmentForUser =
  //             documentSnapshot.get('level_$levelId\_investment');
  //         totalInvestmentForUser = totalInvestmentForUser + investmentForUser;
  //       }
  //     }
  //
  //     storeValue.write('tBalance', totalBalanceForUser);
  //     storeValue.write('tQol', totalQolForUser);
  //     storeValue.write('tInvestment', totalInvestmentForUser);
  //     storeValue.write('tCredit', totalCreditForUser);
  //     storeValue.write('tUser', countForUser);
  //
  //     print('TOtal Balance $totalQolForUser');
  //     print('abc $countForUser');
  //     //print('sum=$sum');
  //   }
  // });

  firestore.collection("User").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) async {
      if (result.data().containsKey('level_1_balance')) {
        if (result.id != userId &&
            result.data()['level_$levelId\_balance'] != 0) {
          // print('ysss');
          countForUser = countForUser + 1;

          totalBalanceForUser += result.data()['level_$levelId\_balance'];
          totalQolForUser += result.data()['level_$levelId\_qol'];
          // print('UserBalance $totalBalanceForUser');
          // print('UserQol $totalQolForUser');
          // print('UserCount $countForUser');

          if (level == 'Level_3') {
            totalCreditForUser += result.data()['level_3_creditScore'];
            // print('UserScore $totalCreditForUser');
          }
          if (level == 'Level_4') {
            totalInvestmentForUser +=
                result.data()['level_$levelId\_investment'];
            // print('UserInvest $totalInvestmentForUser');
          }
        }
      } else {
        // print('NO');
      }

      await Prefs.setInt(PrefString.totalBalanceForUser, totalBalanceForUser.toInt());
      await Prefs.setInt(PrefString.totalQolForUser, totalQolForUser.toInt());

      if (level == 'Level_4' || level == 'Level_5')
        await Prefs.setInt(
            PrefString.totalInvestmentForUser, totalInvestmentForUser.toInt());

      if (level == 'Level_3')
        await Prefs.setInt(PrefString.totalCreditForUser, totalCreditForUser.toInt());
      await Prefs.setInt(PrefString.countForUser, countForUser.toInt());
    });
  });
}

calculationForProgress({VoidCallback? onPressed}) async {
  int abPer = 0;
  int qolPer = 0;
  int creditPer = 0;
  int investmentper = 0;
  String level = '';
  int qol = 0;
  int accountBalance = 0;
  int creditScore = 0;
  int investment = 0;

  var userId = Prefs.getString(PrefString.userId);
  int? totalBalanceForUser = Prefs.getInt(PrefString.totalBalanceForUser);
  int? totalQolForUser = Prefs.getInt(PrefString.totalQolForUser);
  int? totalInvestmentForUser = Prefs.getInt(PrefString.totalInvestmentForUser);
  int? totalCreditForUser = Prefs.getInt(PrefString.totalCreditForUser);
  int? countForUser = Prefs.getInt(PrefString.countForUser);

  DocumentSnapshot documentSnapshot =
      await firestore.collection('User').doc(userId).get();

  level = documentSnapshot.get('previous_session_info');
  accountBalance = documentSnapshot.get('account_balance');
  qol = documentSnapshot.get('quality_of_life');
  creditScore = documentSnapshot.get('credit_score');
  investment = documentSnapshot.get('investment');

  totalBalanceForUser = (totalBalanceForUser! / countForUser!).round();
  totalQolForUser = (totalQolForUser! / countForUser).round();
  totalCreditForUser = (totalCreditForUser! / countForUser).round();
  totalInvestmentForUser = (totalInvestmentForUser! / countForUser).round();

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

  savingAndQolDialog(
      abPer: abPer,
      qolPer: qolPer,
      creditPer: creditPer,
      investmentPer: investmentper,
      levelForUser: level,
      onPressed: onPressed!);
}

savingDialogText(
        {String? text1,
        String? text2,
        String? text3,
        Color? color,
        String? iconString}) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              //color: AllColors.red,
              alignment: Alignment.topCenter,
              child: Image.asset(
                iconString.toString(),
                height: 5.h,
                width: 8.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              //color: AllColors.green,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: RichText(
                  text: TextSpan(
                      text: text1,
                      style: AllTextStyles.leaderBoardNameInter().copyWith(
                          color: AllColors.progressColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                          text: text2,
                          style: AllTextStyles.leaderBoardNameInter().copyWith(
                              color: color,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: text3,
                          style: AllTextStyles.leaderBoardNameInter().copyWith(
                              color: AllColors.progressColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );

savingAndQolDialog(
    {int? abPer,
    int? qolPer,
    int? creditPer,
    int? investmentPer,
    String? levelForUser,
    VoidCallback? onPressed}) {
  String? level = levelForUser?.substring(6, 7);
  // int lev = int.parse(level.toString());

  Get.defaultDialog(
    title: 'Level Progress',
    titlePadding: EdgeInsets.only(top: 2.h, bottom: 1.h),
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: Colors.white,
    titleStyle: AllTextStyles.leaderBoardNameInter().copyWith(
        color: AllColors.progressColorTitle,
        fontSize: 18.sp,
        fontWeight: FontWeight.w800),
    content: Column(
      children: [
        Text(AllStrings.levelProgressTitle,
            style: AllTextStyles.leaderBoardNameInter().copyWith(
                color: AllColors.progressColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.center),
        SizedBox(
          height: 2.h,
        ),
        if (levelForUser == 'Level_1' ||
            levelForUser == 'Level_2' ||
            levelForUser == 'Level_3' ||
            levelForUser == 'Level_4' ||
            levelForUser == 'Level_5')
          abPer! > 0
              ? savingDialogText(
                  text1: AllStrings.savingsAre,
                  text2: '${abPer.abs()}% higher ',
                  text3: AllStrings.thanOthers,
                  color: AllColors.lightGreen,
                  iconString: AllImages.thumbsUp,
                )
              : abPer < 0
                  ? savingDialogText(
                      text1: AllStrings.savingsAre,
                      text2: '${abPer.abs()}% lower ',
                      text3: AllStrings.thanOthers,
                      color: AllColors.lightOrange,
                      iconString: AllImages.downArrow,
                    )
                  : abPer == 0
                      ? savingDialogText(
                          text1: 'Your savings is ',
                          text2: 'the same ',
                          text3: AllStrings.asOthers,
                          color: Colors.black,
                          iconString: AllImages.checkMark,
                        )
                      : null,
        if (levelForUser == 'Level_1' ||
            levelForUser == 'Level_2' ||
            levelForUser == 'Level_3' ||
            levelForUser == 'Level_4' ||
            levelForUser == 'Level_5')
          qolPer! > 0
              ? savingDialogText(
                  text1: AllStrings.lifestyleIs,
                  text2: '${qolPer.abs()}% higher ',
                  text3: AllStrings.thanOthers,
                  color: AllColors.lightGreen,
                  iconString: AllImages.thumbsUp,
                )
              : qolPer < 0
                  ? savingDialogText(
                      text1: AllStrings.lifestyleIs,
                      text2: '${qolPer.abs()}% lower ',
                      text3: AllStrings.thanOthers,
                      color: AllColors.lightOrange,
                      iconString: AllImages.downArrow,
                    )
                  : qolPer == 0
                      ? savingDialogText(
                          text1: AllStrings.lifestyleIs,
                          text2: 'the same ',
                          text3: AllStrings.asOthers,
                          color: Colors.black,
                          iconString: AllImages.checkMark,
                        )
                      : null,
        if (levelForUser == 'Level_3')
          creditPer! > 0
              ? savingDialogText(
                  text1: AllStrings.creditScoreIs,
                  text2: '${creditPer.abs()}% higher ',
                  text3: AllStrings.thanOthers,
                  color: AllColors.lightGreen,
                  iconString: AllImages.thumbsUp,
                )
              : creditPer < 0
                  ? savingDialogText(
                      text1: AllStrings.creditScoreIs,
                      text2: '${creditPer.abs()}% lower ',
                      text3: AllStrings.thanOthers,
                      color: AllColors.lightOrange,
                      iconString: AllImages.downArrow,
                    )
                  : creditPer == 0
                      ? savingDialogText(
                          text1: AllStrings.creditScoreIs,
                          text2: 'the same ',
                          text3: AllStrings.asOthers,
                          color: Colors.black,
                          iconString: AllImages.checkMark,
                        )
                      : null,
        if (levelForUser == 'Level_4' || levelForUser == 'Level_5')
          investmentPer! > 0
              ? savingDialogText(
                  text1: AllStrings.investmentIs,
                  text2: '${investmentPer.abs()}% higher ',
                  text3: AllStrings.thanOthers,
                  color: AllColors.lightGreen,
                  iconString: AllImages.thumbsUp,
                )
              : investmentPer < 0
                  ? savingDialogText(
                      text1: AllStrings.investmentIs,
                      text2: '${investmentPer.abs()}% lower ',
                      text3: AllStrings.thanOthers,
                      color: AllColors.lightOrange,
                      iconString: AllImages.downArrow,
                    )
                  : investmentPer == 0
                      ? savingDialogText(
                          text1: AllStrings.investmentIs,
                          text2: 'the same ',
                          text3: AllStrings.asOthers,
                          color: Colors.black,
                          iconString: AllImages.checkMark,
                        )
                      : null,
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Hint: Play till the end for higher scores',
          style: AllTextStyles.workSansSmallBlack()
              .copyWith(color: AllColors.lightGrey2, fontSize: 8.sp),
        )
      ],
    ),
    contentPadding: EdgeInsets.all(3.w),
    confirm: restartOrOkButton(
        text: 'Keep Going',
        onPressed: onPressed,
        alignment: Alignment.center,
        buttonColor: AllColors.progressColor,
        textColor: Colors.white),
  );
}

showDialogToShowIncreaseRent() async {
  var userId = Prefs.getString(PrefString.userId);
  rentPrice = Prefs.getInt(PrefString.rentPrice)!;
  transportPrice = Prefs.getInt(PrefString.transportPrice)!;
  lifestylePrice = Prefs.getInt(PrefString.lifestylePrice)!;

  // rentPrice = rentPrice + ((rentPrice * 5) ~/ 100).toInt();
  // transportPrice = transportPrice + ((transportPrice * 5) ~/ 100).toInt();
  // lifestylePrice = lifestylePrice + ((lifestylePrice * 5) ~/ 100).toInt();

  rentPrice = rentPrice + ((rentPrice * 10) ~/ 100).toInt();
  transportPrice = transportPrice + ((transportPrice * 10) ~/ 100).toInt();
  lifestylePrice = lifestylePrice + ((lifestylePrice * 10) ~/ 100).toInt();

  await Prefs.setInt(PrefString.rentPrice, rentPrice);
  await Prefs.setInt(PrefString.transportPrice, transportPrice);
  await Prefs.setInt(PrefString.lifestylePrice, lifestylePrice);

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
    titleStyle: AllTextStyles.workSansLarge()
        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w800),
    content: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 1.w,
            right: 1.w,
            bottom: 4.w,
          ),
          child: Text(
            AllStrings.billInflation,
            textAlign: TextAlign.center,
            style: AllTextStyles.workSansSmallWhite(),
          ),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Home Rent ',
              style: AllTextStyles.workSansSmallWhite()
                  .copyWith(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: AllStrings.countrySymbol + rentPrice.toString(),
                  style: AllTextStyles.workSansSmallWhite().copyWith(
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
              style: AllTextStyles.workSansSmallWhite()
                  .copyWith(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: AllStrings.countrySymbol + transportPrice.toString(),
                  style: AllTextStyles.workSansSmallWhite().copyWith(
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
              style: AllTextStyles.workSansSmallWhite()
                  .copyWith(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: AllStrings.countrySymbol + lifestylePrice.toString(),
                  style: AllTextStyles.workSansSmallWhite().copyWith(
                    fontWeight: FontWeight.w500,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
      ],
    ),
    confirm: restartOrOkButton(
      text: 'Ok',
      onPressed: () {
        Get.back();
      },
    ),
  );
}

popQuizDialog({
  VoidCallback? onPlayPopQuizPressed,
  VoidCallback? onPlayNextLevelPressed,
}) {
  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    title:
        'Congrats! You’ve managed to achieve your savings goal! Mission accomplished!',
    titleStyle: AllTextStyles.workSansSmallBlack()
        .copyWith(fontWeight: FontWeight.w500),
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
              style:
                  AllTextStyles.workSansExtraSmall().copyWith(fontSize: 13.sp),
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
              style:
                  AllTextStyles.workSansExtraSmall().copyWith(fontSize: 13.sp),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AllColors.lightBlue2,
              ),
            ),
          ),
        ),
      ],
    ),
    contentPadding: EdgeInsets.all(4.w),
    // radius: 12.w,
  );
}



Future inviteDialog() async {
  var userId = Prefs.getString(PrefString.userId);
  DocumentSnapshot snap = await firestore.collection('User').doc(userId).get();
  bool value = snap.get('replay_level');
  String level = snap.get('last_level');
  level = level.toString().substring(6, 7);
  int lev = int.parse(level);
  if (lev == 4 && value == true) {
    firestore.collection('User').doc(userId).update({'replay_level': false});
  }

  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    title: AllStrings.shareAppText,
    titleStyle: AllTextStyles.workSansSmallWhite(),
    backgroundColor: AllColors.darkPurple,
    titlePadding: EdgeInsets.all(4.w),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: ElevatedButton(
              onPressed: () async {
                FlutterShare.share(
                        title:
                            'https://play.google.com/store/apps/details?id=com.finshark',
                        text: AllStrings.shareAppDesText,
                        linkUrl:
                            'https://play.google.com/store/apps/details?id=com.finshark',
                        chooserTitle:
                            'https://play.google.com/store/apps/details?id=com.finshark')
                    .then((value) {})
                    .then((value) async {
                  Get.back();
                  FirebaseFirestore.instance
                      .collection('User')
                      .doc(userId)
                      .update({
                    if (value != true) 'last_level': 'Level_4',
                    'previous_session_info': 'Coming_soon',
                    'level_id': 0,
                    'account_balance': 0,
                  });

                  Get.offAll(
                    () => ComingSoon(),
                    // duration: Duration(milliseconds: 500),
                    // transition: Transition.downToUp,
                  );
                });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: Text(
                AllStrings.invite,
                style: AllTextStyles.workSansExtraSmall().copyWith(
                  fontSize: 13.sp,
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
            var userId = Prefs.getString(PrefString.userId);
            FirebaseFirestore.instance.collection('User').doc(userId).update({
              if (value != true) 'last_level': 'Level_4',
              'previous_session_info': 'Coming_soon',
              'level_id': 0,
              'account_balance': 0,
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

restartLevelDialog({VoidCallback? onPressed}) {
  return Get.defaultDialog(
    title: '',
    titlePadding: EdgeInsets.zero,
    middleText: AllStrings.restartLevelText,
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: AllColors.darkPurple,
    middleTextStyle: AllTextStyles.workSansSmallWhite(),
    confirm: restartOrOkButton(text: 'Restart level', onPressed: onPressed),
  );
}

richText(
        {String? text1,
        String? text2,
        double? paddingTop,
        double? paddingLeft,
        double? paddingRight,
        TextAlign? textAlign}) =>
    Padding(
      padding: EdgeInsets.only(
          top: paddingTop ?? 0,
          left: paddingLeft == null ? 0.0 : paddingLeft,
          right: paddingRight == null ? 0.0 : paddingRight),
      child: Center(
        child: RichText(
          textAlign: textAlign == null ? TextAlign.left : textAlign,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: text1,
              style: AllTextStyles.workSansLarge().copyWith(fontSize: 16.sp),
              children: [
                TextSpan(
                  text: text2,
                  style: AllTextStyles.workSansLarge().copyWith(
                    fontSize: 16.sp,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
      ),
    );

normalText({String? text, double? fontSize, FontWeight? fontWeight}) => Padding(
      padding: EdgeInsets.only(top: 3.h, left: 3.w, right: 3.w),
      child: Text(
        text.toString(),
        style: AllTextStyles.workSansSmallWhite().copyWith(
          fontSize: fontSize == null ? 16.sp : fontSize.toDouble(),
          fontWeight: fontWeight == null ? FontWeight.w500 : fontWeight,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );

buttonStyle(
        {Color? color,
        String? text,
        VoidCallback? onPressed,
        TextAlign? textAlign,
        double? left,
        double? topPadding}) =>
    Padding(
        padding: EdgeInsets.only(top: topPadding ?? 4.h),
        child: Container(
          alignment: Alignment.centerLeft,
          width: 62.w,
          height: 7.h,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12.w)),
          child: TextButton(
              onPressed: onPressed,
              child: Padding(
                padding: EdgeInsets.only(left: left == null ? 3.w : left),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      text.toString(),
                      style: AllTextStyles.workSansLarge().copyWith(
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

leaderBoardWidget(
        {int? rank,
        String? userName,
        int? gameScore,
        int? savings,
        int? netWorth,
        int? creditScore,
        int? lifestyleScore,
        Color? color,
        bool? userOrNot}) =>
    Container(
      padding: EdgeInsets.zero,
      height: 16.h,
      width: 90.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          6.w,
        ),
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Row(children: [
          Expanded(
            child: Container(
              //color: AllColors.blue,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(AllImages.circle, fit: BoxFit.contain),
                  rank == 0
                      ? Image.asset(AllImages.rank1, fit: BoxFit.contain)
                      : rank == 1
                          ? Image.asset(AllImages.rank2, fit: BoxFit.contain)
                          : rank == 2
                              ? Image.asset(AllImages.rank3,
                                  fit: BoxFit.contain)
                              : Text(rank.toString(),
                                  style: AllTextStyles.leaderBoardNameInter()
                                      .copyWith(fontSize: 22.sp)),
                ],
              ),
              height: 100.h,
              width: 100.w,
              //color: Colors.green,
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 1.w,
                        right: 4.w,
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Game Score',
                          style: AllTextStyles.workSansSmallBlack().copyWith(
                              fontSize: 6.sp, color: AllColors.lightPurple),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                                userName.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AllTextStyles.leaderBoardNameInter()
                                    .copyWith(
                                        color: userOrNot == true
                                            ? AllColors
                                                .leaderBoardNameInterColor
                                            : null),
                              ),
                              flex: 2),
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            // color: AllColors.red,
                            child: FittedBox(
                              child: GradientText(
                                  text: '${gameScore.toString()}'.toString(),
                                  style: AllTextStyles.robotoCondensed().copyWith(
                                    fontSize: 20.sp,
                                  ),
                                  gradient: LinearGradient(
                                      colors: [
                                        AllColors.darkBlue,
                                        AllColors.darkPink
                                      ],
                                      //transform: GradientRotation(math.pi / 2),
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topRight)),
                            ),
                          )),
                        ]),
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Container(
                      child: Row(children: [
                        leaderBoardBal(
                            i: 1,
                            text: 'Savings',
                            balance: savings,
                            color: AllColors.darkYellow,
                            userOrNot: userOrNot),
                        leaderBoardBal(
                            i: 2,
                            text: 'NetWorth',
                            balance: netWorth,
                            color: AllColors.orange,
                            userOrNot: userOrNot),
                        leaderBoardBal(
                            i: 3,
                            text: 'Credit',
                            balance: creditScore,
                            color: AllColors.lightGreen,
                            userOrNot: userOrNot),
                        leaderBoardBal(
                            i: 4,
                            text: 'Lifestyle',
                            balance: lifestyleScore,
                            color: AllColors.extraLightBlue,
                            userOrNot: userOrNot),
                      ]),
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),
            flex: 4,
          ),
        ]),
      ),
    );

leaderBoardBal(
    {String? text, int? balance, Color? color, int? i, bool? userOrNot}) {
  return Expanded(
      child: Container(
    padding: EdgeInsets.zero,
    // color: AllColors.red,
    child: Column(children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              color: userOrNot == true
                  ? AllColors.leaderBoardColor
                  : Colors.grey.shade50,
              borderRadius: userOrNot == true
                  ? BorderRadius.zero
                  : i == 1
                      ? BorderRadius.only(
                          topLeft: Radius.circular(2.w),
                          bottomLeft: Radius.circular(2.w))
                      : i == 4
                          ? BorderRadius.only(
                              bottomRight: Radius.circular(2.w),
                              topRight: Radius.circular(2.w))
                          : null),
          alignment: Alignment.center,
          width: 100.w,
          child: FittedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: balance.toString().length > 4
                        ? Numeral(balance!.toInt().ceil())
                            .format(fractionDigits: 1)
                            .toString()
                        : balance?.ceil().toString(),
                    style: AllTextStyles.workSansSmallWhite().copyWith(
                      color: color,
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
        flex: 2,
      ),
      Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: 01),
            child: Text(
              text.toString(),
              style: AllTextStyles.workSansSmallBlack()
                  .copyWith(fontSize: 8.sp, color: AllColors.lightGrey2),
            ),
          ),
          //color: AllColors.red,
        ),
      ),
    ]),
  ));
}

buttonStyleLinear(
        {String? text, Widget? imageWidget, VoidCallback? onPressed}) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        width: 100.w,
        height: 7.h,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AllColors.buttonColor1,
              AllColors.buttonColor2,
              AllColors.buttonColor3,
            ]),
            borderRadius: BorderRadius.circular(7.w)),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.w))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageWidget ?? Container(),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      text.toString(),
                      style: AllTextStyles.signikaTextSmall(),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );

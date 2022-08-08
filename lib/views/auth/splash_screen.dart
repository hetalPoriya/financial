import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/views/levels/all_que_level_five.dart';
import 'package:financial/views/levels/all_que_level_six.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../utils/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userController = Get.put<UserInfoController>(UserInfoController());
  var userId;
  var documentExist;
  var collectionRef;

  //function for get all value from fireStore and check user state
  getUID() {
    userId = Prefs.getString(PrefString.userId);
    print('UserId ${userId}');

    //if user id available than check there state and move to that position
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .get()
          .then((doc) async => {
                level = doc.get("previous_session_info"),
                levelId = doc.get("level_id"),
                if (doc.data().toString().contains('country_code') == true)
                  {
                    country = doc.get('country_code'),
                    firestore
                        .collection('Countries')
                        .doc(country.toString())
                        .get()
                        .then((value) async {
                      if (value.exists) {
                        print('Country ${value['country_name']}');
                        await Prefs.setString(PrefString.countrySymbol,
                            value['currency']['symbol']);
                      } else {
                        await Prefs.setString(PrefString.countrySymbol, '\$');
                      }
                    }),
                  },
                print(level),
                print(levelId),
              })
          .then((value) {
        // Future.delayed(
        //     Duration(seconds: 6), () => Get.offNamed('/RateUs'));

        if (level == 'Level_1_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level1SetUp'));

        if (level == 'Level_1')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level1'));

        if (level == 'Level_1_Pop_Quiz')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/LevelOnePopQuiz'));

        if (level == 'Level_2_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level2SetUp'));

        if (level == 'Level_2')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level2'));

        if (level == 'Referral_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/ReferralSystem'));

        if (level == 'Level_2_Pop_Quiz' ||
            level == 'Level_3_Pop_Quiz' ||
            level == 'Level_4_Pop_Quiz')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/PopQuiz'));

        if (level == 'Level_3_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level3SetUp'));

        if (level == 'Level_3')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level3'));

        if (level == 'Level_4_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level4SetUp'));

        if (level == 'Level_4')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level4'));

        if (level == 'Level_5_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level5SetUp'));

        if (level == 'Level_5')
          Future.delayed(
              Duration(seconds: 1),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllQueLevelFive())));

        if (level == 'Level_6_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level6SetUp'));

        if (level == 'Level_6')
          Future.delayed(
              Duration(seconds: 1),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllQueLevelSix())));

        if (level == 'Coming_soon')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/ComingSoon'));
      });
    } else {
      //if user not login than move to intro screen
      Future.delayed(Duration(seconds: 1), () => Get.offNamed('/OnBoarding'));
    }
  }

  @override
  void initState() {
    getUID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: 100.w,
          height: 100.h,
          decoration: boxDecoration,
          child: Center(
              child: Text('finshark',
                  style: AllTextStyles.workSansExtraLarge()
                      .copyWith(fontSize: 28.sp))),
        ),
      ),
    );
  }
}

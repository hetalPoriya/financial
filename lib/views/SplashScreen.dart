import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/views/AllQueLevelFive.dart';
import 'package:financial/views/AllQueLevelSix.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //to get user id
  var userId;
  var getCredential = GetStorage();

  //for get all value from firestore
  String level = ' ';
  int levelId = 0;

  //function for get all value from firestore and check user state
  getUID() async {
    userId = getCredential.read('uId');
    print('UserId $userId');
    //if user id available than check there state and move to that position
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(userId)
          .get()
          .then((doc) => {
                level = doc.get("previous_session_info"),
                levelId = doc.get("level_id"),
              })
          .then((value) {
        if (level == 'Level_1_setUp_page')
          Future.delayed(
              Duration(seconds: 6), () => Get.offNamed('/Level1SetUp'));

        if (level == 'Level_1')
          Future.delayed(Duration(seconds: 6), () => Get.offNamed('/Level1'));

        if (level == 'Level_1_Pop_Quiz')
          Future.delayed(Duration(seconds: 6), () => Get.offNamed('/LevelOnePopQuiz'));

        if (level == 'Level_2_setUp_page')
          Future.delayed(
              Duration(seconds: 6), () => Get.offNamed('/Level2SetUp'));

        if (level == 'Level_2')
          Future.delayed(Duration(seconds: 6), () => Get.offNamed('/Level2'));

        if (level == 'Level_2_Pop_Quiz' || level == 'Level_3_Pop_Quiz' || level == 'Level_4_Pop_Quiz')
          Future.delayed(Duration(seconds: 6), () => Get.offNamed('/PopQuiz'));

        if (level == 'Level_3_setUp_page')
          Future.delayed(
              Duration(seconds: 6), () => Get.offNamed('/Level3SetUp'));

        if (level == 'Level_3')
          Future.delayed(Duration(seconds: 6), () => Get.offNamed('/Level3'));

        if (level == 'Level_4_setUp_page')
          Future.delayed(
              Duration(seconds: 6), () => Get.offNamed('/Level4SetUp'));

        if (level == 'Level_4')
          Future.delayed(Duration(seconds: 6), () => Get.offNamed('/Level4'));

        if (level == 'Level_5_setUp_page')
          Future.delayed(
              Duration(seconds: 6), () => Get.offNamed('/Level5SetUp'));

        if (level == 'Level_5')
          Future.delayed(
              Duration(seconds: 6),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllQueLevelFive())));

        if (level == 'Level_6_setUp_page')
          Future.delayed(
              Duration(seconds: 6), () => Get.offNamed('/Level6SetUp'));

        if (level == 'Level_6')
          Future.delayed(
              Duration(seconds: 6),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllQueLevelSix())));

        if (level == 'Coming_soon')
          Future.delayed(
              Duration(seconds: 6), () => Get.offNamed('/ComingSoon'));
      });
    } else {
      //if user not login than move to intro screen
      Future.delayed(Duration(seconds: 6), () => Get.offNamed('/OnBoarding'));
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
              child: Text(
            'finshark',
            style: GoogleFonts.workSans(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w600),
          )),
        ),
      ),
    );
  }
}

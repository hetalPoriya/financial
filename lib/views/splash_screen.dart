import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/all_que_level_five.dart';
import 'package:financial/views/all_que_level_six.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userController = Get.put<UserInfoController>(UserInfoController());

  //function for get all value from fireStore and check user state
  getUID() async {
    userController.userId = userController.getCredential.read('uId');
    userController.update();
    print('UserId ${userController.userId}');

    //if user id available than check there state and move to that position
    if (userController.userId != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(userController.userId)
          .get()
          .then((doc) => {
                userController.level = doc.get("previous_session_info"),
                userController.levelId = doc.get("level_id"),
                if (doc.data().toString().contains('country') == true)
                  {
                    country = doc.get('country'),
                  },
                userController.update(),
                print(userController.level),
                print(userController.levelId),
              })
          .then((value) {
        // Future.delayed(
        //     Duration(seconds: 6), () => Get.offNamed('/RateUs'));

        if (userController.level == 'Level_1_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level1SetUp'));

        if (userController.level == 'Level_1')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level1'));

        if (userController.level == 'Level_1_Pop_Quiz')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/LevelOnePopQuiz'));

        if (userController.level == 'Level_2_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level2SetUp'));

        if (userController.level == 'Level_2')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level2'));

        if (userController.level == 'Level_2_Pop_Quiz' ||
            userController.level == 'Level_3_Pop_Quiz' ||
            userController.level == 'Level_4_Pop_Quiz')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/PopQuiz'));

        if (userController.level == 'Level_3_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level3SetUp'));

        if (userController.level == 'Level_3')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level3'));

        if (userController.level == 'Level_4_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level4SetUp'));

        if (userController.level == 'Level_4')
          Future.delayed(Duration(seconds: 1), () => Get.offNamed('/Level4'));

        if (userController.level == 'Level_5_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level5SetUp'));

        if (userController.level == 'Level_5')
          Future.delayed(
              Duration(seconds: 1),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllQueLevelFive())));

        if (userController.level == 'Level_6_setUp_page')
          Future.delayed(
              Duration(seconds: 1), () => Get.offNamed('/Level6SetUp'));

        if (userController.level == 'Level_6')
          Future.delayed(
              Duration(seconds: 1),
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AllQueLevelSix())));

        if (userController.level == 'Coming_soon')
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
                  style: AllTextStyles.dialogStyleExtraLarge(size: 28.sp))),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/models/profile_page_model.dart';
import 'package:financial/models/que_model.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/level_five_setUp_page.dart';
import 'package:financial/views/level_four_setUp_page.dart';
import 'package:financial/views/level_one_pop_quiz.dart';

import 'package:financial/views/level_one_setUp_page.dart';
import 'package:financial/views/level_three_setUp_page.dart';
import 'package:financial/views/level_two_setUp_page.dart';
import 'package:financial/views/pop_quiz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

class Levels extends StatefulWidget {
  const Levels({Key? key}) : super(key: key);

  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {
  //for model
  QueModel? queModel;
  var userId;
  final getCredential = GetStorage();
  int gameScore = 0;
  String? userName;

  List<QueModel> list = [];
  int level1Id = 0;
  int level2Id = 0;
  int level3Id = 0;
  int level4Id = 0;
  int level5Id = 0;
  int level6Id = 0;
  int level1popQuizId = 0;
  int level2popQuizId = 0;
  int level3popQuizId = 0;
  int level4popQuizId = 0;
  int level5popQuizId = 0;
  int level6popQuizId = 0;
  int level1totalQue = 0;
  int level2totalQue = 0;
  int level3totalQue = 0;
  int level4totalQue = 0;
  int level5totalQue = 0;
  int level6totalQue = 0;
  int level1popQuizQue = 0;
  int level2popQuizQue = 0;
  int level3popQuizQue = 0;
  int level4popQuizQue = 0;
  String? level;
  int lev = 0;

  Future<QueModel?> getLevelId() async {

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // userId = pref.getString('uId');
    userId = getCredential.read('uId');

    QuerySnapshot<Map<String, dynamic>>? l1 =
        await firestore.collection('Level_1').get();
    QuerySnapshot<Map<String, dynamic>>? l2 =
        await firestore.collection('Level_2').get();
    QuerySnapshot<Map<String, dynamic>>? l3 =
        await firestore.collection('Level_3').get();
    QuerySnapshot<Map<String, dynamic>>? l4 =
        await firestore.collection('Level_4').get();
    QuerySnapshot<Map<String, dynamic>>? l5 =
        await firestore.collection('Level_4').get();
    QuerySnapshot<Map<String, dynamic>>? l1PopQuiz =
        await firestore.collection('Level_1_Pop_Quiz').get();
    QuerySnapshot<Map<String, dynamic>>? l2PopQuiz =
        await firestore.collection('Level_2_Pop_Quiz').get();
    QuerySnapshot<Map<String, dynamic>>? l3PopQuiz =
        await firestore.collection('Level_3_Pop_Quiz').get();
    QuerySnapshot<Map<String, dynamic>>? l4PopQuiz =
        await firestore.collection('Level_4_Pop_Quiz').get();
    DocumentSnapshot shot =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();
    setState(() {
      gameScore = shot.get('game_score');
      level1Id = shot.get('level_1_id');
      level2Id = shot.get('level_2_id');
      level3Id = shot.get('level_3_id');
      level4Id = shot.get('level_4_id');
      level5Id = shot.get('level_5_id');
      level6Id = shot.get('level_6_id');

      level1popQuizId = shot.get('level_1_popQuiz_id');
      level2popQuizId = shot.get('level_2_popQuiz_id');
      level3popQuizId = shot.get('level_3_popQuiz_id');
      level4popQuizId = shot.get('level_4_popQuiz_id');
      level5popQuizId = shot.get('level_5_popQuiz_id');
      level6popQuizId = shot.get('level_6_popQuiz_id');

      level1totalQue = l1.size;
      level2totalQue = l2.size;
      level3totalQue = l3.size;
      level4totalQue = l4.size;
      level5totalQue = l5.size;

      level1popQuizQue = l1PopQuiz.size;
      level2popQuizQue = l2PopQuiz.size;
      level3popQuizQue = l3PopQuiz.size;
      level4popQuizQue = l4PopQuiz.size;

      print('LEVEL 3 $level3totalQue');
      level = shot.get('last_level');

    });
    lev = int.parse(level.toString().substring(6, 7));
    return null;
  }

  List<LevelsModel> levelList = [
    LevelsModel(
      id: 1,
      description: AllStrings.level1Dec,
      level: AllStrings.level1,
      goal: AllStrings.level1Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    LevelsModel(
      id: 2,
      description: AllStrings.level2Dec,
      level: AllStrings.level2,
      goal: AllStrings.level2Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    LevelsModel(
      id: 3,
      description: AllStrings.level3Dec,
      level: AllStrings.level3,
      goal: AllStrings.level3Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    LevelsModel(
      id: 4,
      description: AllStrings.level4Dec,
      level: AllStrings.level4,
      goal: AllStrings.level4Goal,
      //goal: 'Goal : Achieve investments of 30k towards down-payment to buy house.',
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    LevelsModel(
      id: 5,
      description: AllStrings.level5Dec,
      level: AllStrings.level5,
      goal: AllStrings.level5Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    LevelsModel(
      id: 6,
      description: AllStrings.level6Dec,
      level: AllStrings.level6,
      goal: AllStrings.level6Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    LevelsModel(
      id: 7,
      description: AllStrings.level7Dec,
      level: AllStrings.level7,
      goal: AllStrings.level7Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
  ];

  @override
  void initState() {
    getLevelId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return level == null
        ? Container(
            decoration: boxDecoration,
            alignment: Alignment.center,
            child: CircularProgressIndicator(backgroundColor: AllColors.blue))
        : SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              //extendBody: false,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Levels', style: AllTextStyles.settingsAppTitle()),
                centerTitle: true,
              ),
              body: Container(
                decoration: boxDecoration,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: levelList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              // height: levelList[index].id == 1 ? 30.h : 38.h,
                              height: 38.h,
                              width: 99.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    //height: levelList[index].id == 1 ? 23.h : 30.h,
                                    height: 30.h,
                                    width: 86.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        6.w,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 2.w,
                                            right: 2.w,
                                          ),
                                          child: Text(
                                            '${levelList[index].description}',
                                            style: AllTextStyles.robotoSmall(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        if (levelList[index].id! <= 5)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 1.h,
                                                bottom: 2.h,
                                                left: 2.w,
                                                right: 2.w
                                                //bottom: displayWidth(context) * .02,
                                                ),
                                            child: FittedBox(
                                              child: Text(
                                                '${levelList[index].goal}',
                                                style:
                                                    AllTextStyles.robotoSmall(
                                                  size: 9.sp,
                                                  color: Color(0xff818186),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        if (levelList[index].id! > 5)
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            LinearPercentIndicator(
                                              animation: true,
                                              lineHeight: 4.h,
                                              width: 60.w,
                                              animationDuration: 1000,
                                              percent: levelList[index].id == 1
                                                  ? (level1Id.toDouble() /
                                                      level1totalQue)
                                                  : levelList[index].id == 2
                                                      ? (level2Id.toDouble() /
                                                          level2totalQue)
                                                      : levelList[index].id == 3
                                                          ? (level3Id
                                                                  .toDouble() /
                                                              level3totalQue)
                                                          : levelList[index]
                                                                      .id ==
                                                                  4
                                                              ? (level4Id
                                                                      .toDouble() /
                                                                  level4totalQue)
                                                              : levelList[index]
                                                                          .id ==
                                                                      5
                                                                  ? (level5Id
                                                                          .toDouble() /
                                                                      36)
                                                                  : (level6Id
                                                                          .toDouble() /
                                                                      80),
                                              center: Text(
                                                'LEVEL PROGRESS',
                                                style:
                                                    AllTextStyles.robotoSmall(
                                                        size: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.white),
                                              ),
                                              barRadius: Radius.circular(3.w),
                                              progressColor:
                                                  levelList[index].id! > lev
                                                      ? Color(0xffFFDAF0)
                                                      : Color(0xffFF3D8E),
                                              backgroundColor:
                                                  Color(0xffFFDAF0),
                                            ),
                                            GestureDetector(
                                              child: Image.asset(
                                                AllImages.replayImage,
                                                width: 8.w,
                                                height: 5.h,
                                              ),
                                              onTap: () {
                                                levelList[index].id! <= lev
                                                    ? _updateValue(
                                                        levelList[index].id)
                                                    : Container();
                                              },
                                            ),
                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 22.w),
                                                child: Text(
                                                    levelList[index].id == 1
                                                        ? '${((level1Id * 100) / level1totalQue).ceil()}% COMPLETED'
                                                        : levelList[index].id ==
                                                                2
                                                            ? '${((level2Id * 100) / level2totalQue).ceil()}% COMPLETED'
                                                            : levelList[index]
                                                                        .id ==
                                                                    3
                                                                ? '${((level3Id * 100) / level3totalQue).ceil()}% COMPLETED'
                                                                : levelList[index]
                                                                            .id ==
                                                                        4
                                                                    ? '${((level4Id * 100) / level4totalQue).ceil()}% COMPLETED'
                                                                    : levelList[index].id ==
                                                                            5
                                                                        ? '${((level5Id * 100) / 36).ceil()}% COMPLETED'
                                                                        : '${((level6Id * 100) / 80).ceil()}% COMPLETED',
                                                    style: AllTextStyles
                                                        .workSansSmall(
                                                      fontSize: 8.sp,
                                                      color: Color(0xffC4C4C4),
                                                    )))),
                                        // levelList[index].id == 1
                                        //     ? Container()
                                        //     :
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            LinearPercentIndicator(
                                              animation: true,
                                              lineHeight: 4.h,
                                              width: 60.w,
                                              animationDuration: 1000,
                                              percent: levelList[index].id == 1
                                                  ? (level1popQuizId
                                                          .toDouble() /
                                                      level1popQuizQue)
                                                  : levelList[index].id == 2
                                                      ? (level2popQuizId
                                                              .toDouble() /
                                                          level2popQuizQue)
                                                      : levelList[index].id == 3
                                                          ? (level3popQuizId
                                                                  .toDouble() /
                                                              level3popQuizQue)
                                                          : levelList[index]
                                                                      .id ==
                                                                  4
                                                              ? (level4popQuizId
                                                                      .toDouble() /
                                                                  level4popQuizQue)
                                                              : levelList[index]
                                                                          .id ==
                                                                      5
                                                                  ? (level5Id
                                                                          .toDouble() /
                                                                      36)
                                                                  : (level6Id
                                                                          .toDouble() /
                                                                      80),
                                              center: Text(
                                                'POP QUIZ',
                                                style:
                                                    AllTextStyles.robotoSmall(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        size: 10.sp),
                                              ),
                                              barRadius: Radius.circular(3.w),
                                              progressColor:
                                                  levelList[index].id! > lev
                                                      ? Color(0xffCDE4FD)
                                                      : Color(0xff409AFF),
                                              backgroundColor:
                                                  Color(0xffCDE4FD),
                                            ),
                                            GestureDetector(
                                              child: levelList[index].id ==
                                                              1 &&
                                                          (((level1popQuizId * 100) /
                                                                      level1popQuizQue)
                                                                  .ceil() ==
                                                              100) ||
                                                      levelList[index]
                                                                  .id ==
                                                              2 &&
                                                          (((level2popQuizId *
                                                                          100) /
                                                                      level2popQuizQue)
                                                                  .ceil() ==
                                                              100) ||
                                                      levelList[index].id ==
                                                              3 &&
                                                          (((level3popQuizId *
                                                                          100) /
                                                                      level3popQuizQue)
                                                                  .ceil() ==
                                                              100) ||
                                                      levelList[index].id ==
                                                              4 &&
                                                          (((level4popQuizId *
                                                                          100) /
                                                                      level4popQuizQue)
                                                                  .ceil() ==
                                                              100)
                                                  ? Image.asset(
                                                      AllImages.rightImage,
                                                      width: 7.w,
                                                      height: 5.h,
                                                    )
                                                  : Image.asset(
                                                      AllImages.popQuiz,
                                                      width: 8.w,
                                                      height: 5.h,
                                                    ),
                                              onTap: () {
                                                levelList[index].id! <= lev
                                                    ? _updatePopQuizValue(
                                                        levelList[index].id,
                                                        true)
                                                    : Container();
                                              },
                                            ),
                                          ],
                                        ),
                                        // levelList[index].id == 1
                                        //     ? Container()
                                        //     :
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 22.w),
                                              child: Text(
                                                  levelList[index].id == 1
                                                      ? '${((level1popQuizId * 100) / level1popQuizQue).ceil()}% COMPLETED'
                                                      : levelList[index].id == 2
                                                          ? '${((level2popQuizId * 100) / level2popQuizQue).ceil()}% COMPLETED'
                                                          : levelList[index]
                                                                      .id ==
                                                                  3
                                                              ? '${((level3popQuizId * 100) / level3popQuizQue).ceil()}% COMPLETED'
                                                              : levelList[index]
                                                                          .id ==
                                                                      4
                                                                  ? '${((level4popQuizId * 100) / level4popQuizQue).ceil()}% COMPLETED'
                                                                  : levelList[index]
                                                                              .id ==
                                                                          5
                                                                      ? '${((level5Id * 100) / 36).ceil()}% COMPLETED'
                                                                      : '${((level6Id * 100) / 80).ceil()}% COMPLETED',
                                                  style: AllTextStyles
                                                      .workSansSmall(
                                                    fontSize: 8.sp,
                                                    color: Color(0xffC4C4C4),
                                                  )),
                                            )),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0.h,
                                    left: 14.w,
                                    child: Container(
                                      width: 48.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.w),
                                        color: Color(0xffFFF1ED),
                                        border: Border.all(
                                            color: Color(0xffFF8762)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 3.w),
                                        child: Text(
                                          '${levelList[index].level}',
                                          style: AllTextStyles.robotoSmall(
                                            size: 13.sp,
                                            color: Color(0xffFE845E),
                                          ),
                                        ),
                                      ),
                                    ),
                                    height: 6.h,
                                  ),
                                  Positioned(
                                    top: 0.h,
                                    left: 8.w,
                                    width: 18.w,
                                    child: Container(
                                      width: 42.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffFBC712),
                                      ),
                                      child: levelList[index].id! <= lev
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${levelList[index].id}',
                                                style: AllTextStyles.balooDa(),
                                              ),
                                            )
                                          : Container(
                                              height: 4.h,
                                              child:
                                                  Image.asset(AllImages.lock)),
                                    ),
                                    height: 6.h,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  _updateValue(int? i) async {
    getCredential.write('update', 0);
    DocumentSnapshot document =
        await firestore.collection('User').doc(userId).get();
    gameScore = document.get('game_score');

    firestore.collection('User').doc(userId).update({
      'replay_level': true,
      'account_balance': 0,
      'bill_payment': 0,
      'credit_card_balance': 0,
      'pop_quiz_point_changed' : false,
      'credit_card_bill': 0,
      'credit_score': 0,
      'level_id': 0,
      'payable_bill': 0,
      'previous_session_info': 'Level_$i\_setUp_page',
      'quality_of_life': 0,
      'score': 0,
      'level_1_id': i == 1 ? 0 : level1Id,
      if (i == 1) 'level_1_balance': 0,
      if (i == 1) 'level_1_qol': 0,
      if (i == 2) 'level_2_balance': 0,
      if (i == 2) 'level_2_qol': 0,
      if (i == 3) 'level_3_balance': 0,
      if (i == 3) 'level_3_qol': 0,
      if (i == 3) 'level_3_creditScore': 0,
      if (i == 4) 'level_4_balance': 0,
      if (i == 4) 'level_4_qol': 0,
      if (i == 4) 'level_4_investment': 0,
      if (i == 5) 'level_5_balance': 0,
      if (i == 5) 'level_5_qol': 0,
      if (i == 5) 'level_5_investment': 0,
      'level_2_id': i == 2 ? 0 : level2Id,
      'level_3_id': i == 3 ? 0 : level3Id,
      'level_4_id': i == 4 ? 0 : level4Id,
      'level_5_id': i == 5 ? 0 : level5Id,
      'level_6_id': i == 6 ? 0 : level6Id,
    }).then((value) {
      if (i == 1)
        Get.offAll(
          () => LevelOneSetUpPage(),
          duration: Duration(milliseconds: 500),
          // transition: Transition.downToUp,
        );
      if (i == 2)
        Get.offAll(
          () => LevelTwoSetUpPage(),
          duration: Duration(milliseconds: 500),
          //transition: Transition.downToUp,
        );
      if (i == 3)
        Get.offAll(
          () => LevelThreeSetUpPage(),
          duration: Duration(milliseconds: 500),
          // transition: Transition.downToUp,
        );

      if (i == 4) {
        getCredential.write('level4or5innerPageViewId', 0);
        getCredential.write('randomNumberValue', 0);
        getCredential.write('count', 0);
        Get.offAll(
          () => LevelFourSetUpPage(),
          duration: Duration(milliseconds: 500),
          // transition: Transition.downToUp,
        );
      }
      if (i == 5) {
        getCredential.write('level4or5innerPageViewId', 0);
        getCredential.write('randomNumberValue', 0);
        getCredential.write('count', 0);
        Get.offAll(
          () => LevelFiveSetUpPage(),
          duration: Duration(milliseconds: 500),
          // transition: Transition.downToUp,
        );
      }
      //
      // if (i == 6)
      //   Get.off(
      //     () => LevelSixSetUpPage(),
      //     duration: Duration(milliseconds: 500),
      //     transition: Transition.downToUp,
      //   );
    });
  }

  _updatePopQuizValue(
    int? i,
    bool value,
  ) async {
    DocumentSnapshot document =
        await firestore.collection('User').doc(userId).get();
    gameScore = document.get('game_score');

    firestore.collection('User').doc(userId).update({
      'replay_level': true,
      'account_balance': 0,
      'bill_payment': 0,
      'credit_card_balance': 0,
      'credit_card_bill': 0,
      'pop_quiz_point_changed': false,
      'credit_score': 0,
      'level_id': 0,
      'payable_bill': 0,
      'previous_session_info': 'Level_$i\_Pop_Quiz',
      'quality_of_life': 0,
      'score': 0,
      // 'level_1_id': i == 1 ? 0 : level1Id,
      // 'level_1_id': i == 1 ? 0 : level1Id,
      // 'level_2_id': i == 2 ? 0 : level2Id,
      // 'level_3_id': i == 3 ? 0 : level3Id,
      // 'level_4_id': i == 4 ? 0 : level4Id,
      // 'level_5_id': i == 5 ? 0 : level5Id,
      // 'level_6_id': i == 6 ? 0 : level6Id,
      'level_1_popQuiz_id': i == 1 ? 0 : level1popQuizId,
      'level_2_popQuiz_id': i == 2 ? 0 : level2popQuizId,
      'level_3_popQuiz_id': i == 3 ? 0 : level3popQuizId,
      'level_4_popQuiz_id': i == 4 ? 0 : level4popQuizId,
      'level_5_popQuiz_id': i == 5 ? 0 : level5popQuizId,
      'level_6_popQuiz_id': i == 6 ? 0 : level6popQuizId,
    }).then((value) {
      if (i == 1) {
        Get.offAll(
          () => LevelOnePopQuiz(),
          duration: Duration(milliseconds: 500),
          //  transition: Transition.downToUp,
        );
      }
      if (i == 2 || i == 3 || i == 4)
        Get.offAll(
          () => PopQuiz(),
          duration: Duration(milliseconds: 500),
          // transition: Transition.downToUp,
        );

      if (i == 5)
        Get.offAll(
          () => LevelFiveSetUpPage(),
          duration: Duration(milliseconds: 500),
        );
      // if (i == 6)
      //   Get.off(
      //     () => LevelFourSetUpPage(),
      //     duration: Duration(milliseconds: 500),
      //     transition: Transition.downToUp,
      //   );
    });
  }
}

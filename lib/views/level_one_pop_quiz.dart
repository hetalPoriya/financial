import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/shareable_screens/game_score_page.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/models/que_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import 'local_notify_manager.dart';

class LevelOnePopQuiz extends StatefulWidget {
  LevelOnePopQuiz({
    Key? key,
  }) : super(key: key);

  @override
  _LevelOnePopQuizState createState() => _LevelOnePopQuizState();
}

class _LevelOnePopQuizState extends State<LevelOnePopQuiz>
    with SingleTickerProviderStateMixin {
  //for model
  QueModel? queModel;
  List<QueModel> list = [];
  String popQuiz = '';

  var document;
  var userId;
  int levelId = 0;
  var getCredential = GetStorage();

  //page controller
  PageController controller = PageController();

  Color color1 = Colors.white;
  Color color2 = Colors.white;
  int optionSelect = 0;

  getLevelId() async {
    userId = getCredential.read('uId');
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    popQuiz = snap.get('previous_session_info');
    levelId = snap.get('level_id');
    print('Level Id $levelId');
    controller = PageController(initialPage: levelId);

    QuerySnapshot querySnapshot =
        await firestore.collection("Level_1_Pop_Quiz").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      queModel = QueModel();
      queModel?.id = a['id'];
      setState(() {
        list.add(queModel!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLevelId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: boxDecoration,
        child: list.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator(backgroundColor: AllColors.blue))
            : StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('Level_1_Pop_Quiz')
                    .orderBy('id')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('It\'s Error!');
                  }
                  if (!snapshot.hasData)
                    return Container(
                      decoration: boxDecoration,
                      child: Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                              backgroundColor: AllColors.blue),
                        ),
                      ),
                    );

                  return PageView.builder(
                      itemCount: snapshot.data?.docs.length,
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {
                        setState(() {
                          optionSelect = 0;
                          color1 = Colors.white;
                          color2 = Colors.white;
                        });
                      },
                      itemBuilder: (context, index) {
                        document = snapshot.data?.docs[index];
                        return Scaffold(
                            backgroundColor: Colors.transparent,
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
                                    GameScorePage(
                                        level: popQuiz,
                                        pointValue: popQuizPointChanges),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 80.w,
                                      height: 62.h,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6.w,
                                          ),
                                          color: Colors.white),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.h,
                                                left: 5.w,
                                                right: 5.w,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  document['description'],
                                                  style: AllTextStyles
                                                      .workSansMediumBlack(),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ),
                                            StatefulBuilder(
                                                builder: (context, _setState) {
                                              String ans =
                                                  document['correct_ans'];
                                              String text =
                                                  document['option_1'];
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  options(
                                                      onPressed: () {
                                                        _checkCorrectAnswer(
                                                            ans,
                                                            _setState,
                                                            1,
                                                            'a',
                                                            document);
                                                      },
                                                      index: index,
                                                      document: document,
                                                      color: color1,
                                                      i: 1,
                                                      text:
                                                          document['option_1']),
                                                  options(
                                                      onPressed: () {
                                                        _checkCorrectAnswer(
                                                            ans,
                                                            _setState,
                                                            2,
                                                            'b',
                                                            document);
                                                      },
                                                      index: index,
                                                      document: document,
                                                      color: color2,
                                                      i: 2,
                                                      text:
                                                          document['option_2']),
                                                ],
                                              );
                                            }),
                                            SizedBox(
                                              height: 1.h,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                        width: 76.w,
                                        height: 7.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                        ),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              if (index ==
                                                  snapshot.data!.docs.length -
                                                      1) {
                                                // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(21);
                                                // await localNotifyManager.repeatNotificationLevel2();
                                                // await localNotifyManager
                                                //     .flutterLocalNotificationsPlugin
                                                //     .cancel(1);
                                                // await localNotifyManager
                                                //     .flutterLocalNotificationsPlugin
                                                //     .cancel(7);
                                                // await localNotifyManager
                                                //     .scheduleNotificationForLevelTwoSaturdayElevenAm();
                                                // await localNotifyManager
                                                //     .scheduleNotificationForLevelTwoWednesdaySevenPm();
                                                DocumentSnapshot
                                                    documentSnapshot =
                                                    await firestore
                                                        .collection('User')
                                                        .doc(userId)
                                                        .get();
                                                bool value = documentSnapshot
                                                    .get('replay_level');

                                                firestore
                                                    .collection('User')
                                                    .doc(userId)
                                                    .update({
                                                  'level_id': 0,
                                                  'level_1_popQuiz_id':
                                                      index + 1,
                                                  'previous_session_info':
                                                      'Level_2_setUp_page',
                                                  'account_balance': 0,
                                                  'need': 0,
                                                  'want': 0,
                                                  'quality_of_life': 0,
                                                  'pop_quiz_point_changed':
                                                      false,
                                                  if (value != true)
                                                    'last_level':
                                                        'Level_2_setUp_page',
                                                }).then((value) => Future.delayed(
                                                        Duration(
                                                            milliseconds: 500),
                                                        () => Get.offNamed(
                                                            '/Level2SetUp')));
                                              } else {
                                                firestore
                                                    .collection('User')
                                                    .doc(userId)
                                                    .update({
                                                  'level_id': index + 1,
                                                  'level_1_popQuiz_id':
                                                      index + 1,
                                                  'pop_quiz_point_changed':
                                                      false,
                                                });

                                                controller.nextPage(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    curve: Curves.easeIn);
                                              }
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: AllColors.blue,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    4.w)))),
                                            child: Text(
                                                'Tap To Move Next Question',
                                                style:
                                                    AllTextStyles.workSansSmall(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  color:
                                                      AllColors.extraDarkPurple,
                                                )))),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ));
                      });
                }
                //},
                ),
      ),
    );
  }

  _checkCorrectAnswer(
      String ans, StateSetter _setState, int i, String s, var document) {
    Color one = AllColors.green;
    Color two = AllColors.red;

    if (ans == s) {
      firestore.collection('User').doc(userId).set({
        'game_score': FieldValue.increment(5),
        'pop_quiz_point_changed': true
      }, SetOptions(merge: true));
    }

    _setState(() {
      optionSelect = i;
      print('option Select $i');
      if (document['id'] == 1) {
        firestore
            .collection('Pop_Quiz_Calculation')
            .doc('Level1Question1')
            .set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 2) {
        firestore
            .collection('Pop_Quiz_Calculation')
            .doc('Level1Question2')
            .set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 3) {
        firestore
            .collection('Pop_Quiz_Calculation')
            .doc('Level1Question3')
            .set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 4) {
        firestore
            .collection('Pop_Quiz_Calculation')
            .doc('Level1Question4')
            .set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 5) {
        firestore
            .collection('Pop_Quiz_Calculation')
            .doc('Level1Question5')
            .set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 6) {
        firestore
            .collection('Pop_Quiz_Calculation')
            .doc('Level1Question6')
            .set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }

      if (ans == 'a') {
        color1 = one;
        color2 = two;
      } else {
        color1 = two;
        color2 = one;
      }
    });
  }

  Widget options(
      {GestureTapCallback? onPressed,
      int? index,
      var document,
      Color? color,
      int? i,
      String? text}) {
    var questionId;
    questionId = document['id'] == 1
        ? 'Level1Question1'
        : document['id'] == 2
            ? 'Level1Question2'
            : document['id'] == 3
                ? 'Level1Question3'
                : document['id'] == 4
                    ? 'Level1Question4'
                    : document['id'] == 5
                        ? 'Level1Question5'
                        : 'Level1Question6';
    print('quesId $questionId');
    // return Padding(
    //     padding: EdgeInsets.only(top: i == 1 ? 3.h : 1.h),
    //     child: GestureDetector(
    //       onTap: onPressed,
    //       child: Container(
    //         alignment: Alignment.centerLeft,
    //         width: 70.w,
    //         height: 7.h,
    //         decoration: BoxDecoration(
    //             color: optionSelect == 0 ? AllColors.whiteLight2 : color,
    //             borderRadius: BorderRadius.circular(3.w)),
    //         child: SingleChildScrollView(
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
    //             child: Text(
    //               text.toString(),
    //               style: AllTextStyles.workSansSmall(
    //                   color: optionSelect != 0
    //                       ? Colors.white
    //                       : AllColors.extraDarkPurple,
    //                   fontSize: 14.sp,
    //                   fontWeight: FontWeight.w500),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ));
    return Padding(
        padding: EdgeInsets.only(top: i == 1 ? 3.h : 1.h, bottom: 1.h),
        child: Container(
          height: 7.h,
          width: 70.w,
          child: SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('Pop_Quiz_Calculation')
                    .doc(questionId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('It\'s Error!');
                  }
                  if (!snapshot.hasData)
                    return Container(
                      // decoration: boxDecoration,
                      child: Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.white),
                        ),
                      ),
                    );
                  print('total User ${snapshot.data!['ans_b_total_users']}');
                  return GestureDetector(
                    onTap: onPressed,
                    child: Align(
                      alignment: Alignment.center,
                      child: LinearPercentIndicator(
                        // animation: true,
                        lineHeight: 7.h,
                        width: 70.w,
                        // animationDuration: 1000,
                        percent: (snapshot.data![i == 1
                                ? 'ans_a_total_users'
                                : 'ans_b_total_users'] /
                            100),
                        barRadius: Radius.circular(3.w),
                        center: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: Text(
                                text.toString(),
                                style: AllTextStyles.workSansSmall(
                                    // color: optionSelect != 0
                                    //     ? Colors.white
                                    //     : AllColors.extraDarkPurple,
                                    color: AllColors.extraDarkPurple,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),

                        //linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor:
                            optionSelect == 0 ? AllColors.whiteLight2 : color,
                        backgroundColor: AllColors.whiteLight2,
                        // backgroundColor:
                        //     optionSelect == 0 ? AllColors.whiteLight2 : color,
                      ),
                    ),
                  );
                }),
          ),
        ));
  }
}

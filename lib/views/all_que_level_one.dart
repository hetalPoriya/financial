import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/background_widget.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/game_question_container.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/insight_widget.dart';
import 'package:financial/shareable_screens/level_summary_for_level1_and_level2.dart';
import 'package:financial/shareable_screens/level_summary_screen.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/models/que_model.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/level_one_pop_quiz.dart';
import 'package:financial/views/level_one_setUp_page.dart';
import 'package:financial/views/level_two_setUp_page.dart';
import 'package:financial/views/local_notify_manager.dart';

import 'package:financial/views/rate_us.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import '../utils/all_colors.dart';

class AllQueLevelOne extends StatefulWidget {
  const AllQueLevelOne({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelOneState createState() => _AllQueLevelOneState();
}

class _AllQueLevelOneState extends State<AllQueLevelOne> {

  bool? showCase;
  final userInfo = Get.put<UserInfoController>(UserInfoController());
  QueModel? queModel;
  List<QueModel> list = [];

  getAllData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Level_1").get();
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
   getLevelId().then((value) => getAllData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
        child: Container(
      width: 100.w,
      height: 100.h,
      decoration: boxDecoration,
      child: list.isEmpty
          ? Center(
              child: CircularProgressIndicator(backgroundColor: AllColors.blue))
          : StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('Level_1').orderBy('id').snapshots(),
              // stream: _userInfoController.querySnapshot,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('It\'s Error!');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: AllColors.blue),
                    );
                  default:
                    return PageView.builder(
                      itemCount: snapshot.data!.docs.length,
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (b) async {
                        flag1 = false;
                        flag2 = false;
                        flagForKnow = false;
                        DocumentSnapshot snapshot = await firestore
                            .collection('User')
                            .doc(userId)
                            .get();
                        if ((snapshot.data() as Map<String, dynamic>)
                                .containsKey("level_1_balance") ==
                            true) {
                          if (document['card_type'] == 'GameQuestion') {
                            updateValue = updateValue + 1;
                            storeValue.write('update', updateValue);
                            if (updateValue == 8) {
                              updateValue = 0;
                              storeValue.write('update', 0);
                              calculationForProgress(() {
                                Get.back();
                              });
                            }
                          }
                        }
                      },
                      itemBuilder: (context, index) {
                        document = snapshot.data!.docs[index];
                        return document['card_type'] == 'GameQuestion'
                            ? ShowCaseWidget(builder: Builder(builder: (_) {
                                return BackgroundWidget(
                                    level: level,
                                    document: document,
                                    container: StatefulBuilder(
                                        builder: (context, _setState) {
                                      return
                                          //GetBuilder<UserInfoController>(builder: (C)=>
                                          GameQuestionContainer(
                                        level: level,
                                        document: document,
                                        onPressed1: list[index].isSelected2 ==
                                                    true ||
                                                list[index].isSelected1 == true
                                            ? () {}
                                            : () async {
                                                _setState(() {
                                                  flag1 = true;
                                                });
                                                if (flag2 == false) {
                                                  list[index].isSelected1 =
                                                      true;
                                                  int qol1 = document[
                                                      'quality_of_life_1'];
                                                  int price = document[
                                                      'option_1_price'];
                                                  // balance = balance - price;
                                                  qualityOfLife =
                                                      qualityOfLife + qol1;
                                                  var category =
                                                      document['category'];
                                                  _optionSelect(
                                                      index,
                                                      qol1,
                                                      balance,
                                                      qualityOfLife,
                                                      snapshot,
                                                      document,
                                                      category,
                                                      price);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: AllStrings
                                                          .optionAlreadySelected);
                                                }
                                              },
                                        onPressed2: list[index].isSelected2 ==
                                                    true ||
                                                list[index].isSelected1 == true
                                            ? () {}
                                            : () async {
                                                _setState(() {
                                                  flag2 = true;
                                                });

                                                if (flag1 == false) {
                                                  list[index].isSelected2 =
                                                      true;
                                                  int price = document[
                                                      'option_2_price'];
                                                  int qol2 = document[
                                                      'quality_of_life_2'];
                                                  qualityOfLife =
                                                      qualityOfLife + qol2;
                                                  var category =
                                                      document['category'];
                                                  _optionSelect(
                                                      index,
                                                      qol2,
                                                      balance,
                                                      qualityOfLife,
                                                      snapshot,
                                                      document,
                                                      category,
                                                      price);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: AllStrings
                                                          .optionAlreadySelected);
                                                }
                                              },
                                        option1: document['option_1'],
                                        description: document['description'],
                                        option2: document['option_2'],
                                        textStyle1:
                                            AllTextStyles.gameQuestionOption(
                                          color: list[index].isSelected1 == true
                                              ? Colors.white
                                              : AllColors.yellow,
                                        ),
                                        textStyle2:
                                            AllTextStyles.gameQuestionOption(
                                                color:
                                                    list[index].isSelected2 ==
                                                            true
                                                        ? Colors.white
                                                        : AllColors.yellow),
                                        color1: list[index].isSelected1 == true
                                            ? AllColors.green
                                            : Colors.white,
                                        color2: list[index].isSelected2 == true
                                            ? AllColors.green
                                            : Colors.white,
                                      );
                                      //);
                                    }));
                              }))
                            : StatefulBuilder(builder: (context, _setState) {
                                return InsightWidget(
                                  level: level,
                                  document: document,
                                  description: document['description'],
                                  colorForContainer: flagForKnow
                                      ? AllColors.green
                                      : Colors.white,
                                  colorForText: flagForKnow
                                      ? Colors.white
                                      : AllColors.darkPink,
                                  onTap: () async {
                                    _setState(() {
                                      flagForKnow = true;
                                    });
                                    if (index ==
                                        snapshot.data!.docs.length - 1) {
                                      firestore
                                          .collection('User')
                                          .doc(userId)
                                          .update({
                                        'level_id': index + 1,
                                        'level_1_id': index + 1,
                                      });
                                      Future.delayed(
                                          Duration(seconds: 1),
                                          () => calculationForProgress(() {
                                                Get.back();
                                                _levelCompleteSummary();
                                              }));
                                    } else {
                                      firestore
                                          .collection('User')
                                          .doc(userId)
                                          .update({
                                        'level_id': index + 1,
                                        'level_1_id': index + 1,
                                      });
                                      controller.nextPage(
                                          duration: Duration(seconds: 1),
                                          curve: Curves.easeIn);
                                    }
                                  },
                                );
                              });
                      },
                    );
                }
              },
            ),
    ));
  }

  _optionSelect(int index, int qol2, int balance, int qualityOfLife, snapshot,
      document, category, int price) async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    balance = snap.get('account_balance');
    balance = balance - price;
    if (index == snapshot.data!.docs.length - 1) {
      firestore.collection('User').doc(userId).update({
        'level_id': index + 1,
        'level_1_id': index + 1,
      });
      Future.delayed(
          Duration(milliseconds: 500),
          () => calculationForProgress(() {
                Get.back();
                _levelCompleteSummary();
              }));
    }
    if (balance >= 0 || balance == 0) {
      firestore.collection('User').doc(userId).update({
        'account_balance': balance,
        'quality_of_life': FieldValue.increment(qol2),
        'game_score': gameScore + balance + qualityOfLife,
        'level_id': index + 1,
        'level_1_id': index + 1,
        'need': category == 'Need'
            ? FieldValue.increment(price)
            : FieldValue.increment(0),
        'want': category == 'Want'
            ? FieldValue.increment(price)
            : FieldValue.increment(0),
      });
      controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
    } else {
      setState(() {
        scroll = false;
      });

      //_showDialogForRestartLevel(context);
      _showDialogForRestartLevel();
    }
  }

  _showDialogForRestartLevel() {
    Get.defaultDialog(
      title: AllStrings.dialogForResLev1Text1,
      content: Text(
        AllStrings.dialogForResLev1Text2,
        style: AllTextStyles.dialogStyleSmall(),
        textAlign: TextAlign.center,
      ),
      titlePadding: EdgeInsets.all(4.w),
      contentPadding: EdgeInsets.all(4.w),
      barrierDismissible: false,
      onWillPop: () {
        return Future.value(false);
      },
      backgroundColor: AllColors.darkPurple,
      titleStyle: AllTextStyles.dialogStyleMedium(),
      confirm: restartOrOkButton(
        'Restart level',
        () {
          firestore.collection('User').doc(userId).update({
            'account_balance': 200,
            'level_id': 0,
            'need': 0,
            'quality_of_life': 0,
            'want': 0,
            'previous_session_info': 'Level_1_setUp_page'
          }).then((value) {
            Get.off(
              () => LevelOneSetUpPage(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
            );
          });
        },
      ),
    );
  }

  _levelCompleteSummary() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    int need = documentSnapshot['need'];
    int want = documentSnapshot['want'];
    int accountBalance = documentSnapshot['account_balance'];
    int qol = documentSnapshot['quality_of_life'];
    Color color = Colors.white;

    Map<String, double> dataMap = {
      AllStrings.spentOnNeed: ((need / 200) * 100).floor().toDouble(),
      AllStrings.spentOnWant: ((want / 200) * 100).floor().toDouble(),
      AllStrings.savings: ((accountBalance / 200) * 100).floor().toDouble(),
    };

    return Get.dialog(
      WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: StatefulBuilder(
          builder: (context, _setState) {
            return LevelSummaryScreen(
              container: StatefulBuilder(builder: (context, _setState) {
                return LevelSummaryForLevel1And2(
                  widget: buttonStyle(
                    color,
                    AllStrings.playNextLevel,
                    color == AllColors.green
                        ? () {}
                        : () async {
                            _setState(() {
                              color = AllColors.green;
                            });
                            bool value = documentSnapshot.get('replay_level');
                            level = documentSnapshot.get('last_level');
                            level = level.toString().substring(6, 7);
                            int lev = int.parse(level);
                            if (lev == 1 && value == true) {
                              firestore
                                  .collection('User')
                                  .doc(userId)
                                  .update({'replay_level': false});
                            }
                            Get.offAll(() => RateUs(onSubmit: () {
                                  firestore.collection('Feedback').doc().set({
                                    'user_id': userInfo.userId,
                                    'level_name': userInfo.level,
                                    'rating': userInfo.star,
                                    'feedback':
                                        userInfo.feedbackCon.text.toString()
                                  }).then(
                                    (v) => onSubmit(value, accountBalance, qol),
                                  );
                                }));
                          },
                  ),

                  dataMap: dataMap,
                  // onPressed: color == AllColors.green
                  //     ? () {}
                  //     : () async {
                  //         _setState(() {
                  //           color = AllColors.green;
                  //         });
                  //         bool value = documentSnapshot.get('replay_level');
                  //         level = documentSnapshot.get('last_level');
                  //         level = level.toString().substring(6, 7);
                  //         int lev = int.parse(level);
                  //         if (lev == 1 && value == true) {
                  //           firestore
                  //               .collection('User')
                  //               .doc(userId)
                  //               .update({'replay_level': false});
                  //         }
                  //         // firestore
                  //         //     .collection('User')
                  //         //     .doc(userId)
                  //         //     .update({
                  //         //   if (value != true)'last_level': 'Level_2_setUp_page',
                  //         //   'previous_session_info': 'Level_2_setUp_page',
                  //         // });
                  //         Get.offAll(() => RateUs(onSubmit: () {
                  //               firestore.collection('Feedback').doc().set({
                  //                 'user_id': userInfo.userId,
                  //                 'level_name': userInfo.level,
                  //                 'rating': userInfo.star,
                  //                 'feedback':
                  //                     userInfo.feedbackCon.text.toString()
                  //               }).then(
                  //                 (v) => onSubmit(value, accountBalance, qol),
                  //               );
                  //             }));
                  //       },
                  paddingTop: 0.h,
                  text1: '',
                );
                // return LevelSummary(
                //   need: need,
                //   want: want,
                //   accountBalance: accountBalance,
                //   color: color,
                //   onPressed: color == AllColors.green
                //       ? () {}
                //       : () async {
                //           _setState(() {
                //             color = AllColors.green;
                //           });
                //           bool value = documentSnapshot.get('replay_level');
                //           level = documentSnapshot.get('last_level');
                //           level = level.toString().substring(6, 7);
                //           int lev = int.parse(level);
                //           if (lev == 1 && value == true) {
                //             firestore
                //                 .collection('User')
                //                 .doc(userId)
                //                 .update({'replay_level': false});
                //           }
                //           // firestore
                //           //     .collection('User')
                //           //     .doc(userId)
                //           //     .update({
                //           //   if (value != true)'last_level': 'Level_2_setUp_page',
                //           //   'previous_session_info': 'Level_2_setUp_page',
                //           // });
                //           Get.offAll(() => RateUs(onSubmit: () {
                //                 firestore.collection('Feedback').doc().set({
                //                   'user_id': userInfo.userId,
                //                   'level_name': userInfo.level,
                //                   'rating': userInfo.star,
                //                   'feedback':
                //                       userInfo.feedbackCon.text.toString()
                //                 }).then(
                //                   (v) => onSubmit(value, accountBalance, qol),
                //                 );
                //               }, onSkip: () {
                //                 onSubmit(value, accountBalance, qol);
                //               }));
                //         },
                // );
              }),
              document: document,
              level: level,
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  onSubmit(bool value, int accountBalance, int qol) => popQuizDialog(() {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_1_Pop_Quiz',
          'level_id': 0,
          if (value != true) 'last_level': 'Level_1_Pop_Quiz',
        });
        Future.delayed(
            Duration(seconds: 1),
            () => Get.off(
                  () => LevelOnePopQuiz(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.downToUp,
                ));
      }, () async {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_2_setUp_page',
          'level_id': 0,
          if (value != true) 'last_level': 'Level_2_setUp_page',
          'level_1_balance': accountBalance,
          'level_1_qol': qol
        });
        await localNotifyManager.configureLocalTimeZone();
        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(1);
        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(7);
        await localNotifyManager
            .scheduleNotificationForLevelTwoSaturdayElevenAm();
        await localNotifyManager
            .scheduleNotificationForLevelTwoWednesdaySevenPm();
        Future.delayed(
            Duration(seconds: 1),
            () => Get.off(
                  () => LevelTwoSetUpPage(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.downToUp,
                ));
      });
}



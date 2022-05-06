import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/controllers/UserInfoController.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/LevelThreeSetUpPage.dart';
import 'package:financial/views/LevelTwoSetUpPage.dart';
import 'package:financial/views/PopQuiz.dart';
import 'package:financial/views/RateUs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'LocalNotifyManager.dart';

class AllQueLevelTwo extends StatefulWidget {
  const AllQueLevelTwo({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelTwoState createState() => _AllQueLevelTwoState();
}

class _AllQueLevelTwoState extends State<AllQueLevelTwo> {
  int levelId = 0;
  String level = '';
  int gameScore = 0;
  int balance = 0;
  int qualityOfLife = 0;
  var document;
  var userId;

  //get bill data
  int billPayment = 0;
  int forPlan1 = 0;
  int forPlan2 = 0;
  int forPlan3 = 0;
  int forPlan4 = 0;

  //page controller
  PageController controller = PageController();

  //for indexing
  int currentIndex = 0;

  //for option selection
  bool flag1 = false;
  bool flag2 = false;
  bool flagForKnow = false;
  bool scroll = true;
  List<int> payArray = [];
  Color color = Colors.white;
  final storeValue = GetStorage();

  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  int updateValue = 0;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // LocalNotifyManager localNotifyManager = LocalNotifyManager.init();
  Future<QueModel?> getLevelId() async {
    userId = storeValue.read('uId');
    updateValue = storeValue.read('update');
    forPlan1 = storeValue.read('plan1')!;
    forPlan2 = storeValue.read('plan2')!;
    forPlan3 = storeValue.read('plan3')!;
    forPlan4 = storeValue.read('plan4')!;

    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    levelId = snapshot.get('level_id');
    gameScore = snapshot.get('game_score');
    balance = snapshot.get('account_balance');
    qualityOfLife = snapshot.get('quality_of_life');
    billPayment = snapshot.get('bill_payment');
    controller = PageController(initialPage: levelId);

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Level_2").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      queModel = QueModel();
      queModel?.id = a['id'];
      setState(() {
        list.add(queModel!);
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getLevelId().then((value) {
      if (levelId == 0)
        Future.delayed(Duration(milliseconds: 10), () => _salaryCredited());
    });
  }

  final userInfo = Get.put<UserInfoController>(UserInfoController());

  @override
  Widget build(BuildContext context) {
    color = Colors.white;
    return SafeArea(
        child: Container(
      width: 100.w,
      height: 100.h,
      decoration: boxDecoration,
      child: list.isEmpty
          ? Center(
              child: CircularProgressIndicator(backgroundColor: AllColors.blue))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Level_2')
                  .orderBy('id')
                  .snapshots(),
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
                        onPageChanged: (value) async {
                          flag1 = false;
                          flag2 = false;
                          flagForKnow = false;
                          color = Colors.white;

                          DocumentSnapshot snapshot = await firestore
                              .collection('User')
                              .doc(userId)
                              .get();
                          if ((snapshot.data() as Map<String, dynamic>)
                              .containsKey("level_1_balance")) {
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

                          if (document['card_type'] == 'GameQuestion') {
                            if ((document['week'] == 3 ||
                                    document['week'] % 4 == 3) &&
                                document['week'] != 0) _billPayment();

                            if ((document['week'] % 4 == 1) &&
                                document['week'] != 0) _salaryCredited();
                          }
                        },
                        itemBuilder: (context, index) {
                          currentIndex = index;
                          document = snapshot.data!.docs[index];
                          levelId = index;
                          return document['card_type'] == 'GameQuestion'
                              ? BackgroundWidget(
                                  level: level,
                                  document: document,
                                  container: StatefulBuilder(
                                    builder: (context, _setState) {
                                      return GameQuestionContainer(
                                        level: level,
                                        document: document,
                                        description: document['description'],
                                        option1: document['option_1'],
                                        option2: document['option_2'],
                                        color1: list[index].isSelected1 == true
                                            ? AllColors.green
                                            : Colors.white,
                                        color2: list[index].isSelected2 == true
                                            ? AllColors.green
                                            : Colors.white,
                                        textStyle1:
                                            AllTextStyles.gameQuestionOption(
                                                color:
                                                    list[index].isSelected1 ==
                                                            true
                                                        ? Colors.white
                                                        : AllColors.yellow),
                                        textStyle2:
                                            AllTextStyles.gameQuestionOption(
                                                color:
                                                    list[index].isSelected2 ==
                                                            true
                                                        ? Colors.white
                                                        : AllColors.yellow),
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
                                                  balance = ((balance -
                                                          document[
                                                              'option_1_price'])
                                                      as int?)!;
                                                  qualityOfLife =
                                                      qualityOfLife + qol1;
                                                  var category =
                                                      document['category'];
                                                  int price = document[
                                                      'option_1_price'];
                                                  _optionSelect(
                                                      balance,
                                                      gameScore,
                                                      qualityOfLife,
                                                      qol1,
                                                      index,
                                                      snapshot,
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
                                                  int qol2 = document[
                                                      'quality_of_life_2'];
                                                  balance = ((balance -
                                                          document[
                                                              'option_2_price'])
                                                      as int?)!;
                                                  qualityOfLife =
                                                      qualityOfLife + qol2;
                                                  var category =
                                                      document['category'];
                                                  int price = document[
                                                      'option_2_price'];
                                                  _optionSelect(
                                                      balance,
                                                      gameScore,
                                                      qualityOfLife,
                                                      qol2,
                                                      index,
                                                      snapshot,
                                                      category,
                                                      price);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: AllStrings
                                                          .optionAlreadySelected);
                                                }
                                              },
                                      );
                                    },
                                  ),
                                )
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
                                        color = AllColors.green;
                                      });
                                      if (index ==
                                          snapshot.data!.docs.length - 1) {
                                        firestore
                                            .collection('User')
                                            .doc(userId)
                                            .update({
                                          'level_id': index + 1,
                                          'level_2_id': index + 1,
                                        }).then((value) => Future.delayed(
                                                Duration(seconds: 1),
                                                () =>
                                                    calculationForProgress(() {
                                                      Get.back();
                                                      _levelCompleteSummary();
                                                    })));
                                      } else {
                                        firestore
                                            .collection('User')
                                            .doc(userId)
                                            .update({
                                          'level_id': index + 1,
                                          'level_2_id': index + 1,
                                        });
                                        controller.nextPage(
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeIn);
                                      }
                                    },
                                  );
                                });
                        });
                }
              },
            ),
    ));
  }

  _billPayment() {
    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: BackgroundWidget(
                level: level,
                document: document,
                container: StatefulBuilder(
                  builder: (context, _setState) {
                    return BillPaymentWidget(
                      billPayment: billPayment.toString(),
                      forPlan1: forPlan1.toString(),
                      forPlan2: forPlan2.toString(),
                      forPlan3: forPlan3.toString(),
                      forPlan4: forPlan4.toString(),
                      text1: 'Rent ',
                      text2: 'TV & Internet ',
                      text3: 'Groceries ',
                      text4: 'Cellphone ',
                      color: color,
                      onPressed: color == AllColors.green
                          ? () {}
                          : () {
                              _setState(() {
                                color = AllColors.green;
                              });
                              payArray.add(currentIndex);
                              balance = balance - billPayment;
                              if (balance < 0) {
                                Future.delayed(
                                  Duration(milliseconds: 500),
                                  () => _showDialogForRestartLevel(),
                                );
                              } else {
                                firestore
                                    .collection('User')
                                    .doc(userId)
                                    .update({
                                  'account_balance': balance,
                                  'game_score':
                                      gameScore + balance + qualityOfLife,
                                });
                                Future.delayed(
                                    Duration(seconds: 1), () => Get.back());
                              }
                            },
                    );
                  },
                )),
          );
        });
  }

  _salaryCredited() {
    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: BackgroundWidget(
                level: level,
                document: levelId == 0 ? 'GameQuestion' : document,
                container: StatefulBuilder(
                  builder: (context, _setState) {
                    return SalaryCreditedWidget(
                      color: color,
                      onPressed: color == AllColors.green
                          ? () {}
                          : () {
                              _setState(() {
                                color = AllColors.green;
                              });
                              balance = balance + 1000;
                              firestore.collection('User').doc(userId).update({
                                'account_balance': balance,
                                'game_score':
                                    gameScore + balance + qualityOfLife,
                              });
                              Future.delayed(
                                  Duration(seconds: 1), () => Get.back());
                            },
                    );
                  },
                )),
          );
        });
  }

  _showDialogForRestartLevel() {
    restartLevelDialog(
      () {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_2_setUp_page',
          'bill_payment': 0,
          'level_id': 0,
          'credit_card_balance': 0,
          'credit_card_bill': 0,
          'credit_score': 0,
          'payable_bill': 0,
          'quality_of_life': 0,
          'score': 0
        });
        Get.off(
          () => LevelTwoSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      },
    );
  }

  _optionSelect(
      int balance,
      int gameScore,
      int qualityOfLife,
      int qol2,
      int index,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      category,
      int price) async {
    if (index == snapshot.data!.docs.length - 1) {
      firestore.collection('User').doc(userId).update({
        'level_id': index + 1,
        'level_2_id': index + 1,
      }).then((value) => Future.delayed(
          Duration(seconds: 1),
          () => calculationForProgress(() {
                Get.back();
                _levelCompleteSummary();
              })));
    }
    if (balance >= 0) {
      firestore.collection('User').doc(userId).update({
        'account_balance': balance,
        'quality_of_life': FieldValue.increment(qol2),
        'game_score': gameScore + balance + qualityOfLife,
        'level_id': index + 1,
        'level_2_id': index + 1,
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
      _showDialogForRestartLevel();
    }
  }

  _levelCompleteSummary() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    int accountBalance = documentSnapshot['account_balance'];
    int need = documentSnapshot['need'];
    int want = documentSnapshot['want'];
    int bill = documentSnapshot['bill_payment'];
     Color color = Colors.white;

    Map<String, double> dataMap = {
      AllStrings.billsPaid: (((bill * 6) / 6000) * 100).floor().toDouble(),
      AllStrings.spentOnNeed: ((need / 6000) * 100).floor().toDouble(),
      AllStrings.spentOnWant: ((want / 6000) * 100).floor().toDouble(),
      AllStrings.savings: ((accountBalance / 6000) * 100).floor().toDouble(),
    };

    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: accountBalance >= 1200
                ? LevelSummaryScreen(
                    container: StatefulBuilder(
                      builder: (context,_setState) {
                        return LevelSummaryForLevel1And2(
                            dataMap: dataMap,
                            widget: buttonStyle(color, AllStrings.playNextLevel,  color == AllColors.green
                                ? () {}
                                : () {
                              _setState(() {
                                color = AllColors.green;
                              });

                              Future.delayed(
                                Duration(seconds: 2),
                                    () => Get.offAll(() => RateUs(onSubmit: () {
                                  firestore
                                      .collection('Feedback')
                                      .doc()
                                      .set({
                                    'user_id': userInfo.userId,
                                    'level_name': userInfo.level,
                                    'rating': userInfo.star,
                                    'feedback': userInfo.feedbackCon.text
                                        .toString(),
                                  }).then(
                                        (value) => _playLevelOrPopQuiz(),
                                  );
                                })),
                              );
                              //}
                            },),
                            //color: color,
                            text1: 'Salary Earned : ',
                            text2: '\$' + 6000.toString(),
                            paddingTop: 1.h,
                           // onPressed: () {}
                            );
                      }
                    ),
                    level: level,
                    document: document)
                : BackgroundWidget(
                    level: level,
                    document: document,
                    container: StatefulBuilder(
                      builder: (context,_setState) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            LevelSummaryForLevel1And2(
                                dataMap: dataMap,
                                completeText: AllStrings.level2LosingText,
                                //color: color,
                              widget: buttonStyle(color, AllStrings.playAgain,  () {
                                _setState(() {
                                  color = AllColors.green;
                                });
                                bool value = documentSnapshot.get('replay_level');
                                documentSnapshot.get('account_balance');
                                Future.delayed(Duration(seconds: 1), () {
                                  firestore.collection('User').doc(userId).update({
                                    'previous_session_info': 'Level_2_setUp_page',
                                    if (value != true)
                                      'last_level': 'Level_2_setUp_page',
                                  }).then((value) {
                                    Get.offNamed('/Level2SetUp');
                                  });
                                });
                              },),
                                text1: 'Salary Earned : ',
                                text2: '\$' + 6000.toString(),
                                paddingTop: 1.h,
                               // onPressed: () {}
                                ),
                          ],
                        );
                      }
                    ),
                  ),
          );
        });
  }

  // summary(DocumentSnapshot<Object?> documentSnapshot) {
  //   int accountBalance = documentSnapshot['account_balance'];
  //   int need = documentSnapshot['need'];
  //   int want = documentSnapshot['want'];
  //   int bill = documentSnapshot['bill_payment'];
  //   Color color = Colors.white;
  //
  //   return Container(
  //     alignment: Alignment.center,
  //     height: 56.h,
  //     width: 80.w,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(
  //           8.w,
  //         ),
  //         color: AllColors.lightBlue),
  //     child: SingleChildScrollView(child: StatefulBuilder(
  //       builder: (contetx, _setState) {
  //         return Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             accountBalance >= 1200
  //                 ? normalText(
  //                     AllStrings.levelCompleteText,
  //                   )
  //                 : normalText(
  //                     'Oops! You haven\’t managed to achieve your savings goal of 20%. Please try again! ',
  //                   ),
  //             richText('Salary Earned : ', '\$' + 6000.toString(), 2.h),
  //             richText('Bills Paid : ',
  //                 '${(((bill * 6) / 6000) * 100).floor()}' + '%', 1.h),
  //             richText('Spend on Needs : ',
  //                 '${((need / 6000) * 100).floor()}' + '%', 1.h),
  //             richText('Spend on Wants : ',
  //                 '${((want / 6000) * 100).floor()}' + '%', 1.h),
  //             richText('Money Saved : ',
  //                 '${((accountBalance / 6000) * 100).floor()}' + '%', 1.h),
  //             accountBalance >= 1200
  //                 ? buttonStyle(
  //                     color,
  //                     AllStrings.playNextLevel,
  //                     color == AllColors.green
  //                         ? () {}
  //                         : () {
  //                             _setState(() {
  //                               color = AllColors.green;
  //                             });
  //
  //                             Future.delayed(
  //                               Duration(seconds: 2),
  //                               () => Get.offAll(() => RateUs(onSubmit: () {
  //                                     firestore
  //                                         .collection('Feedback')
  //                                         .doc()
  //                                         .set({
  //                                       'user_id': userInfo.userId,
  //                                       'level_name': userInfo.level,
  //                                       'rating': userInfo.star,
  //                                       'feedback': userInfo.feedbackCon.text
  //                                           .toString(),
  //                                     }).then(
  //                                       (value) => _playLevelOrPopQuiz(),
  //                                     );
  //                                   })),
  //                             );
  //                             //}
  //                           },
  //                   )
  //                 : buttonStyle(
  //                     color,
  //                     'Try Again',
  //                     () {
  //                       _setState(() {
  //                         color = AllColors.green;
  //                       });
  //                       bool value = documentSnapshot.get('replay_level');
  //                       documentSnapshot.get('account_balance');
  //                       Future.delayed(Duration(seconds: 1), () {
  //                         firestore.collection('User').doc(userId).update({
  //                           'previous_session_info': 'Level_2_setUp_page',
  //                           if (value != true)
  //                             'last_level': 'Level_2_setUp_page',
  //                         }).then((value) {
  //                           Get.offNamed('/Level2SetUp');
  //                         });
  //                       });
  //                     },
  //                   ),
  //             SizedBox(
  //               height: 2.h,
  //             )
  //           ],
  //         );
  //       },
  //     )),
  //   );
  // }

  _playLevelOrPopQuiz() async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    int bal = snap.get('account_balance');
    int qol = snap.get('quality_of_life');
    return popQuizDialog(
      () async {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        var userId = storeValue.read('uId');
        DocumentSnapshot snap =
            await firestore.collection('User').doc(userId).get();
        bool value = snap.get('replay_level');
        level = snap.get('last_level');
        level = level.toString().substring(6, 7);
        int lev = int.parse(level);
        if (lev == 2 && value == true) {
          firestore
              .collection('User')
              .doc(userId)
              .update({'replay_level': false});
        }
        Future.delayed(Duration(seconds: 2), () {
          FirebaseFirestore.instance.collection('User').doc(userId).update({
            'previous_session_info': 'Level_2_Pop_Quiz',
            'level_id': 0,
            if (value != true) 'last_level': 'Level_2_Pop_Quiz',
          });
          Get.off(
            () => PopQuiz(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          );
        });
      },
      () async {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        var userId = storeValue.read('uId');
        DocumentSnapshot snap =
            await firestore.collection('User').doc(userId).get();
        bool value = snap.get('replay_level');
        level = snap.get('last_level');
        level = level.toString().substring(6, 7);
        int lev = int.parse(level);
        if (lev == 2 && value == true) {
          firestore
              .collection('User')
              .doc(userId)
              .update({'replay_level': false});
        }
        // await flutterLocalNotificationsPlugin.cancel(22);
        // await flutterLocalNotificationsPlugin.repeatNotificationLevel3();
        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(2);
        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(8);
        await localNotifyManager
            .scheduleNotificationForLevelThreeSaturdayElevenAm();
        await localNotifyManager
            .scheduleNotificationForLevelThreeWednesdaySevenPm();
        Future.delayed(Duration(seconds: 2), () {
          FirebaseFirestore.instance.collection('User').doc(userId).update({
            'previous_session_info': 'Level_3_setUp_page',
            if (value != true) 'last_level': 'Level_3_setUp_page',
            'level_2_balance': bal,
            'level_2_qol': qol
          });
          Get.off(
            () => LevelThreeSetUpPage(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          );
        });
      },
    );
  }
}

class LevelSummary extends StatelessWidget {
  final int need;
  final int want;
  final int bill;
  final int accountBalance;
  final Color color;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;

  const LevelSummary(
      {Key? key,
      required this.need,
      required this.want,
      required this.bill,
      required this.accountBalance,
      required this.color,
      required this.onPressed1,
      required this.onPressed2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 56.h,
      width: 80.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.w,
          ),
          color: AllColors.lightBlue),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            accountBalance >= 1200
                ? normalText(
                    AllStrings.levelCompleteText,
                  )
                : normalText(AllStrings.level2LosingText),
            richText(AllStrings.salaryEarned, '\$' + 6000.toString(), 2.h),
            richText(AllStrings.billsPaid,
                '${(((bill * 6) / 6000) * 100).floor()}' + '%', 1.h),
            richText(AllStrings.spentOnNeed,
                '${((need / 6000) * 100).floor()}' + '%', 1.h),
            richText(AllStrings.spentOnWant,
                '${((want / 6000) * 100).floor()}' + '%', 1.h),
            richText(AllStrings.moneySaved,
                '${((accountBalance / 6000) * 100).floor()}' + '%', 1.h),
            accountBalance >= 1200
                ? buttonStyle(color, AllStrings.playNextLevel, onPressed1)
                : buttonStyle(color, AllStrings.tryAgain, onPressed2),
            SizedBox(
              height: 2.h,
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:financial/ReusableScreen/CommanClass.dart';
// import 'package:financial/ReusableScreen/GlobleVariable.dart';
// import 'package:financial/controllers/UserInfoController.dart';
// import 'package:financial/utils/AllColors.dart';
// import 'package:financial/utils/AllStrings.dart';
// import 'package:financial/utils/AllTextStyle.dart';
// import 'package:financial/views/LevelThreeSetUpPage.dart';
// import 'package:financial/views/LevelTwoSetUpPage.dart';
// import 'package:financial/views/PopQuiz.dart';
// import 'package:financial/views/RateUs.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// import 'LocalNotifyManager.dart';
//
// class AllQueLevelTwo extends StatefulWidget {
//   const AllQueLevelTwo({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _AllQueLevelTwoState createState() => _AllQueLevelTwoState();
// }
//
// class _AllQueLevelTwoState extends State<AllQueLevelTwo> {
//
//   int levelId = 0;
//   var document;
//   PageController controller = PageController();
//
//   final userInfo = Get.put<UserInfoController>(UserInfoController());
//
//   getId() async {
//     DocumentSnapshot snapshot =
//         await firestore.collection('User').doc(userInfo.userId).get();
//     levelId = snapshot.get('level_id');
//     controller = PageController(initialPage: levelId);
//     QuerySnapshot querySnapshot = await firestore.collection('Level_2').get();
//     userInfo.getLevelIndex(querySnapshot);
//     userInfo.update();
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getId().then((value) {
//       if (levelId == 0)
//         Future.delayed(Duration(milliseconds: 10), () => _salaryCredited());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     userInfo.color = Colors.white;
//     return SafeArea(
//         child: Container(
//       width: 100.w,
//       height: 100.h,
//       decoration: boxDecoration,
//       child:userInfo.list.isEmpty ? Center(child: CircularProgressIndicator()) : StreamBuilder<QuerySnapshot>(
//         stream: firestore.collection('Level_2').orderBy('id').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('It\'s Error!');
//           }
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(
//                 child:
//                     CircularProgressIndicator(backgroundColor: AllColors.blue),
//               );
//             default:
//               return PageView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   controller: controller,
//                   scrollDirection: Axis.vertical,
//                   physics: NeverScrollableScrollPhysics(),
//                   onPageChanged: (value) async {
//                     userInfo.flag1 = false;
//                     userInfo.flag2 = false;
//                     userInfo.flagForKnow = false;
//                     userInfo.color = Colors.white;
//                     userInfo.update();
//                     DocumentSnapshot snapshot = await firestore
//                         .collection('User')
//                         .doc(userInfo.userId)
//                         .get();
//                     if ((snapshot.data() as Map<String, dynamic>)
//                         .containsKey("level_1_balance")) {
//                       if (document['card_type'] == 'GameQuestion') {
//                         userInfo.updateValue = userInfo.updateValue + 1;
//                         userInfo.getCredential
//                             .write('update', userInfo.updateValue);
//                         if (userInfo.updateValue == 8) {
//                           userInfo.updateValue = 0;
//                           userInfo.getCredential.write('update', 0);
//                           userInfo.update();
//                           calculationForProgress(() {
//                             Get.back();
//                           });
//                         }
//                         userInfo.update();
//                       }
//                     }
//
//                     if (document['card_type'] == 'GameQuestion') {
//                       if ((document['week'] == 3 ||
//                               document['week'] % 4 == 3) &&
//                           document['week'] != 0) _billPayment();
//
//                       if ((document['week'] % 4 == 1) && document['week'] != 0)
//                         _salaryCredited();
//                     }
//                   },
//                   itemBuilder: (context, index) {
//                     document = snapshot.data!.docs[index];
//                     levelId = index;
//                     print('CARD ${document['card_type']}');
//                     return document['card_type'] == 'GameQuestion'
//                         ? BackgroundWidget(
//                             level: userInfo.level,
//                             document: document,
//                             container: GetBuilder<UserInfoController>(
//                               builder: (userInfo) {
//                                 return GameQuestionContainer(
//                                   level: userInfo.level,
//                                   document: document,
//                                   description: document['description'],
//                                   option1: document['option_1'],
//                                   option2: document['option_2'],
//                                   color1: userInfo.list[index].isSelected1 == true
//                                       ? AllColors.green
//                                       : Colors.white,
//                                   color2: userInfo.list[index].isSelected2 == true
//                                       ? AllColors.green
//                                       : Colors.white,
//                                   textStyle1: AllTextStyles.gameQuestionOption(
//                                       color: userInfo.list[index].isSelected1 == true
//                                           ? Colors.white
//                                           : AllColors.yellow),
//                                   textStyle2: AllTextStyles.gameQuestionOption(
//                                       color: userInfo.list[index].isSelected2 == true
//                                           ? Colors.white
//                                           : AllColors.yellow),
//                                   onPressed1: userInfo.list[index].isSelected1 == true ||
//                                       userInfo.list[index].isSelected2 == true
//                                       ? () {}
//                                       : () async {
//                                           userInfo.flag1 = true;
//                                           userInfo.update();
//
//                                           if (userInfo.flag2 == false) {
//                                             userInfo.list[index].isSelected1 = true;
//                                             int qol1 =
//                                                 document['quality_of_life_1'];
//                                             userInfo.balance = ((userInfo
//                                                         .balance -
//                                                     document['option_1_price'])
//                                                 as int?)!;
//                                             userInfo.qualityOfLife =
//                                                 userInfo.qualityOfLife + qol1;
//                                             var category = document['category'];
//                                             int price =
//                                                 document['option_1_price'];
//                                             _optionSelect(
//                                                 userInfo.balance,
//                                                 userInfo.gameScore,
//                                                 userInfo.qualityOfLife,
//                                                 qol1,
//                                                 index,
//                                                 snapshot,
//                                                 category,
//                                                 price);
//                                           } else {
//                                             Fluttertoast.showToast(
//                                                 msg: AllStrings
//                                                     .optionAlreadySelected);
//                                           }
//                                         },
//                                   onPressed2: userInfo.list[index].isSelected1 == true ||
//                                       userInfo.list[index].isSelected2 == true
//                                       ? () {}
//                                       : () async {
//                                           userInfo.flag2 = true;
//                                           userInfo.update();
//
//                                           if (userInfo.flag1 == false) {
//                                             userInfo.list[index].isSelected2 = true;
//                                             int qol2 =
//                                                 document['quality_of_life_2'];
//                                             userInfo.balance = ((userInfo
//                                                         .balance -
//                                                     document['option_2_price'])
//                                                 as int?)!;
//                                             userInfo.qualityOfLife =
//                                                 userInfo.qualityOfLife + qol2;
//                                             var category = document['category'];
//                                             int price =
//                                                 document['option_2_price'];
//                                             _optionSelect(
//                                                 userInfo.balance,
//                                                 userInfo.gameScore,
//                                                 userInfo.qualityOfLife,
//                                                 qol2,
//                                                 index,
//                                                 snapshot,
//                                                 category,
//                                                 price);
//                                           } else {
//                                             Fluttertoast.showToast(
//                                                 msg: AllStrings
//                                                     .optionAlreadySelected);
//                                           }
//                                         },
//                                 );
//                               },
//                             ))
//                         : GetBuilder<UserInfoController>(builder: (userInfo) {
//                             return InsightWidget(
//                               level: userInfo.level,
//                               document: document,
//                               description: document['description'],
//                               colorForContainer: userInfo.flagForKnow
//                                   ? AllColors.green
//                                   : Colors.white,
//                               colorForText: userInfo.flagForKnow
//                                   ? Colors.white
//                                   : AllColors.darkPink,
//                               onTap: () async {
//                                 userInfo.flagForKnow = true;
//                                 userInfo.update();
//                                 //color = AllColors.green;
//
//                                 if (index == snapshot.data!.docs.length - 1) {
//                                   firestore
//                                       .collection('User')
//                                       .doc(userInfo.userId)
//                                       .update({
//                                     'level_id': index + 1,
//                                     'level_2_id': index + 1,
//                                   }).then((value) => Future.delayed(
//                                           Duration(seconds: 1),
//                                           () => calculationForProgress(() {
//                                                 Get.back();
//                                                 _levelCompleteSummary();
//                                               })));
//                                 } else {
//                                   firestore
//                                       .collection('User')
//                                       .doc(userInfo.userId)
//                                       .update({
//                                     'level_id': index + 1,
//                                     'level_2_id': index + 1,
//                                   });
//                                   controller.nextPage(
//                                       duration: Duration(seconds: 1),
//                                       curve: Curves.easeIn);
//                                 }
//                               },
//                             );
//                           });
//                   });
//           }
//         },
//       ),
//     ));
//   }
//
//   _billPayment() {
//     userInfo.color = Colors.white;
//     userInfo.update();
//     return Get.generalDialog(
//         barrierDismissible: false,
//         pageBuilder: (context, animation, sAnimation) {
//           return WillPopScope(
//             onWillPop: () {
//               return Future.value(false);
//             },
//             child: BackgroundWidget(
//                 level: userInfo.level,
//                 document: document,
//                 container: GetBuilder<UserInfoController>(
//                   builder: (userInfo) {
//                     return BillPaymentWidget(
//                       billPayment: userInfo.billPayment.toString(),
//                       forPlan1: forPlan1.toString(),
//                       forPlan2: forPlan2.toString(),
//                       forPlan3: forPlan3.toString(),
//                       forPlan4: forPlan4.toString(),
//                       text1: 'Rent ',
//                       text2: 'TV & Internet ',
//                       text3: 'Groceries ',
//                       text4: 'Cellphone ',
//                       color: userInfo.color,
//                       onPressed: userInfo.color == AllColors.green
//                           ? () {}
//                           : () {
//                               userInfo.color = AllColors.green;
//                               userInfo.update();
//                               userInfo.balance =
//                                   userInfo.balance - userInfo.billPayment;
//                               if (userInfo.balance < 0) {
//                                 Future.delayed(
//                                   Duration(milliseconds: 500),
//                                   () => _showDialogForRestartLevel(),
//                                 );
//                               } else {
//                                 firestore
//                                     .collection('User')
//                                     .doc(userInfo.userId)
//                                     .update({
//                                   'account_balance': userInfo.balance,
//                                   'game_score': userInfo.gameScore +
//                                       userInfo.balance +
//                                       userInfo.qualityOfLife,
//                                 });
//                                 Future.delayed(
//                                     Duration(seconds: 1), () => Get.back());
//                               }
//                             },
//                     );
//                   },
//                 )),
//           );
//         });
//   }
//
//   _salaryCredited() {
//     userInfo.color = Colors.white;
//     userInfo.update();
//     return Get.generalDialog(
//         barrierDismissible: false,
//         pageBuilder: (context, animation, sAnimation) {
//           return WillPopScope(
//               onWillPop: () {
//                 return Future.value(false);
//               },
//               child: BackgroundWidget(
//                   level: userInfo.level,
//                   document: levelId == 0 ? 'GameQuestion' : document,
//                   container: GetBuilder<UserInfoController>(
//                     builder: (userInfo) {
//                       return SalaryCreditedWidget(
//                         color: userInfo.color,
//                         onPressed: userInfo.color == AllColors.green
//                             ? () {}
//                             : () {
//                                 userInfo.color = AllColors.green;
//                                 userInfo.update();
//                                 print('Balance ${userInfo.balance}');
//                                 userInfo.balance = userInfo.balance + 1000;
//                                 firestore
//                                     .collection('User')
//                                     .doc(userInfo.userId)
//                                     .update({
//                                   'account_balance': userInfo.balance,
//                                   'game_score': userInfo.gameScore +
//                                       userInfo.balance +
//                                       userInfo.qualityOfLife,
//                                 });
//                                 Future.delayed(
//                                     Duration(seconds: 1), () => Get.back());
//                               },
//                       );
//                     },
//                   )));
//         });
//   }
//
//   _showDialogForRestartLevel() {
//     restartLevelDialog(
//       () {
//         firestore.collection('User').doc(userInfo.userId).update({
//           'previous_session_info': 'Level_2_setUp_page',
//           'bill_payment': 0,
//           'level_id': 0,
//           'credit_card_balance': 0,
//           'credit_card_bill': 0,
//           'credit_score': 0,
//           'payable_bill': 0,
//           'quality_of_life': 0,
//           'score': 0
//         });
//         userInfo.flag1 = false;
//         userInfo.flag2 = false;
//         userInfo.flagForKnow = false;
//         userInfo.scroll = false;
//         userInfo.levelId = 0;
//         userInfo.update();
//         Get.off(
//           () => LevelTwoSetUpPage(),
//           duration: Duration(milliseconds: 500),
//           transition: Transition.downToUp,
//         );
//       },
//     );
//   }
//
//   _optionSelect(
//       int balance,
//       int gameScore,
//       int qualityOfLife,
//       int qol2,
//       int index,
//       AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
//       category,
//       int price) async {
//     if (index == snapshot.data!.docs.length - 1) {
//       firestore.collection('User').doc(userInfo.userId).update({
//         'level_id': index + 1,
//         'level_2_id': index + 1,
//       }).then((value) => Future.delayed(
//           Duration(seconds: 1),
//           () => calculationForProgress(() {
//                 Get.back();
//                 _levelCompleteSummary();
//               })));
//     }
//     if (balance >= 0) {
//       firestore.collection('User').doc(userInfo.userId).update({
//         'account_balance': balance,
//         'quality_of_life': FieldValue.increment(qol2),
//         'game_score': gameScore + balance + qualityOfLife,
//         'level_id': index + 1,
//         'level_2_id': index + 1,
//         'need': category == 'Need'
//             ? FieldValue.increment(price)
//             : FieldValue.increment(0),
//         'want': category == 'Want'
//             ? FieldValue.increment(price)
//             : FieldValue.increment(0),
//       });
//       controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
//     } else {
//       userInfo.scroll = false;
//       userInfo.update();
//       _showDialogForRestartLevel();
//     }
//   }
//
//   _levelCompleteSummary() async {
//     DocumentSnapshot documentSnapshot =
//         await firestore.collection('User').doc(userInfo.userId).get();
//     int accountBalance = documentSnapshot['account_balance'];
//     int need = documentSnapshot['need'];
//     int want = documentSnapshot['want'];
//     int bill = documentSnapshot['bill_payment'];
//     Color color = Colors.white;
//
//     Map<String, double> dataMap = {
//       AllStrings.billsPaid: (((bill * 6) / 6000) * 100).floor().toDouble(),
//       AllStrings.spentOnNeed: ((need / 6000) * 100).floor().toDouble(),
//       AllStrings.spentOnWant: ((want / 6000) * 100).floor().toDouble(),
//       AllStrings.savings: ((accountBalance / 6000) * 100).floor().toDouble(),
//     };
//
//     return Get.generalDialog(
//         barrierDismissible: false,
//         pageBuilder: (context, animation, sAnimation) {
//           return WillPopScope(
//             onWillPop: () {
//               return Future.value(false);
//             },
//             child: accountBalance >= 1200
//                 ? LevelSummaryScreen(
//                     container: StatefulBuilder(builder: (context, _setState) {
//                       return LevelSummaryForLevel1And2(
//                         dataMap: dataMap,
//                         widget: buttonStyle(
//                           color,
//                           AllStrings.playNextLevel,
//                           color == AllColors.green
//                               ? () {}
//                               : () {
//                                   _setState(() {
//                                     color = AllColors.green;
//                                   });
//
//                                   Future.delayed(
//                                     Duration(seconds: 2),
//                                     () => Get.offAll(() => RateUs(onSubmit: () {
//                                           firestore
//                                               .collection('Feedback')
//                                               .doc()
//                                               .set({
//                                             'user_id': userInfo.userId,
//                                             'level_name': userInfo.level,
//                                             'rating': userInfo.star,
//                                             'feedback': userInfo
//                                                 .feedbackCon.text
//                                                 .toString(),
//                                           }).then(
//                                             (value) => _playLevelOrPopQuiz(),
//                                           );
//                                         })),
//                                   );
//                                   //}
//                                 },
//                         ),
//                         //color: color,
//                         text1: 'Salary Earned : ',
//                         text2: '\$' + 6000.toString(),
//                         paddingTop: 1.h,
//                         // onPressed: () {}
//                       );
//                     }),
//                     level: userInfo.level,
//                     document: document)
//                 : BackgroundWidget(
//                     level: userInfo.level,
//                     document: document,
//                     container: StatefulBuilder(builder: (context, _setState) {
//                       return Column(
//                         children: [
//                           SizedBox(
//                             height: 5.h,
//                           ),
//                           LevelSummaryForLevel1And2(
//                             dataMap: dataMap,
//                             completeText: AllStrings.level2LosingText,
//                             //color: color,
//                             widget: buttonStyle(
//                               color,
//                               AllStrings.playAgain,
//                               () {
//                                 _setState(() {
//                                   color = AllColors.green;
//                                 });
//                                 bool value =
//                                     documentSnapshot.get('replay_level');
//                                 documentSnapshot.get('account_balance');
//                                 Future.delayed(Duration(seconds: 1), () {
//                                   firestore
//                                       .collection('User')
//                                       .doc(userInfo.userId)
//                                       .update({
//                                     'previous_session_info':
//                                         'Level_2_setUp_page',
//                                     if (value != true)
//                                       'last_level': 'Level_2_setUp_page',
//                                   }).then((value) {
//                                     Get.offNamed('/Level2SetUp');
//                                   });
//                                 });
//                               },
//                             ),
//                             text1: 'Salary Earned : ',
//                             text2: '\$' + 6000.toString(),
//                             paddingTop: 1.h,
//                             // onPressed: () {}
//                           ),
//                         ],
//                       );
//                     }),
//                   ),
//           );
//         });
//   }
//
//   // _levelCompleteSummary() async {
//   //   DocumentSnapshot documentSnapshot =
//   //       await firestore.collection('User').doc(userInfo.userId).get();
//   //   int accountBalance = documentSnapshot['account_balance'];
//   //   // int need = documentSnapshot['need'];
//   //   // int want = documentSnapshot['want'];
//   //   // int bill = documentSnapshot['bill_payment'];
//   //   // Color color = Colors.white;
//   //
//   //   return Get.generalDialog(
//   //       barrierDismissible: false,
//   //       pageBuilder: (context, animation, sAnimation) {
//   //         return WillPopScope(
//   //           onWillPop: () {
//   //             return Future.value(false);
//   //           },
//   //           child: accountBalance >= 1200
//   //               ? LevelSummaryScreen(
//   //                   container: summary(documentSnapshot),
//   //                   level: userInfo.level,
//   //                   document: document)
//   //               : BackgroundWidget(
//   //                   level: userInfo.level,
//   //                   document: document,
//   //                   container: Column(
//   //                     children: [
//   //                       SizedBox(
//   //                         height: 5.h,
//   //                       ),
//   //                       summary(documentSnapshot),
//   //                     ],
//   //                   )),
//   //         );
//   //       });
//   // }
//
//   summary(DocumentSnapshot<Object?> documentSnapshot) {
//     int accountBalance = documentSnapshot['account_balance'];
//     int need = documentSnapshot['need'];
//     int want = documentSnapshot['want'];
//     int bill = documentSnapshot['bill_payment'];
//     Color color = Colors.white;
//
//     return Container(
//       alignment: Alignment.center,
//       height: 56.h,
//       width: 80.w,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(
//             8.w,
//           ),
//           color: AllColors.lightBlue),
//       child: SingleChildScrollView(child: StatefulBuilder(
//         builder: (contetx, _setState) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               accountBalance >= 1200
//                   ? normalText(
//                       'Congratulations! You have completed this level successfully ',
//                     )
//                   : normalText(
//                       'Oops! You haven\’t managed to achieve your savings goal of 20%. Please try again! ',
//                     ),
//               richText('Salary Earned : ', '\$' + 6000.toString(), 2.h),
//               richText('Bills Paid : ',
//                   '${(((bill * 6) / 6000) * 100).floor()}' + '%', 1.h),
//               richText('Spend on Needs : ',
//                   '${((need / 6000) * 100).floor()}' + '%', 1.h),
//               richText('Spend on Wants : ',
//                   '${((want / 6000) * 100).floor()}' + '%', 1.h),
//               richText('Money Saved : ',
//                   '${((accountBalance / 6000) * 100).floor()}' + '%', 1.h),
//               accountBalance >= 1200
//                   ? buttonStyle(
//                       color,
//                       AllStrings.playNextLevel,
//                       color == AllColors.green
//                           ? () {}
//                           : () {
//                               _setState(() {
//                                 color = AllColors.green;
//                               });
//
//                               Future.delayed(
//                                 Duration(seconds: 2),
//                                 () => Get.offAll(() => RateUs(
//                                       onSubmit: () {
//                                         firestore
//                                             .collection('Feedback')
//                                             .doc()
//                                             .set({
//                                           'user_id': userInfo.userId,
//                                           'level_name': userInfo.level,
//                                           'rating': userInfo.star,
//                                           'feedback': userInfo.feedbackCon.text
//                                               .toString(),
//                                         }).then(
//                                           (value) => _playLevelOrPopQuiz(),
//                                         );
//                                       },
//                                     )),
//                               );
//                               //}
//                             },
//                     )
//                   : buttonStyle(
//                       color,
//                       'Try Again',
//                       () {
//                         _setState(() {
//                           color = AllColors.green;
//                         });
//                         bool value = documentSnapshot.get('replay_level');
//                         documentSnapshot.get('account_balance');
//                         Future.delayed(Duration(seconds: 1), () {
//                           firestore
//                               .collection('User')
//                               .doc(userInfo.userId)
//                               .update({
//                             'previous_session_info': 'Level_2_setUp_page',
//                             if (value != true)
//                               'last_level': 'Level_2_setUp_page',
//                           }).then((value) {
//                             Get.offNamed('/Level2SetUp');
//                           });
//                         });
//                       },
//                     ),
//               SizedBox(
//                 height: 2.h,
//               )
//             ],
//           );
//         },
//       )),
//     );
//   }
//
//   _playLevelOrPopQuiz() async {
//     DocumentSnapshot snap =
//         await firestore.collection('User').doc(userInfo.userId).get();
//     int bal = snap.get('account_balance');
//     int qol = snap.get('quality_of_life');
//     String? level;
//     return popQuizDialog(
//       () async {
//         // SharedPreferences pref = await SharedPreferences.getInstance();
//         DocumentSnapshot snap =
//             await firestore.collection('User').doc(userInfo.userId).get();
//         bool value = snap.get('replay_level');
//         level = snap.get('last_level');
//         level = level.toString().substring(6, 7);
//         int lev = int.parse(level.toString());
//         if (lev == 2 && value == true) {
//           firestore
//               .collection('User')
//               .doc(userInfo.userId)
//               .update({'replay_level': false});
//         }
//         Future.delayed(Duration(seconds: 2), () {
//           FirebaseFirestore.instance
//               .collection('User')
//               .doc(userInfo.userId)
//               .update({
//             'previous_session_info': 'Level_2_Pop_Quiz',
//             'level_id': 0,
//             if (value != true) 'last_level': 'Level_2_Pop_Quiz',
//           });
//           Get.off(
//             () => PopQuiz(),
//             duration: Duration(milliseconds: 500),
//             transition: Transition.downToUp,
//           );
//         });
//       },
//       () async {
//         // SharedPreferences pref = await SharedPreferences.getInstance();
//         DocumentSnapshot snap =
//             await firestore.collection('User').doc(userInfo.userId).get();
//         bool value = snap.get('replay_level');
//         level = snap.get('last_level');
//         level = level.toString().substring(6, 7);
//         int lev = int.parse(level.toString());
//         if (lev == 2 && value == true) {
//           firestore
//               .collection('User')
//               .doc(userInfo.userId)
//               .update({'replay_level': false});
//         }
//         // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(22);
//         // await localNotifyManager.repeatNotificationLevel3();
//         await localNotifyManager.flutterLocalNotificationsPlugin.cancel(2);
//         await localNotifyManager.flutterLocalNotificationsPlugin.cancel(8);
//         await localNotifyManager
//             .scheduleNotificationForLevelThreeSaturdayElevenAm();
//         await localNotifyManager
//             .scheduleNotificationForLevelThreeWednesdaySevenPm();
//         Future.delayed(Duration(seconds: 2), () {
//           FirebaseFirestore.instance
//               .collection('User')
//               .doc(userInfo.userId)
//               .update({
//             'previous_session_info': 'Level_3_setUp_page',
//             if (value != true) 'last_level': 'Level_3_setUp_page',
//             'level_2_balance': bal,
//             'level_2_qol': qol
//           });
//           Get.off(
//             () => LevelThreeSetUpPage(),
//             duration: Duration(milliseconds: 500),
//             transition: Transition.downToUp,
//           );
//         });
//       },
//     );
//   }
// }

// class LevelSummary extends StatelessWidget {
//   final int need;
//   final int want;
//   final int bill;
//   final int accountBalance;
//   final Color color;
//   final VoidCallback onPressed1;
//   final VoidCallback onPressed2;
//
//   const LevelSummary(
//       {Key? key,
//       required this.need,
//       required this.want,
//       required this.bill,
//       required this.accountBalance,
//       required this.color,
//       required this.onPressed1,
//       required this.onPressed2})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       height: 56.h,
//       width: 80.w,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(
//             8.w,
//           ),
//           color: AllColors.lightBlue),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             accountBalance >= 1200
//                 ? normalText(
//                     AllStrings.levelCompleteText,
//                   )
//                 : normalText(AllStrings.level2LosingText),
//             richText(AllStrings.salaryEarned, '\$' + 6000.toString(), 2.h),
//             richText(AllStrings.billsPaid,
//                 '${(((bill * 6) / 6000) * 100).floor()}' + '%', 1.h),
//             richText(AllStrings.spentOnNeed,
//                 '${((need / 6000) * 100).floor()}' + '%', 1.h),
//             richText(AllStrings.spentOnWant,
//                 '${((want / 6000) * 100).floor()}' + '%', 1.h),
//             richText(AllStrings.moneySaved,
//                 '${((accountBalance / 6000) * 100).floor()}' + '%', 1.h),
//             accountBalance >= 1200
//                 ? buttonStyle(color, AllStrings.playNextLevel, onPressed1)
//                 : buttonStyle(color, AllStrings.tryAgain, onPressed2),
//             SizedBox(
//               height: 2.h,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

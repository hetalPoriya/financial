import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/models/que_model.dart';
import 'package:financial/views/rate_us.dart';
import 'package:financial/views/referral_system.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../cutom_screens/custom_screens.dart';
import '../../cutom_screens/level_summary_screen.dart';
import '../../utils/utils.dart';
import '../popQuiz/popQuiz.dart';
import '../setupPage/setup_page.dart';

class AllQueLevelTwo extends StatefulWidget {
  const AllQueLevelTwo({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelTwoState createState() => _AllQueLevelTwoState();
}

class _AllQueLevelTwoState extends State<AllQueLevelTwo> {
  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  getAllData() async {
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
  }

  @override
  void initState() {
    super.initState();
    getLevelId().then((value) {
      getAllData();
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
                    return BackgroundWidget(
                        level: level,
                        document: document,
                        container: StatefulBuilder(
                          builder: (context, _setState) {
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
                                    if (document['card_type'] ==
                                        'GameQuestion') {
                                      updateValue = updateValue + 1;
                                      await Prefs.setInt(
                                          PrefString.updateValue, updateValue);

                                      if (updateValue == 8) {
                                        updateValue = 0;
                                        await Prefs.setInt(
                                            PrefString.updateValue, 0);
                                        calculationForProgress(onPressed: () {
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
                                        document['week'] != 0)
                                      _salaryCredited();
                                  }
                                },
                                itemBuilder: (context, index) {
                                  //currentIndex = index;
                                  document = snapshot.data!.docs[index];
                                  levelId = index;
                                  return document['card_type'] == 'GameQuestion'
                                      ? DayOrWeekWidget(
                                          level: level,
                                          document: document,
                                          containerWidget:
                                              GameQuestionContainer(
                                            level: level,
                                            document: document,
                                            description:
                                                document['description'],
                                            option1: document['option_1'],
                                            option2: document['option_2'],
                                            color1:
                                                list[index].isSelected1 == true
                                                    ? AllColors.green
                                                    : Colors.white,
                                            color2:
                                                list[index].isSelected2 == true
                                                    ? AllColors.green
                                                    : Colors.white,
                                            textStyle1: AllTextStyles
                                                .gameQuestionOptionText(
                                                    color: list[index]
                                                                .isSelected1 ==
                                                            true
                                                        ? Colors.white
                                                        : AllColors.yellow),
                                            textStyle2: AllTextStyles
                                                .gameQuestionOptionText(
                                                    color: list[index]
                                                                .isSelected2 ==
                                                            true
                                                        ? Colors.white
                                                        : AllColors.yellow),
                                            onPressed1: list[index]
                                                            .isSelected2 ==
                                                        true ||
                                                    list[index].isSelected1 ==
                                                        true
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
                                            onPressed2: list[index]
                                                            .isSelected2 ==
                                                        true ||
                                                    list[index].isSelected1 ==
                                                        true
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
                                          ),
                                        )
                                      : DayOrWeekWidget(
                                          level: level,
                                          document: document,
                                          containerWidget: InsightWidget(
                                            level: level,
                                            document: document,
                                            description:
                                                document['description'],
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
                                                  snapshot.data!.docs.length -
                                                      1) {
                                                firestore
                                                    .collection('User')
                                                    .doc(userId)
                                                    .update({
                                                  'level_id': index + 1,
                                                  'level_2_id': index + 1,
                                                }).then((value) =>
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 1),
                                                            () =>
                                                                calculationForProgress(
                                                                    onPressed:
                                                                        () {
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
                                                    duration: Duration(
                                                      milliseconds: 800,
                                                    ),
                                                    curve: Curves.easeIn);
                                              }
                                            },
                                          ),
                                        );
                                });
                          },
                        ));
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
                    return DayOrWeekWidget(
                      level: level,
                      document: document,
                      containerWidget: BillPaymentWidget(
                        billPayment: billPayment.toString(),
                        forPlan1: forPlan1.toString(),
                        forPlan2: forPlan2.toString(),
                        forPlan3: forPlan3.toString(),
                        forPlan4: forPlan4.toString(),
                        text1: 'Rent : ',
                        text2: 'TV & Internet: ',
                        text3: 'Groceries: ',
                        text4: 'Cellphone: ',
                        color: color,
                        onPressed: color == AllColors.green
                            ? () {}
                            : () async {
                                DocumentSnapshot doc = await firestore
                                    .collection('User')
                                    .doc(userId)
                                    .get();
                                balance = doc.get('account_balance');
                                _setState(() {
                                  color = AllColors.green;
                                  balance = balance - billPayment;
                                });

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
                                    'level_2_balance': balance,
                                    'level_2_qol': qualityOfLife,
                                  });
                                  Future.delayed(
                                      Duration(seconds: 1), () => Get.back());
                                }
                              },
                      ),
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
                    return DayOrWeekWidget(
                      document: levelId == 0 ? 'GameQuestion' : document,
                      level: level,
                      containerWidget: SalaryCreditedWidget(
                        color: color,
                        onPressed: color == AllColors.green
                            ? () {}
                            : () async {
                                DocumentSnapshot doc = await firestore
                                    .collection('User')
                                    .doc(userId)
                                    .get();
                                balance = doc.get('account_balance');
                                _setState(() {
                                  color = AllColors.green;
                                  balance = balance + 1000;
                                });

                                firestore
                                    .collection('User')
                                    .doc(userId)
                                    .update({
                                  'account_balance': balance,
                                  'game_score':
                                      gameScore + balance + qualityOfLife,
                                  'level_2_balance': balance,
                                  'level_2_qol': qualityOfLife,
                                });
                                Future.delayed(
                                    Duration(seconds: 1), () => Get.back());
                              },
                      ),
                    );
                  },
                )),
          );
        });
  }

  _showDialogForRestartLevel() {
    restartLevelDialog(
      onPressed: () {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_2_setUp_page',
          'bill_payment': 0,
          'level_id': 0,
          'credit_card_balance': 0,
          'credit_card_bill': 0,
          'credit_score': 0,
          'payable_bill': 0,
          'quality_of_life': 0,
          'score': 0,
          'account_balance': 0,
          'level_2_balance': 0,
          'level_2_qol': 0,
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
        'level_2_balance': balance,
        'level_2_qol': qualityOfLife,
      }).then((value) => Future.delayed(
          Duration(seconds: 1),
          () => calculationForProgress(onPressed: () {
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
        'level_2_balance': balance,
        'level_2_qol': qualityOfLife,
        'need': category == 'Need'
            ? FieldValue.increment(price)
            : FieldValue.increment(0),
        'want': category == 'Want'
            ? FieldValue.increment(price)
            : FieldValue.increment(0),
      });
      controller.nextPage(
          duration: Duration(
            milliseconds: 800,
          ),
          curve: Curves.easeIn);
    } else {
      setState(() {
        scroll = false;
      });
      _showDialogForRestartLevel();
    }
  }

  _levelCompleteSummary() async {
    print('UserId $userId');
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
                    container: StatefulBuilder(builder: (context, _setState) {
                      return LevelSummaryForLevel1And2(
                        mainText:  AllStrings.congratulations,
                        completeText: AllStrings.levelCompleteText,
                        dataMap: dataMap,
                        widget: buttonStyle(
                          color: color,
                          text: AllStrings.playNextLevel,
                          onPressed: color == AllColors.green
                              ? () {}
                              : () {
                                  _setState(() {
                                    color = AllColors.green;
                                  });

                                  Future.delayed(
                                    Duration(seconds: 2),
                                    () => Get.offAll(() => RateUs(
                                          onSubmit: () => _playLevelOrPopQuiz(),
                                          //         onSubmit: () {
                                          //   firestore
                                          //       .collection('Feedback')
                                          //       .doc()
                                          //       .set({
                                          //     'user_id': userInfo.userId,
                                          //     'level_name': userInfo.level,
                                          //     'rating': userInfo.star,
                                          //     'feedback': userInfo.feedbackCon.text
                                          //         .toString(),
                                          //   }).then(
                                          //         (value) => _playLevelOrPopQuiz(),
                                          //   );
                                          // }
                                        )),
                                  );
                                },
                        ),
                        text1: 'Salary Earned : ',
                        text2: AllStrings.countrySymbol + 6000.toString(),
                        paddingTop: 1.h,
                      );
                    }),
                    level: level,
                    document: document)
                : BackgroundWidget(
                    level: level,
                    document: document,
                    container: StatefulBuilder(builder: (context, _setState) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          LevelSummaryForLevel1And2(
                            dataMap: dataMap,
                            completeText: AllStrings.level2LosingText,
                            mainText: AllStrings.tryAgain,
                            //color: color,
                            widget: buttonStyle(
                              color: color,
                              text: AllStrings.playAgain,
                              onPressed: () {
                                _setState(() {
                                  color = AllColors.green;
                                });
                                bool value =
                                    documentSnapshot.get('replay_level');
                                documentSnapshot.get('account_balance');
                                Future.delayed(Duration(seconds: 1), () {
                                  firestore
                                      .collection('User')
                                      .doc(userId)
                                      .update({
                                    'previous_session_info':
                                        'Level_2_setUp_page',
                                    if (value != true)
                                      'last_level': 'Level_2_setUp_page',
                                  }).then((value) {
                                    Get.offNamed('/Level2SetUp');
                                  });
                                });
                              },
                            ),
                            text1: 'Salary Earned : ',
                            text2: AllStrings.countrySymbol + 6000.toString(),
                            paddingTop: 1.h,
                            // onPressed: () {}
                          ),
                        ],
                      );
                    }),
                  ),
          );
        });
  }

  _playLevelOrPopQuiz() async {
    var userId = Prefs.getString(PrefString.userId);
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    bool value = snap.get('replay_level');
    level = snap.get('last_level');
    level = level.toString().substring(6, 7);
    int lev = int.parse(level);
    if (lev == 2 && value == true) {
      firestore.collection('User').doc(userId).update({'replay_level': false});
    }
    return popQuizDialog(
      onPlayPopQuizPressed: () async {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        Future.delayed(Duration(seconds: 1), () {
          _whenLevelComplete(value: value, levelOrPopQuiz: 'Level_2_Pop_Quiz')
              .then((value) => Get.offAll(
                    () => LevelsPopQuiz(),
                  ));
        });
      },
      onPlayNextLevelPressed: () async {
        List referralUsersCount = snap.get('referral_by');
        bool enterUserByPay = snap.get('enter_via_paying');
        bool enterUserByInviteCode = snap.get('enter_via_special_code');

        if (referralUsersCount.length == 3 ||
            enterUserByPay == true ||
            enterUserByInviteCode == true) {
          Future.delayed(Duration(seconds: 1), () {
            _whenLevelComplete(
                    value: value, levelOrPopQuiz: 'Level_3_setUp_page')
                .then((value) => Get.offAll(
                      () => LevelThreeSetUpPage(),
                    ));
          });
        } else {
          Future.delayed(Duration(seconds: 1), () {
            _whenLevelComplete(
                    value: value,
                    levelOrPopQuiz: 'Referral_page',
                    referralPage: true)
                .then((value) => Get.offAll(
                      () => ReferralSystem(),
                    ));
          });
        }
      },
    );
  }

  Future _whenLevelComplete(
      {bool? value, String? levelOrPopQuiz, bool? referralPage}) {
    return firestore.collection('User').doc(userId).update({
      'previous_session_info': levelOrPopQuiz,
      'level_id': 0,
      'account_balance': 0,
      'need': 0,
      'want': 0,
      'quality_of_life': 0,
      'bill_payment': 0,
      if (referralPage == false)
        if (value != true) 'last_level': levelOrPopQuiz,
    });
    // LocalNotifyManager.init();
    // await localNotifyManager.configureLocalTimeZone();
    // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(2);
    // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(8);
    // await localNotifyManager
    //     .scheduleNotificationForLevelThreeSaturdayElevenAm();
    // await localNotifyManager
    //     .scheduleNotificationForLevelThreeWednesdaySevenPm();
  }
}

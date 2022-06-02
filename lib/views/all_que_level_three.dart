import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/shareable_screens/background_widget.dart';
import 'package:financial/shareable_screens/bill_payment_widget.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/game_question_container.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/insight_widget.dart';
import 'package:financial/shareable_screens/level_summary_screen.dart';
import 'package:financial/shareable_screens/salary_credited_widget.dart';
import 'package:financial/models/que_model.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/level_four_setUp_page.dart';
import 'package:financial/views/level_three_setUp_page.dart';
import 'package:financial/views/pop_quiz.dart';
import 'package:financial/views/rate_us.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'local_notify_manager.dart';

class AllQueLevelThree extends StatefulWidget {
  const AllQueLevelThree({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelThreeState createState() => _AllQueLevelThreeState();
}

class _AllQueLevelThreeState extends State<AllQueLevelThree> {
  int creditScore = 0;
  int score = 0;
  int priceOfOption = 0;
  String option = '';
  int creditBill = 0;
  int creditBal = 0;
  int payableBill = 0;
  QueModel? queModel;
  List<QueModel> list = [];
  final userInfo = Get.put<UserInfoController>(UserInfoController());

  getAllData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Level_3").get();
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

  @override
  Widget build(BuildContext context) {
    color = Colors.white;
    flagForKnow = false;
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
                  .collection('Level_3')
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

                            if ((document['week'] % 4 == 0) &&
                                document['week'] != 0) _creditCardBillPayment();

                            if ((document['week'] % 4 == 1) &&
                                document['week'] != 0) _salaryCredited();
                          }
                        },
                        itemBuilder: (context, index) {
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
                                              color: list[index].isSelected1 ==
                                                      true
                                                  ? Colors.white
                                                  : AllColors.yellow),
                                      textStyle2:
                                          AllTextStyles.gameQuestionOption(
                                              color: list[index].isSelected2 ==
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
                                                list[index].isSelected1 = true;
                                                int qol1 = document[
                                                    'quality_of_life_1'];
                                                priceOfOption =
                                                    document['option_1_price'];
                                                DocumentSnapshot doc =
                                                    await firestore
                                                        .collection('User')
                                                        .doc(userId)
                                                        .get();
                                                balance =
                                                    doc.get('account_balance');
                                                option = document['option_1'];
                                                // balance = balance - priceOfOption;
                                                var category =
                                                    document['category'];
                                                qualityOfLife =
                                                    qualityOfLife + qol1;
                                                _optionSelect(
                                                    index,
                                                    qualityOfLife,
                                                    balance,
                                                    qol1,
                                                    creditBal,
                                                    creditScore,
                                                    creditCount,
                                                    payableBill,
                                                    snapshot,
                                                    document,
                                                    score,
                                                    priceOfOption,
                                                    option,
                                                    _setState,
                                                    category);
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
                                                list[index].isSelected2 = true;

                                                int qol2 = document[
                                                    'quality_of_life_2'];
                                                qualityOfLife =
                                                    qualityOfLife + qol2;
                                                DocumentSnapshot doc =
                                                    await firestore
                                                        .collection('User')
                                                        .doc(userId)
                                                        .get();
                                                balance =
                                                    doc.get('account_balance');
                                                priceOfOption =
                                                    document['option_2_price'];
                                                // balance = balance - priceOfOption;
                                                option = document['option_2'];
                                                var category =
                                                    document['category'];
                                                _optionSelect(
                                                    index,
                                                    qualityOfLife,
                                                    balance,
                                                    qol2,
                                                    creditBal,
                                                    creditScore,
                                                    creditCount,
                                                    payableBill,
                                                    snapshot,
                                                    document,
                                                    score,
                                                    priceOfOption,
                                                    option,
                                                    _setState,
                                                    category);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: AllStrings
                                                        .optionAlreadySelected);
                                              }
                                            },
                                    );
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
                                        color = AllColors.green;
                                      });
                                      if (index ==
                                          snapshot.data!.docs.length - 1) {
                                        firestore
                                            .collection('User')
                                            .doc(userId)
                                            .update({
                                          'level_id': index + 1,
                                          'level_3_id': index + 1,
                                        }).then((value) => Future.delayed(
                                                Duration(seconds: 1),
                                                () => calculationForProgress(
                                                        onPressed: () {
                                                      Get.back();
                                                      _levelCompleteSummary();
                                                    })));
                                      } else {
                                        firestore
                                            .collection('User')
                                            .doc(userId)
                                            .update({
                                          'level_id': index + 1,
                                          'level_3_id': index + 1,
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

  _showDialogForRestartLevel() {
    restartLevelDialog(
      onPressed: () {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_3_setUp_page',
          'bill_payment': 0,
          'credit_card_bill': 500,
          'account_balance': 0,
          'quality_of_life': 0,
          'level_id': 0,
          'level_3_balance': 0,
          'level_3_qol': 0,
          'level_3_creditScore': 0,
        });
        Get.off(
          () => LevelThreeSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      },
    );
  }

  _showDialogCreditBalNotEnough(
      int balance,
      price,
      PageController controller,
      int gameScore,
      int qualityOfLife,
      int qol2,
      bool scroll,
      int index) async {
    return Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      middleText: AllStrings.creditBalNotEnough,
      barrierDismissible: false,
      onWillPop: () {
        return Future.value(false);
      },
      backgroundColor: AllColors.darkPurple,
      middleTextStyle: AllTextStyles.dialogStyleMedium(),
      confirm: restartOrOkButton(
        text: 'Ok',
        onPressed: () {
          Future.delayed(Duration(seconds: 1), () => Get.back()).then((value) {
            if (balance >= price) {
              balance = ((balance - price) as int?)!;
              firestore.collection('User').doc(userId).update({
                'account_balance': balance,
                'quality_of_life': FieldValue.increment(qol2),
                'level_3_balance': balance,
                'level_3_qol': FieldValue.increment(qol2),
                'game_score': gameScore + balance + qualityOfLife,
                'level_id': index + 1,
                'level_3_id': index + 1,
              });
              controller.nextPage(
                  duration: Duration(seconds: 1), curve: Curves.easeIn);
            } else {
              //setState(() {
              scroll = false;
              //});
              _showDialogForRestartLevel();
            }
          });
        },
      ),
    );
  }

  _showDialogDebitBalNotEnough(
      creditBill,
      int balance,
      price,
      PageController controller,
      int gameScore,
      int qualityOfLife,
      int qol2,
      bool scroll,
      int index) async {
    return Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      middleText: AllStrings.debitBalNotEnough,
      barrierDismissible: false,
      onWillPop: () {
        return Future.value(false);
      },
      backgroundColor: AllColors.darkPurple,
      middleTextStyle: AllTextStyles.dialogStyleMedium(),
      confirm: restartOrOkButton(
        text: 'Ok',
        onPressed: () {
          Future.delayed(Duration(seconds: 1), () => Get.back()).then((value) {
            if (creditBal >= price) {
              firestore.collection('User').doc(userId).update({
                'credit_card_bill': FieldValue.increment(price),
                'quality_of_life': FieldValue.increment(qol2),
                'game_score': gameScore + balance + qualityOfLife,
                'credit_card_balance': FieldValue.increment(-price),
                'level_id': index + 1,
                'level_3_id': index + 1,
              });
            } else {
              //  setState(() {
              scroll = false;
              // });
              _showDialogForRestartLevel();
            }
          });
        },
      ),
    );
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
                                  'level_3_balance': balance,
                                  'level_3_qol': qualityOfLife,
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

                              firestore.collection('User').doc(userId).update({
                                'account_balance': balance,
                                'game_score':
                                    gameScore + balance + qualityOfLife,
                                'level_3_balance': balance,
                                'level_3_qol': qualityOfLife,
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

  _creditCardBillPayment() async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    balance = snap.get('account_balance');
    payableBill = snap.get('payable_bill');
    creditBill = snap.get('credit_card_bill');
    int credit = snap.get('credit_score');
    Color color1 = Colors.white;
    Color color2 = Colors.white;

    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          int intrest = (payableBill * 5 ~/ 100).toInt().ceil();

          int totalAmount = creditBill + payableBill + intrest;

          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: BackgroundWidget(
                level: level,
                document: document,
                container: StatefulBuilder(
                  builder: (context, _setState) {
                    return CreditCardPaymentWidget(
                      intrest: intrest,
                      payableBill: payableBill,
                      totalAmount: totalAmount,
                      creditBill: creditBill,
                      color2: color2,
                      color1: color1,
                      onPressed1: color1 == AllColors.green
                          ? () {}
                          : () async {
                              _setState(() {
                                color1 = AllColors.green;
                              });
                              DocumentSnapshot doc = await firestore
                                  .collection('User')
                                  .doc(userId)
                                  .get();
                              balance = doc.get('account_balance');
                              if (totalAmount.ceil() != 0 &&
                                  balance >= totalAmount.ceil()) {
                                _setState(() {
                                  balance = balance - totalAmount.ceil();
                                });
                                score = snap.get('score');
                                firestore
                                    .collection('User')
                                    .doc(userId)
                                    .update({
                                  'account_balance': balance,
                                  'credit_card_bill': 0,
                                  'payable_bill': 0,
                                  'game_score':
                                      gameScore + balance + qualityOfLife,
                                  'score': FieldValue.increment(40),
                                  'credit_score': (score + 200 + 40),
                                  'level_3_balance': balance,
                                  'level_3_qol': qualityOfLife,
                                  'level_3_creditScore': (score + 200 + 40),
                                });
                                Future.delayed(
                                    Duration(seconds: 1), () => Get.back());
                              } else {
                                if (totalAmount.ceil() == 0) {
                                  Future.delayed(
                                      Duration(seconds: 1), () => Get.back());
                                } else {
                                  _showDialogForRestartLevel();
                                }
                              }
                              // }
                            },
                      onPressed2: color2 == AllColors.green
                          ? () {}
                          : () async {
                              _setState(() {
                                color2 = AllColors.green;
                              });
                              int pay =
                                  (totalAmount * 10 ~/ 100).toInt().ceil();
                              score = snap.get('score');
                              int bal = totalAmount - pay;
                              double value = 100 - ((bal / 2000) * 100);
                              value = value * 2;
                              if (totalAmount.ceil() != 0 && balance >= pay) {
                                balance = balance - pay;
                                firestore
                                    .collection('User')
                                    .doc(userId)
                                    .update({
                                  'account_balance': balance,
                                  'payable_bill': bal,
                                  'credit_card_bill': 0,
                                  'game_score':
                                      gameScore + balance + qualityOfLife,
                                  'score': FieldValue.increment(40),
                                  'credit_score': (score + value.ceil() + 40),
                                  'level_3_creditScore':
                                      (score + value.ceil() + 40)
                                });
                                Future.delayed(
                                    Duration(seconds: 1), () => Get.back());
                              } else {
                                if (totalAmount.ceil() == 0) {
                                  Future.delayed(
                                      Duration(seconds: 1), () => Get.back());
                                } else {
                                  _showDialogForRestartLevel();
                                }
                              }
                            },
                    );
                  },
                )),
          );
        });
  }

  _levelCompleteSummary() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    int creditScore = documentSnapshot['credit_score'];

    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: creditScore >= 750
                ? LevelSummaryScreen(
                    container: summary(documentSnapshot),
                    document: document,
                    level: level,
                  )
                : BackgroundWidget(
                    level: level,
                    document: document,
                    container: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        summary(documentSnapshot),
                      ],
                    )),
          );
        });
  }

  _playLevelOrPopQuiz() async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    bool value = snap.get('replay_level');
    level = snap.get('last_level');
    level = level.toString().substring(6, 7);
    int lev = int.parse(level);
    if (lev == 3 && value == true) {
      firestore.collection('User').doc(userId).update({'replay_level': false});
    }

    return popQuizDialog(onPlayPopQuizPressed: () {
      Future.delayed(Duration(seconds: 1), () async {
        _whenLevelComplete(value: value, levelOrPopQuiz: 'Level_3_Pop_Quiz')
            .then((value) => Get.offAll(
                  () => PopQuiz(),
                ));
      });
    }, onPlayNextLevelPressed: () async {
      Future.delayed(Duration(seconds: 1), () async {
        _whenLevelComplete(value: value, levelOrPopQuiz: 'Level_4_setUp_page')
            .then((value) => Get.offAll(
                  () => LevelFourSetUpPage(),
                ));
      });
    });
  }

  Future _whenLevelComplete({bool? value, String? levelOrPopQuiz}) {
    return firestore.collection('User').doc(userId).update({
      'bill_payment': 0,
      'credit_card_bill': 0,
      'previous_session_info': levelOrPopQuiz,
      'credit_card_balance': 0,
      'account_balance': 0,
      'level_id': 0,
      'credit_score': 0,
      'quality_of_life': 0,
      'payable_bill': 0,
      'score': 0,
      'need': 0,
      'want': 0,
      'level_3_id': 0,
      if (value != true) 'last_level': levelOrPopQuiz,
    });
    // LocalNotifyManager.init();
    // await localNotifyManager.configureLocalTimeZone();
    // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(3);
    // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(9);
    // await localNotifyManager
    //     .scheduleNotificationForLevelFourSaturdayElevenAm();
    // await localNotifyManager
    //     .scheduleNotificationForLevelFourWednesdaySevenPm();
  }

  _optionSelect(
      int index,
      int qualityOfLife,
      int balance,
      int qol2,
      int creditBal,
      int creditScore,
      int creditCount,
      int payableBill,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      document,
      int score,
      int priceOfOption,
      String option,
      StateSetter setState1,
      category) async {
    DocumentSnapshot doc = await firestore.collection('User').doc(userId).get();
    creditBal = doc['credit_card_balance'];
    int credit = doc['credit_score'];

    int price = priceOfOption;
    if (index == snapshot.data!.docs.length - 1) {
      firestore.collection('User').doc(userId).update({
        'level_id': index + 1,
        'level_3_id': index + 1,
        'level_3_balance': balance,
        'level_3_qol': qualityOfLife,
        'level_3_creditScore': creditScore,
      }).then((value) {
        Future.delayed(
            Duration(seconds: 1),
            () => calculationForProgress(onPressed: () {
                  Get.back();
                  _levelCompleteSummary();
                }));
      });
    }

    firestore.collection('User').doc(userId).update({
      'level_3_balance': balance,
      'level_3_qol': qualityOfLife,
    });

    if (balance >= 0 && creditBal >= 0) {
      if (option.toString().trim().length >= 11 &&
          option.toString().substring(0, 11) == 'Credit Card') {
        double c = 2000 * 80 / 100;
        c = 2000 - c;
        if (creditBal <= c) {
          return showDialogWhenUse80Credit(balance, price, controller,
              gameScore, qualityOfLife, qol2, scroll, index);
        }
        if (creditBal >= priceOfOption) {
          firestore.collection('User').doc(userId).update({
            'credit_card_bill': FieldValue.increment(priceOfOption),
            'quality_of_life': FieldValue.increment(qol2),
            'game_score': gameScore + balance + qualityOfLife,
            'credit_card_balance': FieldValue.increment(-priceOfOption),
            'level_id': index + 1,
            'level_3_id': index + 1,
            'need': category == 'Need'
                ? FieldValue.increment(priceOfOption)
                : FieldValue.increment(0),
            'want': category == 'Want'
                ? FieldValue.increment(priceOfOption)
                : FieldValue.increment(0),
          }).then((value) {
            FirebaseFirestore.instance
                .collection('User')
                .doc(userId)
                .get()
                .then((string) {
              var data = string.data();
              creditBill = data!['credit_card_bill'];
              creditScore = data['credit_score'];
              payableBill = data['payable_bill'];
              score = data['score'];
              creditCount = creditCount - 10;
            }).then((value) {
              creditBill = payableBill + creditBill;
              double value = 100 - ((creditBill / 2000) * 100);

              value = value * 2;

              firestore.collection('User').doc(userId).update({
                'credit_score': creditCount >= 0
                    ? (score + value.ceil() + 10)
                    : (score + value.ceil()),
                'level_3_creditScore': creditCount >= 0
                    ? (score + value.ceil() + 10)
                    : (score + value.ceil()),
                'score': creditCount >= 0
                    ? FieldValue.increment(10)
                    : FieldValue.increment(0),
              });
            });
          });
          controller.nextPage(
              duration: Duration(seconds: 1), curve: Curves.easeIn);
        } else {
          _showDialogCreditBalNotEnough(balance, price, controller, gameScore,
              qualityOfLife, qol2, scroll, index);
        }
      } else {
        if (balance >= priceOfOption) {
          setState1(() {
            balance = balance - priceOfOption;
          });
          firestore.collection('User').doc(userId).update({
            'account_balance': balance,
            'quality_of_life': FieldValue.increment(qol2),
            'level_3_balance': balance,
            'level_3_qol': FieldValue.increment(qol2),
            'game_score': gameScore + balance + qualityOfLife,
            'level_id': index + 1,
            'level_3_id': index + 1,
            'need': category == 'Need'
                ? FieldValue.increment(priceOfOption)
                : FieldValue.increment(0),
            'want': category == 'Want'
                ? FieldValue.increment(priceOfOption)
                : FieldValue.increment(0),
            // 'credit_score' : debitCount >= 0 ? (350 + value + 10) : (350 + value)
          });
          controller.nextPage(
              duration: Duration(seconds: 1), curve: Curves.easeIn);
        } else {
          _showDialogDebitBalNotEnough(creditBill, balance, priceOfOption,
              controller, gameScore, qualityOfLife, qol2, scroll, index);
          controller.nextPage(
              duration: Duration(seconds: 1), curve: Curves.easeIn);
        }
      }
    } else {
      setState(() {
        scroll = false;
      });
      _showDialogForRestartLevel();
    }
  }

  summary(DocumentSnapshot<Object?> documentSnapshot) {
    int need = documentSnapshot['need'];
    int want = documentSnapshot['want'];
    int bill = documentSnapshot['bill_payment'];
    int creditScore = documentSnapshot['credit_score'];
    int accountBalance = documentSnapshot['account_balance'];
    Color color = Colors.white;

    return Container(
      alignment: Alignment.center,
      height: 56.h,
      width: 80.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.w,
          ),
          color: AllColors.lightBlue),
      child: StatefulBuilder(
        builder: (context, _setState) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 1.h,
            ),
            Text(AllStrings.creditSumTitle,
                style: AllTextStyles.dialogStyleExtraLarge(size: 20.sp)),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(AllStrings.creditSumDes,
                  style: AllTextStyles.dialogStyleLarge(),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 2.h,
            ),
            RichText(
                text: TextSpan(
                    text: AllStrings.creditScore + ' ',
                    style: AllTextStyles.dialogStyleExtraLarge(size: 18.sp),
                    children: [
                  TextSpan(
                    text: creditScore.toString(),
                    style: AllTextStyles.dialogStyleExtraLarge(
                      size: 18.sp,
                      color: (creditScore >= 350 && creditScore <= 450)
                          ? AllColors.creditScore350to450
                          : (creditScore >= 450 && creditScore <= 550)
                              ? AllColors.creditScore450to550
                              : (creditScore >= 550 && creditScore <= 650)
                                  ? AllColors.creditScore550to650
                                  : (creditScore >= 650 && creditScore <= 750)
                                      ? AllColors.creditScore650to750
                                      : (creditScore >= 750 &&
                                              creditScore <= 850)
                                          ? AllColors.creditScore750to850
                                          : AllColors.creditScore850to950,
                    ),
                  )
                ])),
            // Text(AllStrings.creditScore + '  ' + creditScore.toString(),
            //     style: AllTextStyles.dialogStyleExtraLarge(size: 18.sp)),

            Container(
              height: 23.h, width: 65.w,
              //color: AllColors.orange,
              alignment: Alignment.topCenter,
              child: SfRadialGauge(
                animationDuration: 1000,
                enableLoadingAnimation: true,
                // title: GaugeTitle(
                //     text: 'Credit Score $creditScore',
                //     textStyle:
                //         AllTextStyles.dialogStyleExtraLarge(size: 18.sp)),
                axes: <RadialAxis>[
                  RadialAxis(
                      minimum: 350,
                      showLabels: false,
                      maximum: 950,
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 350,
                            endValue: 450,
                            label: '350+',
                            labelStyle: AllTextStyles.gaugeStyle(),
                            color: AllColors.creditScore350to450,
                            startWidth: 14.w,
                            endWidth: 14.w),
                        GaugeRange(
                            startValue: 450,
                            label: '450+',
                            labelStyle: AllTextStyles.gaugeStyle(),
                            endValue: 550,
                            color: AllColors.creditScore450to550,
                            startWidth: 14.w,
                            endWidth: 14.w),
                        GaugeRange(
                            startValue: 550,
                            endValue: 650,
                            label: '550+',
                            labelStyle: AllTextStyles.gaugeStyle(),
                            color: AllColors.creditScore550to650,
                            startWidth: 14.w,
                            endWidth: 14.w),
                        GaugeRange(
                            startValue: 650,
                            endValue: 750,
                            label: '650+',
                            labelStyle: AllTextStyles.gaugeStyle(),
                            color: AllColors.creditScore650to750,
                            startWidth: 14.w,
                            endWidth: 14.w),
                        GaugeRange(
                            startValue: 750,
                            endValue: 850,
                            label: '750+',
                            labelStyle: AllTextStyles.gaugeStyle(),
                            color: AllColors.creditScore750to850,
                            startWidth: 14.w,
                            endWidth: 14.w),
                        GaugeRange(
                            startValue: 850,
                            endValue: 950,
                            label: '850+',
                            labelStyle: AllTextStyles.gaugeStyle(),
                            color: AllColors.creditScore850to950,
                            startWidth: 14.w,
                            endWidth: 14.w),
                      ],
                      startAngle: 180,
                      endAngle: 0,
                      canScaleToFit: true,
                      pointers: <GaugePointer>[
                        NeedlePointer(value: creditScore.toDouble())
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // crossAxisAlignment:
                              //     CrossAxisAlignment.end,
                              children: [
                                Text('😰',
                                    style: AllTextStyles.dialogStyleLarge(
                                        size: ((creditScore > 350 &&
                                                    creditScore <= 450) ||
                                                (creditScore > 450 &&
                                                    creditScore <= 550))
                                            ? 28.sp
                                            : 14.sp)),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text('😞',
                                    style: AllTextStyles.dialogStyleLarge(
                                        size: (creditScore > 550 &&
                                                creditScore <= 650)
                                            ? 28.sp
                                            : 14.sp)),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text('😐',
                                    style: AllTextStyles.dialogStyleLarge(
                                        size: (creditScore > 650 &&
                                                creditScore <= 750)
                                            ? 28.sp
                                            : 14.sp)),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text('🙂',
                                    style: AllTextStyles.dialogStyleLarge(
                                        size: (creditScore > 750 &&
                                                creditScore <= 850)
                                            ? 28.sp
                                            : 14.sp)),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text('😀',
                                    style: AllTextStyles.dialogStyleLarge(
                                        size: (creditScore > 850 &&
                                                creditScore <= 950)
                                            ? 28.sp
                                            : 14.sp)),
                                SizedBox(
                                  width: 2.w,
                                ),
                              ],
                            ),
                            angle: 90.0,
                            positionFactor: 0.5),
                      ]),

                ],
              ),
              //  color: AllColors.red,
            ),
            SizedBox(height: 2.h,),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                creditScore >= 750
                    ? buttonStyle(
                  color: color,
                  text: AllStrings.playNextLevel,
                  onPressed: color == AllColors.green
                      ? () {}
                      : () async {
                    _setState(() {
                      color = AllColors.green;
                    });
                    Future.delayed(
                        Duration(seconds: 2),
                            () => Get.offAll(() => RateUs(
                            onSubmit: () =>
                                _playLevelOrPopQuiz()
                          //     () {
                          //   firestore
                          //       .collection('Feedback')
                          //       .doc()
                          //       .set({
                          //     'user_id': userId,
                          //     'level_name': level,
                          //     'rating': userInfo.star,
                          //     'feedback': userInfo
                          //         .feedbackCon.text
                          //         .toString(),
                          //   }).then((value) =>
                          //           _playLevelOrPopQuiz());
                          // },
                        )));

                    // }
                  },
                )
                    : buttonStyle(
                  color: color,
                  text: AllStrings.tryAgain,
                  onPressed: () {
                    _setState(() {
                      color = AllColors.green;
                    });
                    bool value = documentSnapshot
                        .get('replay_level');
                    firestore
                        .collection('User')
                        .doc(userId)
                        .update({
                      'previous_session_info':
                      'Level_3_setUp_page',
                      if (value != true)
                        'last_level':
                        'Level_3_setUp_page',
                    }).then((value) {
                      Future.delayed(
                        Duration(seconds: 1),
                            () => Get.offNamed(
                            '/Level3SetUp'),
                      );
                    });
                  },
                ),
                SizedBox(height: 1.h),
                if (creditScore < 750)
                  normalText(
                    text: AllStrings.poorCreditScore,
                  ),
                SizedBox(
                  height: 2.h,
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('😰',
            //         style: AllTextStyles.dialogStyleLarge(
            //             size: ((creditScore > 350 && creditScore <=
            //                 450) ||
            //                 (creditScore > 450 && creditScore <= 550))
            //                 ? 28.sp
            //                 : 14.sp)),
            //     SizedBox(
            //       width: 2.w,
            //     ),
            //     Text('😞',
            //         style: AllTextStyles.dialogStyleLarge(
            //             size: (creditScore > 550 && creditScore <= 650)
            //                 ? 28.sp
            //                 : 14.sp)),
            //     SizedBox(
            //       width: 2.w,
            //     ),
            //     Text('😐',
            //         style: AllTextStyles.dialogStyleLarge(
            //             size: (creditScore > 650 && creditScore <= 750)
            //                 ? 28.sp
            //                 : 14.sp)),
            //     SizedBox(
            //       width: 2.w,
            //     ),
            //     Text('🙂',
            //         style: AllTextStyles.dialogStyleLarge(
            //             size: (creditScore > 750 && creditScore <= 850)
            //                 ? 28.sp
            //                 : 14.sp)),
            //     SizedBox(
            //       width: 2.w,
            //     ),
            //     Text('😀',
            //         style: AllTextStyles.dialogStyleLarge(
            //             size: (creditScore > 850 && creditScore <= 950)
            //                 ? 28.sp
            //                 : 14.sp)),
            //     SizedBox(
            //       width: 2.w,
            //     ),
            //   ],
            // ),
          ],
        ),
      );
      // return Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     creditScore >= 750
      //         ? normalText(text: AllStrings.levelCompleteText)
      //         : normalText(
      //             text: AllStrings.notManageCreditScore,
      //           ),
      //     richText(
      //         text1: AllStrings.salaryEarned,
      //         text2: AllStrings.countrySymbol + 6000.toString(),
      //         paddingTop: 2.h),
      //     richText(
      //         text1: AllStrings.billsPaid,
      //         text2: AllStrings.countrySymbol + '${(((bill * 6) / 6000) * 100).floor()}' + '%',
      //         paddingTop: 1.h),
      //     richText(
      //         text1: AllStrings.spentOnNeed,
      //         text2: AllStrings.countrySymbol + '${((need / 6000) * 100).floor()}' + '%',
      //         paddingTop: 1.h),
      //     richText(
      //         text1: AllStrings.spentOnWant,
      //         text2: '${((want / 6000) * 100).floor()}' + '%',
      //         paddingTop: 1.h),
      //     richText(
      //         text1: AllStrings.creditScoreLevel3,
      //         text2: creditScore.toString(),
      //         paddingTop: 1.h),
      //     richText(
      //         text1: AllStrings.moneySaved,
      //         text2: '${((accountBalance / 6000) * 100).floor()}' + '%',
      //         paddingTop: 1.h),
      //     creditScore >= 750
      //         ? buttonStyle(
      //             color: color,
      //             text: AllStrings.playNextLevel,
      //             onPressed: color == AllColors.green
      //                 ? () {}
      //                 : () async {
      //                     _setState(() {
      //                       color = AllColors.green;
      //                     });
      //                     Future.delayed(
      //                         Duration(seconds: 2),
      //                         () => Get.offAll(() => RateUs(
      //                             onSubmit: () => _playLevelOrPopQuiz()
      //                             //     () {
      //                             //   firestore
      //                             //       .collection('Feedback')
      //                             //       .doc()
      //                             //       .set({
      //                             //     'user_id': userId,
      //                             //     'level_name': level,
      //                             //     'rating': userInfo.star,
      //                             //     'feedback': userInfo
      //                             //         .feedbackCon.text
      //                             //         .toString(),
      //                             //   }).then((value) =>
      //                             //           _playLevelOrPopQuiz());
      //                             // },
      //                             )));
      //
      //                     // }
      //                   },
      //           )
      //         : buttonStyle(
      //             color: color,
      //             text: AllStrings.tryAgain,
      //             onPressed: () {
      //               _setState(() {
      //                 color = AllColors.green;
      //               });
      //               bool value = documentSnapshot.get('replay_level');
      //               firestore.collection('User').doc(userId).update({
      //                 'previous_session_info': 'Level_3_setUp_page',
      //                 if (value != true) 'last_level': 'Level_3_setUp_page',
      //               }).then((value) {
      //                 Future.delayed(
      //                   Duration(seconds: 1),
      //                   () => Get.offNamed('/Level3SetUp'),
      //                 );
      //               });
      //             },
      //           ),
      //     SizedBox(height: 1.h),
      //     if (creditScore < 750)
      //       normalText(
      //         text: AllStrings.poorCreditScore,
      //       ),
      //     SizedBox(
      //       height: 2.h,
      //     )
      //   ],
      // );
        },
      ),
    );
  }

  showDialogWhenUse80Credit(int balance, int price, PageController controller,
      int gameScore, int qualityOfLife, int qol2, bool scroll, int index) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.w)),
              actionsPadding: EdgeInsets.all(8.0),
              backgroundColor: AllColors.darkPurple,
              content: Text(
                AllStrings.creditCardUsed80,
                style: AllTextStyles.dialogStyleMedium(),
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (creditBal >= priceOfOption) {
                        firestore.collection('User').doc(userId).update({
                          'score': FieldValue.increment(-50),
                          'credit_score': FieldValue.increment(-50),
                          'credit_card_balance':
                              FieldValue.increment(-priceOfOption),
                          'credit_card_bill':
                              FieldValue.increment(priceOfOption),
                        });
                        controller.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else {
                        int price = priceOfOption;
                        _showDialogCreditBalNotEnough(
                            balance,
                            price,
                            controller,
                            gameScore,
                            qualityOfLife,
                            qol2,
                            scroll,
                            index);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    child: Text(
                      'Ok',
                      style: AllTextStyles.dialogStyleMedium(
                        color: AllColors.darkPurple,
                      ),
                    )),
              ],
            ),
          );
        });
  }
}

class CreditCardPaymentWidget extends StatelessWidget {
  final int creditBill;
  final int payableBill;
  final int intrest;
  final int totalAmount;
  final Color color1;
  final Color color2;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;

  const CreditCardPaymentWidget(
      {Key? key,
      required this.intrest,
      required this.payableBill,
      required this.totalAmount,
      required this.creditBill,
      required this.color1,
      required this.color2,
      required this.onPressed1,
      required this.onPressed2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
        alignment: Alignment.center,
        height: 54.h,
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
              Padding(
                padding: EdgeInsets.only(top: 3.h, left: 3.w, right: 3.w),
                child: Text(
                  AllStrings.creditCard,
                  style: AllTextStyles.dialogStyleExtraLarge(),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.h, left: 6.w, right: 6.w),
                child: Text(
                  AllStrings.creditBill,
                  style: AllTextStyles.dialogStyleMedium(
                      size: 18.sp, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
                child: Center(
                  child: FittedBox(
                    child: RichText(
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                          text: AllStrings.currentBill,
                          style: AllTextStyles.dialogStyleLarge(),
                          children: [
                            TextSpan(
                              text: AllStrings.countrySymbol +
                                  creditBill.toString(),
                              style: AllTextStyles.dialogStyleLarge(
                                color: AllColors.darkYellow,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w),
                child: Center(
                  child: FittedBox(
                    child: RichText(
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                          text: AllStrings.pastDue,
                          style: AllTextStyles.dialogStyleLarge(),
                          children: [
                            TextSpan(
                                text: AllStrings.countrySymbol +
                                    payableBill.ceil().toString(),
                                style: AllTextStyles.dialogStyleLarge(
                                  color: AllColors.darkYellow,
                                )),
                          ]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w),
                child: Center(
                  child: FittedBox(
                    child: RichText(
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                          text: AllStrings.interestOnPastDue,
                          style: AllTextStyles.dialogStyleLarge(),
                          children: [
                            TextSpan(
                              text: AllStrings.countrySymbol +
                                  intrest.ceil().toString(),
                              style: AllTextStyles.dialogStyleLarge(
                                color: AllColors.darkYellow,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 62.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                        color: color1,
                        borderRadius: BorderRadius.circular(12.w)),
                    child: TextButton(
                        onPressed: onPressed1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Center(
                            child: FittedBox(
                              child: RichText(
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                    text: AllStrings.payFull,
                                    style: AllTextStyles.dialogStyleLarge(
                                        color: color1 == AllColors.green
                                            ? Colors.white
                                            : AllColors.darkBlue),
                                    children: [
                                      TextSpan(
                                        text: AllStrings.countrySymbol +
                                            totalAmount.toString(),
                                        style: AllTextStyles.dialogStyleLarge(
                                          color: color1 == AllColors.green
                                              ? Colors.white
                                              : AllColors.darkYellow,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        )),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 62.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                        color: color2,
                        borderRadius: BorderRadius.circular(12.w)),
                    child: TextButton(
                        onPressed: onPressed2,
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Center(
                            child: FittedBox(
                              child: RichText(
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                    text: AllStrings.payMin,
                                    style: AllTextStyles.dialogStyleLarge(
                                        color: color2 == AllColors.green
                                            ? Colors.white
                                            : AllColors.darkBlue),
                                    children: [
                                      TextSpan(
                                        text: AllStrings.countrySymbol +
                                            (totalAmount * 10 ~/ 100)
                                                .toInt()
                                                .ceil()
                                                .toString(),
                                        style: AllTextStyles.dialogStyleLarge(
                                          color: color2 == AllColors.green
                                              ? Colors.white
                                              : AllColors.yellow,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        )),
                  )),
              SizedBox(
                height: 2.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}

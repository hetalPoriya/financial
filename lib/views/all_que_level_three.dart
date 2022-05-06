import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/controllers/UserInfoController.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/LevelFourSetUpPage.dart';
import 'package:financial/views/LevelThreeSetUpPage.dart';
import 'package:financial/views/PopQuiz.dart';
import 'package:financial/views/RateUs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'LocalNotifyManager.dart';

class AllQueLevelThree extends StatefulWidget {
  const AllQueLevelThree({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelThreeState createState() => _AllQueLevelThreeState();
}

class _AllQueLevelThreeState extends State<AllQueLevelThree> {
  //user value
  var userId;
  var document;
  int levelId = 0;
  String level = '';
  int balance = 0;
  int qualityOfLife = 0;
  int gameScore = 0;
  int creditScore = 0;
  int score = 0;
  int priceOfOption = 0;
  String option = '';
  int creditBill = 0;
  int creditBal = 0;
  int payableBill = 0;
  int updateValue = 0;

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
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // LocalNotifyManager localNotifyManager = LocalNotifyManager.init();
  //for option selection
  bool flag1 = false;
  bool flag2 = false;
  bool scroll = true;
  List<int> payArray = [];
  Color color = Colors.white;
  bool flagForKnow = false;
  final storeValue = GetStorage();

  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  final userInfo = Get.put<UserInfoController>(UserInfoController());

  Future<QueModel?> getLevelId() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
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
        await FirebaseFirestore.instance.collection("Level_3").get();
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

                            if ((document['week'] % 4 == 0) &&
                                document['week'] != 0) _creditCardBillPayment();

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
      () {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_3_setUp_page',
          'bill_payment': 0,
          'credit_card_bill': 500,
          'account_balance': 0,
          'quality_of_life': 0,
          'level_id': 0
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
        'Ok',
        () {
          Future.delayed(Duration(seconds: 1), () => Get.back()).then((value) {
            if (balance >= price) {
              balance = ((balance - price) as int?)!;
              firestore.collection('User').doc(userId).update({
                'account_balance': balance,
                'quality_of_life': FieldValue.increment(qol2),
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
        'Ok',
        () {
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
              controller.nextPage(
                  duration: Duration(seconds: 1), curve: Curves.easeIn);
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
                              _setState(() {
                                color = AllColors.green;
                              });
                              payArray.add(currentIndex);
                              DocumentSnapshot doc = await firestore
                                  .collection('User')
                                  .doc(userId)
                                  .get();
                              balance = doc.get('account_balance');
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

  _creditCardBillPayment() async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    balance = snap.get('account_balance');
    payableBill = snap.get('payable_bill');
    creditBill = snap.get('credit_card_bill');
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
                              if (totalAmount.ceil() != 0 &&
                                  balance >= totalAmount.ceil()) {
                                balance = balance - totalAmount.ceil();
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
                                  'credit_score': (score + 200 + 40)
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
                                  'credit_score': (score + value.ceil() + 40)
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
    int bal = snap.get('account_balance');
    int qol = snap.get('quality_of_life');
    int credit = snap.get('credit_score');
    level = snap.get('last_level');
    level = level.toString().substring(6, 7);
    int lev = int.parse(level);

    return popQuizDialog(() {
      Future.delayed(Duration(seconds: 2), () async {
        if (lev == 2 && value == true) {
          firestore
              .collection('User')
              .doc(userId)
              .update({'replay_level': false});
        }
        firestore.collection("User").doc(userId).update({
          'previous_session_info': 'Level_3_Pop_Quiz',
          'level_id': 0,
          if (value != true) 'last_level': 'Level_3_Pop_Quiz',
        });
        Get.off(
          () => PopQuiz(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      });
    }, () async {
      // await flutterLocalNotificationsPlugin.cancel(23);
      // await localNotifyManager.repeatNotificationLevel4();
      await localNotifyManager.flutterLocalNotificationsPlugin.cancel(3);
      await localNotifyManager.flutterLocalNotificationsPlugin.cancel(9);
      await localNotifyManager
          .scheduleNotificationForLevelFourSaturdayElevenAm();
      await localNotifyManager
          .scheduleNotificationForLevelFourWednesdaySevenPm();
      firestore.collection('User').doc(userId).update({
        'previous_session_info': 'Level_4_setUp_page',
        'level_id': 0,
        'level_3_balance': bal,
        'level_3_qol': qol,
        'level_3_creditScore': credit,
        if (value != true) 'last_level': 'Level_4_setUp_page',
        // 'previous_session_info': 'Coming_soon',
      }).then((value) => Get.off(
            () => LevelFourSetUpPage(),
            //() => ComingSoon(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          ));
    });
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
    if (index == snapshot.data!.docs.length - 1) {
      firestore.collection('User').doc(userId).update({
        'level_id': index + 1,
        'level_3_id': index + 1,
      }).then((value) {
        Future.delayed(
            Duration(seconds: 1),
            () => calculationForProgress(() {
                  Get.back();
                  _levelCompleteSummary();
                }));
      });
    }

    if (balance >= 0 && creditBal >= 0) {
      if (option.toString().trim().length >= 11 &&
          option.toString().substring(0, 11) == 'Credit Card') {
        double c = 2000 * 80 / 100;
        c = 2000 - c;
        if (creditBal <= c) {
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
                            if (creditBal >= priceOfOption) {
                              firestore.collection('User').doc(userId).update({
                                'score': FieldValue.increment(-50),
                                'credit_score': FieldValue.increment(-50),
                                'credit_card_balance':
                                    FieldValue.increment(-priceOfOption),
                                'credit_card_bill':
                                    FieldValue.increment(priceOfOption),
                              });
                              Get.back();
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
                'score': creditCount >= 0
                    ? FieldValue.increment(10)
                    : FieldValue.increment(0),
              });
            });
          });
          controller.nextPage(
              duration: Duration(seconds: 1), curve: Curves.easeIn);
        } else {
          int price = priceOfOption;
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
      child: SingleChildScrollView(child: StatefulBuilder(
        builder: (context, _setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              creditScore >= 750
                  ? normalText(AllStrings.levelCompleteText)
                  : normalText(
                      AllStrings.notManageCreditScore,
                    ),
              richText(AllStrings.salaryEarned, '\$' + 6000.toString(), 2.h),
              richText(AllStrings.billsPaid,
                  '\$' + '${(((bill * 6) / 6000) * 100).floor()}' + '%', 1.h),
              richText(AllStrings.spentOnNeed,
                  '\$' + '${((need / 6000) * 100).floor()}' + '%', 1.h),
              richText(AllStrings.spentOnWant,
                  '${((want / 6000) * 100).floor()}' + '%', 1.h),
              richText(
                  AllStrings.creditScoreLevel3, creditScore.toString(), 1.h),
              richText(AllStrings.moneySaved,
                  '${((accountBalance / 6000) * 100).floor()}' + '%', 1.h),
              creditScore >= 750
                  ? buttonStyle(
                      color,
                      AllStrings.playNextLevel,
                      color == AllColors.green
                          ? () {}
                          : () async {
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
                                        }).then((value) =>
                                                _playLevelOrPopQuiz());
                                      }, )));

                              // }
                            },
                    )
                  : buttonStyle(
                      color,
                      AllStrings.tryAgain,
                      () {
                        _setState(() {
                          color = AllColors.green;
                        });
                        bool value = documentSnapshot.get('replay_level');
                        firestore.collection('User').doc(userId).update({
                          'previous_session_info': 'Level_3_setUp_page',
                          if (value != true) 'last_level': 'Level_3_setUp_page',
                        }).then((value) {
                          Future.delayed(
                            Duration(seconds: 1),
                            () => Get.offNamed('/Level3SetUp'),
                          );
                        });
                      },
                    ),
              SizedBox(height: 1.h),
              if (creditScore < 750)
                normalText(
                  AllStrings.poorCreditScore,
                ),
              SizedBox(
                height: 2.h,
              )
            ],
          );
        },
      )),
    );
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
                              text: '\$' + creditBill.toString(),
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
                                text: '\$' + payableBill.ceil().toString(),
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
                              text: '\$' + intrest.ceil().toString(),
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
                                        text: '\$' + totalAmount.toString(),
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
                                        text: '\$' +
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

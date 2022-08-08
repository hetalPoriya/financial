import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/models/que_model.dart';
import 'package:financial/views/coming_soon.dart';
import 'package:financial/views/rate_us.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';
import '../../cutom_screens/custom_screens.dart';
import '../../cutom_screens/level_summary_screen.dart';
import '../../utils/utils.dart';
import '../popQuiz/popQuiz.dart';
import '../setupPage/setup_page.dart';

class AllQueLevelFour extends StatefulWidget {
  const AllQueLevelFour({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelFourState createState() => _AllQueLevelFourState();
}

class _AllQueLevelFourState extends State<AllQueLevelFour> {
  int priceOfOption = 0;
  String option = '';
  int? bill;
  bool? homeRent = false;
  int investment = 0;

  //get bill data
  int rentPrice = 0;
  int transportPrice = 0;
  int lifestylePrice = 0;
  int fund = 0;
  int count = 0;

  final userInfo = Get.put<UserInfoController>(UserInfoController());

  PageController controllerForInner = PageController();
  int currentIndex = 0;
  int totalMutualFund = 0;
  int lastMonthIncDecValue = 0;
  int lastMonthIncDecPer = 0;
  int? randomNumberTotalPositive;
  Random rnd = Random();

  //for Monthly Discretionary Fund
  List<String> fundName = ['Mutual Fund'];
  List<int> fundAllocation = [0];

  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  getAllData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Level_4").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      queModel = QueModel();
      queModel?.id = a['id'];
      setState(() {
        list.add(queModel!);
      });
    }

    await Prefs.setInt(PrefString.count, 0);
    rentPrice = Prefs.getInt(PrefString.rentPrice)!;
    transportPrice = Prefs.getInt(PrefString.transportPrice)!;
    lifestylePrice = Prefs.getInt(PrefString.lifestylePrice)!;
    count = Prefs.getInt(PrefString.count)!;

    if (count == null) {
      count = 0;
    }

    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    totalMutualFund = snapshot.get('mutual_fund');
    int levelId = snapshot.get('level_id');
    if (levelId == 0) {
      print('eeneeee');
      incDesPer = [];
      await Prefs.remove(PrefString.graphValue);
    } else {
      List<String>? savedStrList = Prefs.getStringList(PrefString.graphValue);
      incDesPer = savedStrList?.map((i) => int.parse(i)).toList() ?? [];
    }
    randomNumberTotalPositive = Prefs.getInt(PrefString.randomNumberValue)!;
    controllerForInner = PageController(
        initialPage: Prefs.getInt(PrefString.level4or5innerPageViewId)!);
    print('Random Value ${Prefs.getInt(PrefString.level4or5innerPageViewId)}');

    billPayment = (billPayment / 2).floor();

    setState(() {});
    return null;
  }

  @override
  void initState() {
    super.initState();
    getLevelId().then((value) => getAllData());
  }

  @override
  Widget build(BuildContext context) {
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
                  .collection('Level_4')
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
                                  await Prefs.setInt(
                                      PrefString.level4or5innerPageViewId, 0);
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
                                    count = count + 1;
                                    await Prefs.setInt(PrefString.count, count);

                                    if (count == 12) {
                                      count = 0;
                                      await Prefs.setInt(PrefString.count, 0);
                                      showDialogToShowIncreaseRent();
                                      Future.delayed(
                                          Duration(milliseconds: 400), () {
                                        rentPrice =
                                            Prefs.getInt(PrefString.rentPrice)!;
                                        transportPrice = Prefs.getInt(
                                            PrefString.transportPrice)!;

                                        lifestylePrice = Prefs.getInt(
                                            PrefString.lifestylePrice)!;
                                      });
                                    }
                                  }
                                },
                                // physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  controllerForInner = PageController(
                                      initialPage: Prefs.getInt(PrefString
                                          .level4or5innerPageViewId)!);
                                  document = snapshot.data!.docs[index];
                                  return document['card_type'] == 'GameQuestion'
                                      ? PageView.builder(
                                          itemCount: 3,
                                          scrollDirection: Axis.vertical,
                                          controller: controllerForInner,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          onPageChanged: (value) async {
                                            DocumentSnapshot doc =
                                                await firestore
                                                    .collection('User')
                                                    .doc(userId)
                                                    .get();
                                            if (currentIndex == 1) {
                                              await Prefs.setInt(
                                                  PrefString
                                                      .level4or5innerPageViewId,
                                                  1);

                                              totalMutualFund =
                                                  doc.get('mutual_fund');
                                              bill = doc.get('bill_payment');
                                              investment =
                                                  doc.get('investment');
                                            }
                                            if (currentIndex == 2) if (index !=
                                                0) {
                                              balance =
                                                  doc.get('account_balance');
                                              await Prefs.setInt(
                                                  PrefString
                                                      .level4or5innerPageViewId,
                                                  2);

                                              _showDialogOfMutualFund(
                                                  _setState);
                                            }
                                          },
                                          itemBuilder: (context, ind) {
                                            Color color = Colors.white;
                                            currentIndex = ind;
                                            if (currentIndex == 0) {
                                              setInnerValue();
                                            }
                                            return ind == 0
                                                ? DayOrWeekWidget(
                                                    document: document,
                                                    level: level,
                                                    containerWidget:
                                                        GameQuestionContainer(
                                                      level: level,
                                                      document: document,
                                                      description: document[
                                                          'description'],
                                                      option1:
                                                          document['option_1'],
                                                      option2:
                                                          document['option_2'],
                                                      color1: list[index]
                                                                  .isSelected1 ==
                                                              true
                                                          ? AllColors.green
                                                          : Colors.white,
                                                      color2: list[index]
                                                                  .isSelected2 ==
                                                              true
                                                          ? AllColors.green
                                                          : Colors.white,
                                                      textStyle1: AllTextStyles
                                                          .gameQuestionOptionText(
                                                        color: list[index]
                                                                    .isSelected1 ==
                                                                true
                                                            ? Colors.white
                                                            : AllColors.yellow,
                                                      ),
                                                      textStyle2: AllTextStyles
                                                          .gameQuestionOptionText(
                                                        color: list[index]
                                                                    .isSelected2 ==
                                                                true
                                                            ? Colors.white
                                                            : AllColors.yellow,
                                                      ),
                                                      onPressed1: list[index]
                                                                      .isSelected2 ==
                                                                  true ||
                                                              list[index]
                                                                      .isSelected1 ==
                                                                  true
                                                          ? () {}
                                                          : () async {
                                                              _setState(() {
                                                                flag1 = true;
                                                              });
                                                              if (flag2 ==
                                                                  false) {
                                                                DocumentSnapshot
                                                                    snap =
                                                                    await firestore
                                                                        .collection(
                                                                            'User')
                                                                        .doc(
                                                                            userId)
                                                                        .get();

                                                                list[index]
                                                                        .isSelected1 =
                                                                    true;
                                                                balance = snap.get(
                                                                    'account_balance');
                                                                option = document[
                                                                    'option_1'];
                                                                priceOfOption =
                                                                    document[
                                                                        'option_1_price'];
                                                                var category =
                                                                    document[
                                                                        'category'];
                                                                int qol1 = document[
                                                                    'quality_of_life_1'];
                                                                _optionSelect(
                                                                    balance,
                                                                    _setState,
                                                                    priceOfOption,
                                                                    index,
                                                                    snapshot,
                                                                    category,
                                                                    qol1);
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg: AllStrings
                                                                        .optionAlreadySelected);
                                                              }
                                                            },
                                                      onPressed2: list[index]
                                                                      .isSelected2 ==
                                                                  true ||
                                                              list[index]
                                                                      .isSelected1 ==
                                                                  true
                                                          ? () {}
                                                          : () async {
                                                              _setState(() {
                                                                flag2 = true;
                                                              });
                                                              if (flag1 ==
                                                                  false) {
                                                                DocumentSnapshot
                                                                    snap =
                                                                    await firestore
                                                                        .collection(
                                                                            'User')
                                                                        .doc(
                                                                            userId)
                                                                        .get();

                                                                list[index]
                                                                        .isSelected2 =
                                                                    true;
                                                                balance = snap.get(
                                                                    'account_balance');
                                                                option = document[
                                                                    'option_2'];
                                                                priceOfOption =
                                                                    document[
                                                                        'option_2_price'];
                                                                var category =
                                                                    document[
                                                                        'category'];
                                                                int qol2 = document[
                                                                    'quality_of_life_2'];
                                                                _optionSelect(
                                                                    balance,
                                                                    _setState,
                                                                    priceOfOption,
                                                                    index,
                                                                    snapshot,
                                                                    category,
                                                                    qol2);
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg: AllStrings
                                                                        .optionAlreadySelected);
                                                              }
                                                            },
                                                    ),
                                                  )
                                                : (ind == 1)
                                                    ? DayOrWeekWidget(
                                                        document: document,
                                                        level: level,
                                                        containerWidget:
                                                            StatefulBuilder(
                                                          builder: (context,
                                                              _setState) {
                                                            return BillPaymentWidget(
                                                              color: color,
                                                              billPayment: (rentPrice +
                                                                      transportPrice +
                                                                      lifestylePrice)
                                                                  .toString(),
                                                              forPlan1: rentPrice
                                                                  .toString(),
                                                              forPlan2:
                                                                  transportPrice
                                                                      .toString(),
                                                              forPlan3:
                                                                  lifestylePrice
                                                                      .toString(),
                                                              forPlan4: (rentPrice +
                                                                      transportPrice +
                                                                      lifestylePrice)
                                                                  .toString(),
                                                              text1:
                                                                  'House Rent ',
                                                              text2:
                                                                  'Transport ',
                                                              text3:
                                                                  'Lifestyle ',
                                                              text4:
                                                                  ' Total Bill ',
                                                              onPressed: color ==
                                                                      AllColors
                                                                          .green
                                                                  ? () {}
                                                                  : () async {
                                                                      DocumentSnapshot snap = await firestore
                                                                          .collection(
                                                                              'User')
                                                                          .doc(
                                                                              userId)
                                                                          .get();
                                                                      _setState(
                                                                          () {
                                                                        color =
                                                                            AllColors.green;
                                                                        balance =
                                                                            snap.get('account_balance');
                                                                        bill = snap
                                                                            .get('bill_payment');
                                                                        qualityOfLife =
                                                                            snap.get('quality_of_life');
                                                                        balance =
                                                                            balance -
                                                                                bill!;
                                                                      });
                                                                      if (balance >=
                                                                          0) {
                                                                        firestore
                                                                            .collection('User')
                                                                            .doc(userId)
                                                                            .update({
                                                                          'account_balance':
                                                                              balance,
                                                                          'game_score': gameScore +
                                                                              balance +
                                                                              qualityOfLife,
                                                                          'quality_of_life':
                                                                              FieldValue.increment(billPayment),
                                                                          'level_4_balance':
                                                                              balance,
                                                                          'level_4_qol':
                                                                              FieldValue.increment(billPayment),
                                                                        }).then((value) {
                                                                          print(
                                                                              'Inner $controllerForInner');
                                                                          controllerForInner.nextPage(
                                                                              duration: Duration(milliseconds: 800),
                                                                              curve: Curves.easeIn);
                                                                        });
                                                                      } else {
                                                                        _showDialogForRestartLevel();
                                                                      }
                                                                    },
                                                            );
                                                          },
                                                        ))
                                                    : DayOrWeekWidget(
                                                        level: level,
                                                        document: document,
                                                        containerWidget:
                                                            StatefulBuilder(
                                                          builder: (context,
                                                              _setState) {
                                                            return FundAllocationScreen(
                                                              netWorth:
                                                                  investment,
                                                              color: color,
                                                              lastMonthIncDecValue:
                                                                  lastMonthIncDecValue,
                                                              totalMutualFund:
                                                                  totalMutualFund,
                                                              widget: StatefulBuilder(
                                                                  builder: (context,
                                                                      _setState) {
                                                                return ListView
                                                                    .builder(
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Column(
                                                                      children: [
                                                                        Text(
                                                                            fundName[index]
                                                                                .toString(),
                                                                            style:
                                                                                AllTextStyles.workSansLarge().copyWith(fontSize: 16.sp)),
                                                                        SizedBox(
                                                                          height:
                                                                              1.h,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            GestureDetector(
                                                                              child: Container(
                                                                                height: 5.h,
                                                                                width: 12.w,
                                                                                child: Icon(
                                                                                  Icons.remove,
                                                                                  color: AllColors.lightGrey,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(2.w),
                                                                                    bottomLeft: Radius.circular(2.w),
                                                                                  ),
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              onTap: () async {
                                                                                if (fundAllocation[index] != 0) {
                                                                                  _setState(() {
                                                                                    fundAllocation[index] = fundAllocation[index] - 100;
                                                                                    firestore.collection('User').doc(userId).update({
                                                                                      'account_balance': FieldValue.increment(100),
                                                                                    });
                                                                                  });
                                                                                }
                                                                              },
                                                                            ),
                                                                            Container(
                                                                              width: 26.w,
                                                                              height: 5.h,
                                                                              child: Text(fundAllocation[index].toString(), style: AllTextStyles.workSansSmallBlack().copyWith(fontWeight: FontWeight.w400, fontSize: 12.sp)),
                                                                              alignment: Alignment.center,
                                                                              color: AllColors.lightYellow,
                                                                            ),
                                                                            GestureDetector(
                                                                              child: Container(
                                                                                height: 5.h,
                                                                                width: 12.w,
                                                                                child: Icon(
                                                                                  Icons.add,
                                                                                  color: AllColors.lightGrey,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomRight: Radius.circular(2.w),
                                                                                    topRight: Radius.circular(2.w),
                                                                                  ),
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              onTap: () async {
                                                                                DocumentSnapshot snap = await firestore.collection('User').doc(userId).get();
                                                                                int accountBalance = snap.get('account_balance');
                                                                                print('account $accountBalance');
                                                                                if (accountBalance > 0) {
                                                                                  _setState(() {
                                                                                    fundAllocation[index] = fundAllocation[index] + 100;
                                                                                    firestore.collection('User').doc(userId).update({
                                                                                      'account_balance': FieldValue.increment(-100),
                                                                                    });
                                                                                  });
                                                                                }else{
                                                                                  Fluttertoast.showToast(msg: 'Please check your balance');
                                                                                }
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              1.h,
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                  itemCount:
                                                                      fundName
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                );
                                                              }),
                                                              onPressed: color ==
                                                                      AllColors
                                                                          .green
                                                                  ? () {}
                                                                  : () async {
                                                                      DocumentSnapshot snap = await firestore
                                                                          .collection(
                                                                              'User')
                                                                          .doc(
                                                                              userId)
                                                                          .get();
                                                                      _setState(
                                                                          () {
                                                                        color =
                                                                            AllColors.green;
                                                                        fund =
                                                                            0;
                                                                        balance =
                                                                            snap.get('account_balance');
                                                                        qualityOfLife =
                                                                            snap.get('quality_of_life');
                                                                        fund =
                                                                            fundAllocation[0];
                                                                      });
                                                                      if (balance >=
                                                                          0) {
                                                                        print(
                                                                            'BalanceMy1 $balance');
                                                                        firestore
                                                                            .collection('User')
                                                                            .doc(userId)
                                                                            .update({
                                                                          'game_score': gameScore +
                                                                              balance +
                                                                              qualityOfLife,
                                                                          'mutual_fund':
                                                                              FieldValue.increment(fundAllocation[0]),
                                                                          'level_4_investment':
                                                                              FieldValue.increment(fundAllocation[0]),
                                                                          'investment':
                                                                              FieldValue.increment(fundAllocation[0]),
                                                                          'level_4_balance':
                                                                              balance,
                                                                          'level_4_qol':
                                                                              qualityOfLife,
                                                                          'level_id':
                                                                              index + 1,
                                                                          'level_4_id':
                                                                              index + 1,
                                                                        }).then((value) async {
                                                                          balance =
                                                                              balance + 2000;
                                                                          print(
                                                                              'BalanceMy $balance');
                                                                          firestore
                                                                              .collection('User')
                                                                              .doc(userId)
                                                                              .update({
                                                                            'account_balance':
                                                                                FieldValue.increment(2000),
                                                                            'level_4_balance':
                                                                                balance,
                                                                            'game_score': gameScore +
                                                                                balance +
                                                                                qualityOfLife,
                                                                          });
                                                                          fund =
                                                                              0;
                                                                          int value =
                                                                              Prefs.getInt(PrefString.level4or5innerPageViewId)!;

                                                                          if (index == snapshot.data!.docs.length - 1 &&
                                                                              value == 2) {
                                                                            firestore.collection('User').doc(userId).update({
                                                                              'level_id': index + 1,
                                                                              'level_4_id': index + 1,
                                                                            }).then((value) => Future.delayed(
                                                                                Duration(seconds: 1),
                                                                                () => calculationForProgress(onPressed: () {
                                                                                      Get.back();
                                                                                      _levelCompleteSummary();
                                                                                    })));
                                                                          } else {
                                                                            controller.nextPage(
                                                                                duration: Duration(milliseconds: 800),
                                                                                curve: Curves.easeIn);
                                                                            await Prefs.setInt(PrefString.level4or5innerPageViewId,
                                                                                0);
                                                                          }
                                                                        });
                                                                        fundAllocation =
                                                                            [0];
                                                                      } else {
                                                                        _showDialogForRestartLevel();
                                                                      }
                                                                    },
                                                            );
                                                          },
                                                        ));
                                          },
                                        )
                                      : DayOrWeekWidget(
                                          document: document,
                                          level: level,
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
                                              firestore
                                                  .collection('User')
                                                  .doc(userId)
                                                  .update({
                                                'level_id': index + 1,
                                                'level_4_id': index + 1,
                                              }).then((value) {
                                                controller.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 800),
                                                    curve: Curves.easeIn);
                                              });
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

  _showDialogForRestartLevel() {
    restartLevelDialog(
      onPressed: () {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_4_setUp_page',
          'level_id': 0,
          'level_4_investment': 0,
          'level_4_balance': 0,
          'level_4_qol': 0
        }).then((value) => Get.off(
              () => LevelFourSetUpPage(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
            ));
      },
    );
  }

  _showDialogOfMutualFund(StateSetter setStateWidget) async {
    Color color = Colors.white;

    DocumentSnapshot doc = await firestore.collection('User').doc(userId).get();
    int number = 0;
    investment = 0;

    randomNumberTotalPositive = Prefs.getInt(PrefString.randomNumberValue);
    print('Random Value $randomNumberTotalPositive');
    totalMutualFund = doc.get('mutual_fund');
    investment = doc.get('investment');
    if (totalMutualFund == 0) {
      number = 0;
    } else {
      number = randomNumberTotalPositive! <= 15
          ? rnd.nextInt(15 + 5) - 15
          : rnd.nextInt(16);

      if (number <= 0) {
        print('Enter Under');
        await Prefs.setInt(
            PrefString.randomNumberValue, randomNumberTotalPositive! + 1);
      }
    }

    lastMonthIncDecPer = (investment * number) ~/ 100;
    lastMonthIncDecValue = investment + (lastMonthIncDecPer);
    incDesPer.add(lastMonthIncDecValue);
    List<String> stringsList = incDesPer.map((i) => i.toString()).toList();
    await Prefs.setStringList(PrefString.graphValue, stringsList);
    print('IncDec $incDesPer');
    setStateWidget(() {});

    firestore.collection('User').doc(userId).update({
      'investment': lastMonthIncDecValue,
    });

    //.update({'mutual_fund': lastMonthIncDecValue});
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
                container:
                    //Container()
                    StatefulBuilder(
                  builder: (context, _setState) {
                    return DayOrWeekWidget(
                      level: level,
                      document: document,
                      containerWidget: MutualFundWidget(
                        color: color,
                        lastMonthIncDecPer: lastMonthIncDecPer,
                        lastMonthIncDecValue: lastMonthIncDecValue,
                        number: number,
                        netWorth: investment,
                        totalMutualFund: totalMutualFund,
                        onPressed: color == AllColors.green
                            ? () {}
                            : () {
                                _setState(() {
                                  color = AllColors.green;
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

  _optionSelect(
    int balance,
    StateSetter setState1,
    int priceOfOption,
    int index,
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
    category,
    int qol2,
  ) async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    setState1(() {
      balance = snap.get('account_balance');
    });
    if (balance >= priceOfOption) {
      setState1(() {
        balance = balance - priceOfOption;
      });
      firestore.collection('User').doc(userId).update({
        'account_balance': FieldValue.increment(-priceOfOption),
        'quality_of_life': FieldValue.increment(qol2),
        'game_score': gameScore + balance + qol2,
        'need': category == 'Need'
            ? FieldValue.increment(priceOfOption)
            : FieldValue.increment(0),
        'want': category == 'Want'
            ? FieldValue.increment(priceOfOption)
            : FieldValue.increment(0),
        'level_4_balance': FieldValue.increment(-priceOfOption),
        'level_4_qol': FieldValue.increment(qol2),
      }).then((value) {
        controllerForInner.nextPage(
            duration: Duration(milliseconds: 800), curve: Curves.easeIn);
      });
    } else {
      _showDialogForRestartLevel();
    }
  }

  _levelCompleteSummary() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();

    int accountBalance = documentSnapshot['account_balance'];
    int netWorth = documentSnapshot['investment'];

    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: (accountBalance + netWorth) >= 30000
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
                          height: 2.h,
                        ),
                        summary(documentSnapshot)
                      ],
                    )),
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
    if (lev == 4 && value == true) {
      firestore.collection('User').doc(userId).update({'replay_level': false});
    }
    return popQuizDialog(
      onPlayPopQuizPressed: () async {
        Future.delayed(Duration(seconds: 1), () async {
          inviteDialog().then((value) {
            _whenLevelComplete(value: value, levelOrPopQuiz: 'Level_4_Pop_Quiz')
                .then((value) => Get.offAll(LevelsPopQuiz()));
          });
        });
      },
      onPlayNextLevelPressed: () async {
        Future.delayed(Duration(seconds: 1), () async {
          inviteDialog().then((value) {
            _whenLevelComplete(value: value, levelOrPopQuiz: 'Level_4')
                .then((value) => Get.offAll(ComingSoon()));
          });
        });
      },
    );
  }

  Future _whenLevelComplete({bool? value, String? levelOrPopQuiz}) {
    return firestore.collection('User').doc(userId).update({
      'previous_session_info': levelOrPopQuiz,
      'account_balance': 0,
      'bill_payment': 0,
      'level_id': 0,
      'quality_of_life': 0,
      'need': 0,
      'want': 0,
      'mutual_fund': 0,
      'home_loan': 0,
      'transport_loan': 0,
      'investment': 0,
      if (value != true) 'last_level': levelOrPopQuiz,
    });
    // LocalNotifyManager.init();
    // await localNotifyManager.configureLocalTimeZone();
    // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(4);
    // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(10);
  }

  summary(DocumentSnapshot<Object?> documentSnapshot) {
    int accountBalance = documentSnapshot['account_balance'];
    int netWorth = documentSnapshot['investment'];
    int mutualFund = documentSnapshot['mutual_fund'];

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
          if (netWorth.isNaN ||
              netWorth.isInfinite ||
              mutualFund.isNaN ||
              mutualFund.isInfinite) {
            _setState(() {
              netWorth = 0;
              mutualFund = 0;
            });
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (accountBalance + netWorth) >= 30000
                  ? normalText(text: AllStrings.level4SummaryTitleWhenComplete)
                  : normalText(text: AllStrings.level4SummaryTitleWhenLose),
              richText(
                  text1: AllStrings.salaryEarned,
                  text2: AllStrings.countrySymbol + 60000.toString(),
                  paddingTop: 2.h),
              richText(
                  text1: AllStrings.totalMfInvestment,
                  text2: mutualFund.toString(),
                  paddingTop: 1.h),
              // (((netWorth - mutualFund) / mutualFund) * 100 == null)
              netWorth == 0 && mutualFund == 0
                  ? richText(
                      text1: AllStrings.returnOnInvestment,
                      text2: 0.toString(),
                      paddingTop: 1.h)
                  : richText(
                      text1: AllStrings.returnOnInvestment,
                      text2:
                          '${(((netWorth - mutualFund) / mutualFund) * 100).floor()}' +
                              '%',
                      paddingTop: 1.h),
              richText(
                  text1: AllStrings.moneySaved,
                  text2: '${((accountBalance / 60000) * 100).floor()}' + '%',
                  paddingTop: 1.h),
              (accountBalance + netWorth) >= 30000
                  ? buttonStyle(
                      color: color,
                      text: AllStrings.playNextLevel,
                      onPressed: color == AllColors.green
                          ? () {}
                          : () async {
                              bool? value;
                              DocumentSnapshot snap = await firestore
                                  .collection('User')
                                  .doc(userId)
                                  .get();
                              _setState(() {
                                color = AllColors.green;
                                value = snap.get('replay_level');
                              });
                              Future.delayed(
                                  Duration(milliseconds: 500),
                                  () => Get.offAll(() => RateUs(
                                      onSubmit: () => _playLevelOrPopQuiz()
                                      // {
                                      //   firestore
                                      //       .collection('Feedback')
                                      //       .doc()
                                      //       .set({
                                      //     'user_id': userInfo.userId,
                                      //     'level_name': userInfo.level,
                                      //     'rating': userInfo.star,
                                      //     'feedback': userInfo.feedbackCon.text
                                      //         .toString(),
                                      //   }).then((value) =>
                                      //           _playLevelOrPopQuiz());
                                      // }
                                      )));
                            },
                    )
                  : buttonStyle(
                      color: color,
                      text: AllStrings.tryAgain,
                      onPressed: () {
                        _setState(() {
                          color = AllColors.green;
                        });
                        bool value = documentSnapshot.get('replay_level');
                        documentSnapshot.get('account_balance');
                        Future.delayed(Duration(seconds: 1), () {
                          firestore.collection('User').doc(userId).update({
                            'previous_session_info': 'Level_4_setUp_page',
                            if (value != true)
                              'last_level': 'Level_4_setUp_page',
                          }).then((value) {
                            Get.offNamed('/Level4SetUp');
                          });
                        });
                      },
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

  setInnerValue() async {
    await Prefs.setInt(PrefString.level4or5innerPageViewId, 0);
  }
}

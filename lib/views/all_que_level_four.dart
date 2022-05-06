import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/controllers/UserInfoController.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/LevelFourSetUpPage.dart';
import 'package:financial/views/LocalNotifyManager.dart';
import 'package:financial/views/PopQuiz.dart';
import 'package:financial/views/RateUs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

class AllQueLevelFour extends StatefulWidget {
  const AllQueLevelFour({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelFourState createState() => _AllQueLevelFourState();
}

class _AllQueLevelFourState extends State<AllQueLevelFour> {
  int levelId = 0;
  String level = '';
  int qualityOfLife = 0;
  int qolBill = 0;
  int gameScore = 0;
  int balance = 0;
  var document;
  int priceOfOption = 0;
  String option = '';
  var userId;
  int? bill;
  bool? homeRent = false;

  //get bill data
  int rentPrice = 0;
  int transportPrice = 0;
  int lifestylePrice = 0;
  int fund = 0;
  int count = 0;

  // //home rent/emi
  // String? home;
  // String? transport;
  // int homeLoan = 0;
  // int transportLoan = 0;
  // int totalFundAmount = 0;
  final userInfo = Get.find<UserInfoController>();

  //page controller
  PageController controller = PageController();
  PageController controllerForInner = PageController();
  int currentIndex = 0;
  int totalMutualFund = 0;
  int lastMonthIncDecValue = 0;
  int lastMonthIncDecPer = 0;
  int? randomNumberTotalPositive;
  Random rnd = Random();

  //for option selection
  bool flag1 = false;
  bool flag2 = false;
  bool flagForKnow = false;
  Color color = Colors.white;

  //for Monthly Discretionary Fund
  List<String> fundName = ['Mutual Fund'];
  List<int> fundAllocation = [0];

  final storeValue = GetStorage();

  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  int investment = 0;

  int updateValue = 0;

  Future<QueModel?> getLevelId() async {
    storeValue.write('count', 0);
    rentPrice = storeValue.read('rentPrice')!;
    transportPrice = storeValue.read('transportPrice')!;
    lifestylePrice = storeValue.read('lifestylePrice')!;
    count = storeValue.read('count');
    if (count == null) {
      count = 0;
    }
    userId = storeValue.read('uId');
    updateValue = storeValue.read('update');

    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    levelId = snapshot.get('level_id');
    gameScore = snapshot.get('game_score');
    balance = snapshot.get('account_balance');
    qolBill = snapshot.get('bill_payment');
    totalMutualFund = snapshot.get('mutual_fund');
    qualityOfLife = snapshot.get('quality_of_life');
    controller = PageController(initialPage: levelId);
    randomNumberTotalPositive = storeValue.read('randomNumberValue');
    controllerForInner = PageController(
        initialPage: storeValue.read('level4or5innerPageViewId'));

    qolBill = (qolBill / 2).floor();
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
    return null;
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
                          storeValue.write('level4or5innerPageViewId', 0);
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
                            count = count + 1;
                            storeValue.write('count', count);
                            if (count == 12) {
                              count = 0;
                              storeValue.write('count', 0);
                              showDialogToShowIncreaseRent();
                              Future.delayed(Duration(milliseconds: 400), () {
                                rentPrice = storeValue.read('rentPrice')!;
                                transportPrice =
                                    storeValue.read('transportPrice')!;
                                lifestylePrice =
                                    storeValue.read('lifestylePrice')!;
                              });
                            }
                          }
                        },
                        // physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          controllerForInner = PageController(
                              initialPage:
                                  storeValue.read('level4or5innerPageViewId'));
                          document = snapshot.data!.docs[index];
                          return document['card_type'] == 'GameQuestion'
                              ? StatefulBuilder(
                                  builder: (context, setStateWidget) {
                                  return PageView.builder(
                                    itemCount: 3,
                                    scrollDirection: Axis.vertical,
                                    controller: controllerForInner,
                                    physics: NeverScrollableScrollPhysics(),
                                    onPageChanged: (value) async {
                                      DocumentSnapshot doc = await firestore
                                          .collection('User')
                                          .doc(userId)
                                          .get();
                                      if (currentIndex == 1) {
                                        storeValue.write(
                                            'level4or5innerPageViewId', 1);
                                        totalMutualFund =
                                            doc.get('mutual_fund');
                                        bill = doc.get('bill_payment');
                                        investment = doc.get('investment');
                                      }
                                      if (currentIndex == 2) if (index != 0) {
                                        balance = doc.get('account_balance');
                                        storeValue.write(
                                            'level4or5innerPageViewId', 2);
                                        _showDialogOfMutualFund(setStateWidget);
                                      }
                                    },
                                    itemBuilder: (context, ind) {
                                      Color color = Colors.white;
                                      currentIndex = ind;
                                      if (currentIndex == 0) {
                                        storeValue.write(
                                            'level4or5innerPageViewId', 0);
                                      }
                                      return BackgroundWidget(
                                        level: level,
                                        document: document,
                                        container: ind == 0
                                            ? StatefulBuilder(
                                                builder: (context, _setState) {
                                                  return GameQuestionContainer(
                                                    level: level,
                                                    document: document,
                                                    description:
                                                        document['description'],
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
                                                        .gameQuestionOption(
                                                      color: list[index]
                                                                  .isSelected1 ==
                                                              true
                                                          ? Colors.white
                                                          : AllColors.yellow,
                                                    ),
                                                    textStyle2: AllTextStyles
                                                        .gameQuestionOption(
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
                                                  );
                                                },
                                              )
                                            : (ind == 1)
                                                ? StatefulBuilder(builder:
                                                    (context, _setState) {
                                                    return BillPaymentWidget(
                                                      color: color,
                                                      billPayment: (rentPrice +
                                                              transportPrice +
                                                              lifestylePrice)
                                                          .toString(),
                                                      forPlan1:
                                                          rentPrice.toString(),
                                                      forPlan2: transportPrice
                                                          .toString(),
                                                      forPlan3: lifestylePrice
                                                          .toString(),
                                                      forPlan4: (rentPrice +
                                                              transportPrice +
                                                              lifestylePrice)
                                                          .toString(),
                                                      text1: 'House Rent ',
                                                      text2: 'Transport ',
                                                      text3: 'Lifestyle ',
                                                      text4: ' Total Bill ',
                                                      onPressed: color ==
                                                              AllColors.green
                                                          ? () {}
                                                          : () async {
                                                              DocumentSnapshot
                                                                  snap =
                                                                  await firestore
                                                                      .collection(
                                                                          'User')
                                                                      .doc(
                                                                          userId)
                                                                      .get();
                                                              _setState(() {
                                                                color =
                                                                    AllColors
                                                                        .green;
                                                                balance = snap.get(
                                                                    'account_balance');
                                                                bill = snap.get(
                                                                    'bill_payment');
                                                                qualityOfLife =
                                                                    snap.get(
                                                                        'quality_of_life');
                                                                balance =
                                                                    balance -
                                                                        bill!;
                                                              });

                                                              // if (home == 'Rent' ||
                                                              //     (home == 'EMI' &&
                                                              //         homeLoan == 0) || ) {
                                                              //
                                                              //   bill = snap.get(
                                                              //       'bill_payment');
                                                              //   _setState(() {
                                                              //     balance =
                                                              //         balance - bill!;
                                                              //   });
                                                              // } else if (home ==
                                                              //         'EMI' &&
                                                              //     homeLoan >
                                                              //         rentPrice) {
                                                              //
                                                              //   bill = snap.get(
                                                              //       'bill_payment');
                                                              //   _setState(() {
                                                              //     balance =
                                                              //         balance - bill!;
                                                              //   });
                                                              // } else {
                                                              //
                                                              //   rentPrice = homeLoan;
                                                              //
                                                              //   _setState(() {
                                                              //     bill = rentPrice +
                                                              //         transportPrice +
                                                              //         lifestylePrice;
                                                              //     balance =
                                                              //         balance - bill!;
                                                              //     pref.setInt(
                                                              //         'rentPrice', 0);
                                                              //     pref.setInt(
                                                              //         'level4TotalPrice',
                                                              //         transportPrice +
                                                              //             lifestylePrice);
                                                              //   });
                                                              //   firestore
                                                              //       .collection('User')
                                                              //       .doc(userId)
                                                              //       .update({
                                                              //     'account_balance':
                                                              //         FieldValue
                                                              //             .increment(
                                                              //                 -balance),
                                                              //     'bill_payment':
                                                              //         transportPrice +
                                                              //             lifestylePrice,
                                                              //   });
                                                              // }
                                                              if (balance >=
                                                                  0) {
                                                                firestore
                                                                    .collection(
                                                                        'User')
                                                                    .doc(userId)
                                                                    .update({
                                                                  'account_balance':
                                                                      balance,
                                                                  'game_score':
                                                                      gameScore +
                                                                          balance +
                                                                          qualityOfLife,
                                                                  'quality_of_life':
                                                                      FieldValue
                                                                          .increment(
                                                                              qolBill),
                                                                  // if (home == 'EMI' && homeLoan != 0) 'home_loan': FieldValue.increment(-rentPrice),
                                                                  // if (transport == 'Other' && transportLoan != 0) 'transport_loan': FieldValue.increment(-transportPrice),
                                                                }).then((value) {
                                                                  controllerForInner.nextPage(
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      curve: Curves
                                                                          .easeIn);
                                                                });
                                                              } else {
                                                                _showDialogForRestartLevel();
                                                              }
                                                            },
                                                    );
                                                  })
                                                : StatefulBuilder(builder:
                                                    (context, _setState) {
                                                    return FundAllocationScreen(
                                                      netWorth: investment,
                                                      color: color,
                                                      lastMonthIncDecValue:
                                                          lastMonthIncDecValue,
                                                      totalMutualFund:
                                                          totalMutualFund,
                                                      widget: StatefulBuilder(
                                                          builder: (context,
                                                              _setState) {
                                                        return ListView.builder(
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Column(
                                                              children: [
                                                                Text(
                                                                    fundName[
                                                                            index]
                                                                        .toString(),
                                                                    style: AllTextStyles
                                                                        .dialogStyleLarge(
                                                                            size:
                                                                                16.sp)),
                                                                SizedBox(
                                                                  height: 1.h,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            5.h,
                                                                        width:
                                                                            12.w,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          color:
                                                                              AllColors.lightGrey,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(2.w),
                                                                            bottomLeft:
                                                                                Radius.circular(2.w),
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        if (fundAllocation[index] !=
                                                                            0) {
                                                                          _setState(
                                                                              () {
                                                                            fundAllocation[index] =
                                                                                fundAllocation[index] - 100;
                                                                            firestore.collection('User').doc(userId).update({
                                                                              'account_balance': FieldValue.increment(100),
                                                                            });
                                                                          });
                                                                        }
                                                                        // if (fundName[index] == 'Home Loan' && homeLoanValue != 0) {
                                                                        //   _setState1(() {
                                                                        //     homeLoanValue = homeLoanValue - 100;
                                                                        //   });
                                                                        // }
                                                                        // if (fundName[index] == 'Car Loan' && transportLoanValue != 0) {
                                                                        //   _setState1(() {
                                                                        //     transportLoanValue = transportLoanValue - 100;
                                                                        //   });
                                                                        // }
                                                                        // if (fundName[index] == 'Mutual Fund' && lifestyleLoanValue != 0) {
                                                                        //   _setState1(() {
                                                                        //     lifestyleLoanValue = lifestyleLoanValue - 100;
                                                                        //   });
                                                                        // }
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          26.w,
                                                                      height:
                                                                          5.h,
                                                                      child: Text(
                                                                          fundAllocation[index]
                                                                              .toString(),
                                                                          style: AllTextStyles.workSansSmall(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 12.sp)),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      color: AllColors
                                                                          .lightYellow,
                                                                    ),
                                                                    GestureDetector(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            5.h,
                                                                        width:
                                                                            12.w,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              AllColors.lightGrey,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            bottomRight:
                                                                                Radius.circular(2.w),
                                                                            topRight:
                                                                                Radius.circular(2.w),
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        _setState(
                                                                            () {
                                                                          fundAllocation[index] =
                                                                              fundAllocation[index] + 100;
                                                                          firestore
                                                                              .collection('User')
                                                                              .doc(userId)
                                                                              .update({
                                                                            'account_balance':
                                                                                FieldValue.increment(-100),
                                                                          });
                                                                        });
                                                                        // if (fundName[index] == 'Home Loan') {
                                                                        //   if (homeLoanValue == homeLoan && homeLoanValue >= homeLoan) {
                                                                        //     Fluttertoast.showToast(msg: 'Your Home EMI is only $homeLoan Left');
                                                                        //   } else {
                                                                        //     _setState1(() {
                                                                        //       homeLoanValue = homeLoanValue + 100;
                                                                        //     });
                                                                        //   }
                                                                        // }
                                                                        // if (fundName[index] == 'Car Loan') {
                                                                        //   if (transportLoanValue == transportLoan && transportLoanValue >= transportLoan) {
                                                                        //     Fluttertoast.showToast(msg: 'Your Transport EMI is only $transportLoan Left');
                                                                        //   } else {
                                                                        //     _setState1(() {
                                                                        //       transportLoanValue = transportLoanValue + 100;
                                                                        //     });
                                                                        //   }
                                                                        // }
                                                                        // if (fundName[index] == 'Mutual Fund') {
                                                                        //   _setState1(() {
                                                                        //     lifestyleLoanValue = lifestyleLoanValue + 100;
                                                                        //   });
                                                                        // }
                                                                        //
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 1.h,
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                          itemCount:
                                                              fundName.length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                        );
                                                      }),
                                                      onPressed:
                                                          color ==
                                                                  AllColors
                                                                      .green
                                                              ? () {}
                                                              : () async {
                                                                  DocumentSnapshot
                                                                      snap =
                                                                      await firestore
                                                                          .collection(
                                                                              'User')
                                                                          .doc(
                                                                              userId)
                                                                          .get();
                                                                  _setState(() {
                                                                    color =
                                                                        AllColors
                                                                            .green;
                                                                    fund = 0;
                                                                    balance =
                                                                        snap.get(
                                                                            'account_balance');
                                                                    qualityOfLife =
                                                                        snap.get(
                                                                            'quality_of_life');
                                                                    //fund = fundAllocation[0] + fundAllocation[1];
                                                                    fund =
                                                                        fundAllocation[
                                                                            0];
                                                                    // balance = balance - fund;
                                                                    //  totalFundAmount = homeLoanValue + transportLoanValue + lifestyleLoanValue;
                                                                    //balance = balance - totalFundAmount;
                                                                  });
                                                                  //SharedPreferences pref = await SharedPreferences.getInstance();
                                                                  if (balance >=
                                                                      0) {
                                                                    firestore
                                                                        .collection(
                                                                            'User')
                                                                        .doc(
                                                                            userId)
                                                                        .update({
                                                                      // 'account_balance': balance,
                                                                      'game_score': gameScore +
                                                                          balance +
                                                                          qualityOfLife,
                                                                      'mutual_fund':
                                                                          FieldValue.increment(
                                                                              fundAllocation[0]),
                                                                      'investment':
                                                                          FieldValue.increment(
                                                                              fundAllocation[0])
                                                                      // if (home == 'EMI' && homeLoan != 0) 'home_loan': FieldValue.increment(-homeLoanValue),
                                                                      // if (transport == 'Other' && transportLoan != 0) 'transport_loan': FieldValue.increment(-transportLoanValue),
                                                                    }).then((value) {
                                                                      balance =
                                                                          balance +
                                                                              2000;
                                                                      firestore
                                                                          .collection(
                                                                              'User')
                                                                          .doc(
                                                                              userId)
                                                                          .update({
                                                                        'account_balance':
                                                                            FieldValue.increment(2000),
                                                                        'game_score': gameScore +
                                                                            balance +
                                                                            qualityOfLife,
                                                                      });
                                                                      fund = 0;
                                                                      int value =
                                                                          storeValue
                                                                              .read('level4or5innerPageViewId');
                                                                      if (index ==
                                                                              snapshot.data!.docs.length -
                                                                                  1 &&
                                                                          value ==
                                                                              2) {
                                                                        firestore.collection('User').doc(userId).update({
                                                                          'level_id':
                                                                              index + 1,
                                                                          'level_4_id':
                                                                              index + 1,
                                                                        }).then((value) => Future.delayed(
                                                                            Duration(seconds: 1),
                                                                            () => calculationForProgress(() {
                                                                                  Get.back();
                                                                                  _levelCompleteSummary();
                                                                                })));
                                                                      } else {
                                                                        controller.nextPage(
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                            curve: Curves.easeIn);
                                                                        storeValue.write(
                                                                            'level4or5innerPageViewId',
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
                                                  }),
                                      );
                                    },
                                  );
                                })
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
                                      firestore
                                          .collection('User')
                                          .doc(userId)
                                          .update({
                                        'level_id': index + 1,
                                        'level_4_id': index + 1,
                                      }).then((value) {
                                        controller.nextPage(
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeIn);
                                      });
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
          'previous_session_info': 'Level_4_setUp_page',
          'level_id': 0,
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
    randomNumberTotalPositive = storeValue.read('randomNumberValue');
    totalMutualFund = doc.get('mutual_fund');
    investment = doc.get('investment');
    if (totalMutualFund == 0) {
      number = 0;
    } else {
      // if(randomNumber == 0 && positiveMonth! <= 18){

      //   storeValue.write('positiveMonthValue',positiveMonth! + 1);
      //   number = rnd.nextInt(6);
      // }
      // if(randomNumber == 1 && negativeMonth! <= 12){

      //   storeValue.write('negativeMonthValue',negativeMonth! + 1);
      //   number = rnd.nextInt(-6);
      // }
      // if(negativeMonth != 12 && positiveMonth! == 18){

      //   storeValue.write('negativeMonthValue',negativeMonth! + 1);
      //   number = rnd.nextInt(-6);
      // }
      // if(positiveMonth != 18 && negativeMonth! == 12){

      //   storeValue.write('positiveMonthValue',positiveMonth! + 1);
      //   number = rnd.nextInt(6);
      // }
      number = randomNumberTotalPositive! <= 10
          ? rnd.nextInt(5 + 5) - 5
          : rnd.nextInt(6);
      if (number <= 0) {
        storeValue.write('randomNumberValue', randomNumberTotalPositive! + 1);
      }
    }
    setStateWidget(() {
      lastMonthIncDecPer = (investment * number) ~/ 100;
      lastMonthIncDecValue = investment + (lastMonthIncDecPer);
    });

    firestore
        .collection('User')
        .doc(userId)
        .update({'investment': lastMonthIncDecValue});
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
                container: StatefulBuilder(
                  builder: (context, _setState) {
                    return MutualFundWidget(
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
      //int value = storeValue.read('level4or5innerPageViewId');
    });
    // if (index == snapshot.data!.docs.length - 1 && value == 2) {
    //   firestore.collection('User').doc(userId).update({
    //     'level_id': index + 1,
    //     'level_4_id': index + 1,
    //   }).then((value) => Future.delayed(
    //       Duration(seconds: 1),
    //           () => _levelCompleteSummary(
    //           context, gameScore, balance, qualityOfLife)));
    // }
    if (balance >= priceOfOption) {
      setState1(() {
        balance = balance - priceOfOption;
      });
      firestore.collection('User').doc(userId).update({
        'account_balance': FieldValue.increment(-priceOfOption),
        'level_id': index + 1,
        'level_4_id': index + 1,
        'quality_of_life': FieldValue.increment(qol2),
        'game_score': gameScore + balance + qol2,
        'need': category == 'Need'
            ? FieldValue.increment(priceOfOption)
            : FieldValue.increment(0),
        'want': category == 'Want'
            ? FieldValue.increment(priceOfOption)
            : FieldValue.increment(0),
      }).then((value) {
        controllerForInner.nextPage(
            duration: Duration(seconds: 1), curve: Curves.easeIn);
        // balance = snap.get('account_balance');
        // if (document['month'] != 0)
        //   Future.delayed(
        //       Duration(milliseconds: 500), () => _billPayment(balance, index));
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

  _playLevelOrPopQuiz() {
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
            'previous_session_info': 'Level_4_Pop_Quiz',
            'level_id': 0,
            if (value != true) 'last_level': 'Level_4_Pop_Quiz',
          });
          //Fluttertoast.showToast(msg: 'ComingSoon');
          Get.off(
            () => PopQuiz(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          );
        });
      },
      () async {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        // var userId = storeValue.read('uId');
        // DocumentSnapshot snap =
        //     await firestore.collection('User').doc(userId).get();
        // bool value = snap.get('replay_level');
        // level = snap.get('last_level');
        // level = level.toString().substring(6, 7);
        // int lev = int.parse(level);
        // if (lev == 2 && value == true) {
        //   firestore
        //       .collection('User')
        //       .doc(userId)
        //       .update({'replay_level': false});
        // }
        Future.delayed(Duration(seconds: 2), () async {
          //await localNotifyManager.flutterLocalNotificationsPlugin.cancel(24);
          await localNotifyManager.flutterLocalNotificationsPlugin.cancel(4);
          await localNotifyManager.flutterLocalNotificationsPlugin.cancel(10);
          inviteDialog();
          // FirebaseFirestore.instance.collection('User').doc(userId).update({
          //   //'previous_session_info': 'Level_5_setUp_page',
          //   if (value != true) 'last_level': 'Level_5_setUp_page',
          //   'previous_session_info': 'Coming_soon',
          //   //if (value != true) 'last_level': 'Level_5_setUp_page',
          // });
          // Get.offAll(
          //   () => ComingSoon(),
          //   duration: Duration(milliseconds: 500),
          //   transition: Transition.downToUp,
          // );
          // // Get.off(
          // //   () => LevelFiveSetUpPage(),
          // //   duration: Duration(milliseconds: 500),
          // //   transition: Transition.downToUp,
          // // );
        });
      },
    );
  }

  summary(DocumentSnapshot<Object?> documentSnapshot) {
    // int need = documentSnapshot['need'];
    // int want = documentSnapshot['want'];
    // int bill = documentSnapshot['bill_payment'];
    int accountBalance = documentSnapshot['account_balance'];
    // int qol = documentSnapshot['quality_of_life'];
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
                  ? normalText(AllStrings.level4SummaryTitleWhenComplete)
                  : normalText(AllStrings.level4SummaryTitleWhenLose),
              richText(AllStrings.salaryEarned, '\$' + 60000.toString(), 2.h),
              richText(
                  AllStrings.totalMfInvestment, mutualFund.toString(), 1.h),
              // (((netWorth - mutualFund) / mutualFund) * 100 == null)
              netWorth == 0 && mutualFund == 0
                  ? richText(AllStrings.returnOnInvestment, 0.toString(), 1.h)
                  : richText(
                      AllStrings.returnOnInvestment,
                      '${(((netWorth - mutualFund) / mutualFund) * 100).floor()}' +
                          '%',
                      1.h),
              richText(AllStrings.moneySaved,
                  '${((accountBalance / 60000) * 100).floor()}' + '%', 1.h),
              (accountBalance + netWorth) >= 30000
                  ? buttonStyle(
                      color,
                      AllStrings.playNextLevel,
                      color == AllColors.green
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
                                      })));
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
}
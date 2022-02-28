

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/ExpandedBottomDrawer.dart';
import 'package:financial/ReusableScreen/GameScorePage.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/PreviewOfBottomDrawer.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/views/ComingSoon.dart';
import 'package:financial/views/LevelFiveSetUpPage.dart';
import 'package:financial/views/LevelFourSetUpPage.dart';
import 'package:financial/views/PopQuiz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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
    print('qolBill $qolBill');
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
              child:
                  CircularProgressIndicator(backgroundColor: Color(0xff4D6EF2)))
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
                          backgroundColor: Color(0xff4D6EF2)),
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
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: DoubleBackToCloseApp(
                                          snackBar: const SnackBar(
                                            content:
                                                Text('Tap back again to leave'),
                                          ),
                                          child: DraggableBottomSheet(
                                            backgroundWidget: Container(
                                              width: 100.w,
                                              height: 100.h,
                                              decoration: boxDecoration,
                                              child: Column(
                                                children: [
                                                  Spacer(),
                                                  GameScorePage(
                                                    level: level,
                                                    document: document,
                                                  ),
                                                  ind == 0
                                                      ? StatefulBuilder(
                                                          builder: (context,
                                                              _setState) {
                                                            return GameQuestionContainer(
                                                              level: level,
                                                              document:
                                                                  document,
                                                              description: document[
                                                                  'description'],
                                                              option1: document[
                                                                  'option_1'],
                                                              option2: document[
                                                                  'option_2'],
                                                              color1: list[index]
                                                                          .isSelected1 ==
                                                                      true
                                                                  ? Color(
                                                                      0xff00C673)
                                                                  : Colors
                                                                      .white,
                                                              color2: list[index]
                                                                          .isSelected2 ==
                                                                      true
                                                                  ? Color(
                                                                      0xff00C673)
                                                                  : Colors
                                                                      .white,
                                                              textStyle1: GoogleFonts.workSans(
                                                                  color: list[index]
                                                                              .isSelected1 ==
                                                                          true
                                                                      ? Colors
                                                                          .white
                                                                      : Color(
                                                                          0xffFFA500),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      15.sp),
                                                              textStyle2: GoogleFonts.workSans(
                                                                  color: list[index]
                                                                              .isSelected2 ==
                                                                          true
                                                                      ? Colors
                                                                          .white
                                                                      : Color(
                                                                          0xffFFA500),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      15.sp),
                                                              onPressed1: list[index]
                                                                              .isSelected2 ==
                                                                          true ||
                                                                      list[index]
                                                                              .isSelected1 ==
                                                                          true
                                                                  ? () {}
                                                                  : () async {
                                                                      _setState(
                                                                          () {
                                                                        flag1 =
                                                                            true;
                                                                      });
                                                                      if (flag2 ==
                                                                          false) {
                                                                        DocumentSnapshot snap = await firestore
                                                                            .collection('User')
                                                                            .doc(userId)
                                                                            .get();

                                                                        list[index].isSelected1 =
                                                                            true;
                                                                        balance =
                                                                            snap.get('account_balance');
                                                                        option =
                                                                            document['option_1'];
                                                                        priceOfOption =
                                                                            document['option_1_price'];
                                                                        var category =
                                                                            document['category'];
                                                                        int qol1 =
                                                                            document['quality_of_life_1'];
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
                                                                            msg:
                                                                                'Sorry, you already selected option');
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
                                                                      _setState(
                                                                          () {
                                                                        flag2 =
                                                                            true;
                                                                      });
                                                                      if (flag1 ==
                                                                          false) {
                                                                        DocumentSnapshot snap = await firestore
                                                                            .collection('User')
                                                                            .doc(userId)
                                                                            .get();

                                                                        list[index].isSelected2 =
                                                                            true;
                                                                        balance =
                                                                            snap.get('account_balance');
                                                                        option =
                                                                            document['option_2'];
                                                                        priceOfOption =
                                                                            document['option_2_price'];
                                                                        var category =
                                                                            document['category'];
                                                                        int qol2 =
                                                                            document['quality_of_life_2'];
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
                                                                            msg:
                                                                                'Sorry, you already selected option');
                                                                      }
                                                                    },
                                                            );
                                                          },
                                                        )

                                                      : (ind == 1)
                                                          ? StatefulBuilder(
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
                                                                        Color(
                                                                            0xff00C673)
                                                                    ? () {}
                                                                    : () async {
                                                                        DocumentSnapshot snap = await firestore
                                                                            .collection('User')
                                                                            .doc(userId)
                                                                            .get();
                                                                        _setState(
                                                                            () {
                                                                          color =
                                                                              Color(0xff00C673);
                                                                          balance =
                                                                              snap.get('account_balance');
                                                                          bill =
                                                                              snap.get('bill_payment');
                                                                          qualityOfLife =
                                                                              snap.get('quality_of_life');
                                                                          balance =
                                                                              balance - bill!;
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
                                                                              .collection('User')
                                                                              .doc(userId)
                                                                              .update({
                                                                            'account_balance':
                                                                                balance,
                                                                            'game_score': gameScore +
                                                                                balance +
                                                                                qualityOfLife,
                                                                            'quality_of_life':
                                                                                FieldValue.increment(qolBill),
                                                                            // if (home == 'EMI' && homeLoan != 0) 'home_loan': FieldValue.increment(-rentPrice),
                                                                            // if (transport == 'Other' && transportLoan != 0) 'transport_loan': FieldValue.increment(-transportPrice),
                                                                          }).then((value) {
                                                                            controllerForInner.nextPage(
                                                                                duration: Duration(seconds: 1),
                                                                                curve: Curves.easeIn);
                                                                          });
                                                                        } else {
                                                                          _showDialogForRestartLevel();
                                                                        }
                                                                      },
                                                              );
                                                            })

                                                          : StatefulBuilder(
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
                                                                    builder:
                                                                        (context,
                                                                            _setState) {
                                                                  return ListView
                                                                      .builder(
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Column(
                                                                        children: [
                                                                          Text(
                                                                            fundName[index].toString(),
                                                                            style: GoogleFonts.workSans(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 16.sp),
                                                                          ),
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
                                                                                    color: Color(0xff979797),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(2.w),
                                                                                      bottomLeft: Radius.circular(2.w),
                                                                                    ),
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  if (fundAllocation[index] != 0) {
                                                                                    _setState(() {
                                                                                      fundAllocation[index] = fundAllocation[index] - 100;
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
                                                                                width: 26.w,
                                                                                height: 5.h,
                                                                                child: Text(
                                                                                  fundAllocation[index].toString(),
                                                                                  style: GoogleFonts.workSans(
                                                                                    color: Colors.black,
                                                                                    fontSize: 12.sp,
                                                                                  ),
                                                                                ),
                                                                                alignment: Alignment.center,
                                                                                color: Color(0xffFCE681),
                                                                              ),
                                                                              GestureDetector(
                                                                                child: Container(
                                                                                  height: 5.h,
                                                                                  width: 12.w,
                                                                                  child: Icon(
                                                                                    Icons.add,
                                                                                    color: Color(0xff979797),
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                      bottomRight: Radius.circular(2.w),
                                                                                      topRight: Radius.circular(2.w),
                                                                                    ),
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  _setState(() {
                                                                                    fundAllocation[index] = fundAllocation[index] + 100;
                                                                                    firestore.collection('User').doc(userId).update({
                                                                                      'account_balance': FieldValue.increment(-100),
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
                                                                        Color(
                                                                            0xff00C673)
                                                                    ? () {}
                                                                    : () async {
                                                                        DocumentSnapshot snap = await firestore
                                                                            .collection('User')
                                                                            .doc(userId)
                                                                            .get();
                                                                        _setState(
                                                                            () {
                                                                          color =
                                                                              Color(0xff00C673);
                                                                          fund =
                                                                              0;
                                                                          balance =
                                                                              snap.get('account_balance');
                                                                          qualityOfLife =
                                                                              snap.get('quality_of_life');
                                                                          //fund = fundAllocation[0] + fundAllocation[1];
                                                                          fund =
                                                                              fundAllocation[0];
                                                                          // balance = balance - fund;
                                                                          //  totalFundAmount = homeLoanValue + transportLoanValue + lifestyleLoanValue;
                                                                          //balance = balance - totalFundAmount;
                                                                        });
                                                                        //SharedPreferences pref = await SharedPreferences.getInstance();
                                                                        if (balance >=
                                                                            0) {
                                                                          firestore
                                                                              .collection('User')
                                                                              .doc(userId)
                                                                              .update({
                                                                            // 'account_balance': balance,
                                                                            'game_score': gameScore +
                                                                                balance +
                                                                                qualityOfLife,
                                                                            'mutual_fund':
                                                                                FieldValue.increment(fundAllocation[0]),
                                                                            'investment':
                                                                                FieldValue.increment(fundAllocation[0])
                                                                            // if (home == 'EMI' && homeLoan != 0) 'home_loan': FieldValue.increment(-homeLoanValue),
                                                                            // if (transport == 'Other' && transportLoan != 0) 'transport_loan': FieldValue.increment(-transportLoanValue),
                                                                          }).then((value) {
                                                                            balance =
                                                                                balance + 2000;
                                                                            firestore.collection('User').doc(userId).update({
                                                                              'account_balance': FieldValue.increment(2000),
                                                                              'game_score': gameScore + balance + qualityOfLife,
                                                                            });
                                                                            fund =
                                                                                0;
                                                                            int value =
                                                                                storeValue.read('level4or5innerPageViewId');
                                                                            if (index == snapshot.data!.docs.length - 1 &&
                                                                                value == 2) {
                                                                              firestore.collection('User').doc(userId).update({
                                                                                'level_id': index + 1,
                                                                                'level_4_id': index + 1,
                                                                              }).then((value) => Future.delayed(
                                                                                  Duration(seconds: 1),
                                                                                  () => calculationForProgress(() {
                                                                                        Get.back();
                                                                                        _levelCompleteSummary(context, gameScore, balance, qualityOfLife);
                                                                                      })));
                                                                            } else {
                                                                              controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
                                                                              storeValue.write('level4or5innerPageViewId', 0);
                                                                            }
                                                                          });
                                                                          fundAllocation =
                                                                              [
                                                                            0
                                                                          ];
                                                                        } else {
                                                                          _showDialogForRestartLevel();
                                                                        }
                                                                      },
                                                              );
                                                            }),


                                                  Spacer(),
                                                  Spacer(),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                            previewChild:
                                                PreviewOfBottomDrawer(),
                                            expandedChild:
                                                ExpandedBottomDrawer(),
                                            minExtent: 14.h,
                                            maxExtent: 55.h,
                                          ),
                                        ),
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
                                        ? Color(0xff00C673)
                                        : Colors.white,
                                    colorForText: flagForKnow
                                        ? Colors.white
                                        : Color(0xff6D00C2),
                                    onTap: () async {
                                      _setState(() {
                                        flagForKnow = true;
                                        color = Color(0xff00C673);
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
                      onPressed: color == Color(0xff00C673)
                          ? () {}
                          : () {
                              _setState(() {
                                color = Color(0xff00C673);
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
      int value = storeValue.read('level4or5innerPageViewId');
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



  _levelCompleteSummary(BuildContext context, int gameScore, int balance,
      int qualityOfLife) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    int need = documentSnapshot['need'];
    int want = documentSnapshot['want'];
    int bill = documentSnapshot['bill_payment'];
    int accountBalance = documentSnapshot['account_balance'];
    int qol = documentSnapshot['quality_of_life'];
    int netWorth = documentSnapshot['investment'];
    int mutualFund = documentSnapshot['mutual_fund'];
    Color color = Colors.white;
    print('NEED $need');
    print('NEED $want');
    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: StatefulBuilder(
              builder: (context, _setState) {
                return BackgroundWidget(
                    level: level,
                    document: document,
                    container: Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        StatefulBuilder(builder: (context, _setState) {
                          return LevelSummary(
                            need: need,
                            want: want,
                            bill: bill,
                            netWorth: netWorth,
                            mutualFund: mutualFund,
                            accountBalance: accountBalance,
                            color: color,
                            onPressed1: color == Color(0xff00C673)
                                ? () {}
                                : () async {
                                    bool? value;
                                    DocumentSnapshot snap = await firestore
                                        .collection('User')
                                        .doc(userId)
                                        .get();
                                    _setState(() {
                                      color = Color(0xff00C673);
                                      value = snap.get('replay_level');
                                    });
                                    // int myBal =
                                    //     documentSnapshot.get('account_balance');

                                    // if (myBal < 1200) {
                                    //   Future.delayed(
                                    //       Duration(seconds: 1),
                                    //       () =>
                                    //           _showDialogWhenAmountLessSavingGoal());
                                    // } else {
                                    // Future.delayed(
                                    //   Duration(seconds: 2),
                                    //   () => inviteDialog(_playLevelOrPopQuiz()),
                                    // Future.delayed(
                                    //   Duration(seconds: 2),
                                    //   () => _playLevelOrPopQuiz(),
                                    firestore
                                        .collection('User')
                                        .doc(userId)
                                        .update({
                                      'level_id': 0,
                                      // 'previous_session_info': 'Coming_soon',
                                      'previous_session_info':
                                          'Level_5_setUp_page',
                                      'level_4_balance': accountBalance,
                                      'level_4_qol': qol,
                                      'level_4_investment': netWorth
                                      //if(value != true) 'last_level':'Coming_soon',
                                    }).then(
                                      (value) => Future.delayed(
                                          Duration(milliseconds: 500),
                                          () => _playLevelOrPopQuiz()),

                                      // showDialog(
                                      // barrierDismissible: false,
                                      // context: context,
                                      // builder: (context) {
                                      //   return WillPopScope(
                                      //     onWillPop: () {
                                      //       return Future.value(false);
                                      //     },
                                      //     child: AlertDialog(
                                      //       elevation: 3.0,
                                      //       shape:
                                      //           RoundedRectangleBorder(
                                      //               borderRadius:
                                      //                   BorderRadius
                                      //                       .circular(
                                      //                           4.w)),
                                      //       actionsPadding:
                                      //           EdgeInsets.all(8.0),
                                      //       backgroundColor:
                                      //           Color(0xff6646E6),
                                      //       content: Text(
                                      //         'Woohoo! Invites unlocked!  \n\n Invite your friends to play the game and challenge them to beat your score!',
                                      //         style:
                                      //             GoogleFonts.workSans(
                                      //                 color:
                                      //                     Colors.white,
                                      //                 fontSize: 14.sp,
                                      //                 fontWeight:
                                      //                     FontWeight
                                      //                         .w600),
                                      //         textAlign:
                                      //             TextAlign.center,
                                      //       ),
                                      //       actions: [
                                      //         Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment
                                      //                   .spaceEvenly,
                                      //           children: [
                                      //             Container(
                                      //               child: ElevatedButton(
                                      //                   onPressed:
                                      //                       () async {
                                      //                     //bool value = documentSnapshot.get('replay_level');
                                      //                     // level = documentSnapshot.get('last_level');
                                      //                     // int myBal = documentSnapshot.get('account_balance');
                                      //
                                      //                     // level = level.toString().substring(6, 7);
                                      //                     // int lev = int.parse(level);
                                      //                     // if (value == true) {
                                      //                     //   Future.delayed(
                                      //                     //       Duration(seconds: 1),
                                      //                     //       () => showDialogForReplay(lev, userId),);
                                      //                     // } else {
                                      //                     FlutterShare.share(
                                      //                             title:
                                      //                                 'https://finshark.page.link/finshark',
                                      //                             text:
                                      //                                 'Hey! Have you tried out the Finshark app? It\'s a fun game that helps you build smart financial habits. You can learn to budget, invest and more. I think you\'ll like it!',
                                      //                             linkUrl:
                                      //                                 'https://finshark.page.link/finshark',
                                      //                             chooserTitle:
                                      //                                 'https://finshark.page.link/finshark')
                                      //                         .then(
                                      //                             (value) {
                                      //                       // Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelThreeSetUpPage(controller: PageController()))));
                                      //                     }).then((value) {
                                      //                       Get.back();
                                      //                       Future.delayed(
                                      //                           Duration(
                                      //                               seconds:
                                      //                                   1),
                                      //                           () =>
                                      //                               _playLevelOrPopQuiz());
                                      //                     });
                                      //                     // }
                                      //                   },
                                      //                   style: ButtonStyle(
                                      //                       backgroundColor:
                                      //                           MaterialStateProperty.all(
                                      //                               Colors
                                      //                                   .white)),
                                      //                   child: Text(
                                      //                     'Click here to invite ',
                                      //                     style: GoogleFonts
                                      //                         .workSans(
                                      //                       fontSize: 13.sp,
                                      //                       color: Color(
                                      //                           0xff6646E6),
                                      //                     ),
                                      //                   )),
                                      //               width: 51.w,
                                      //               height: 5.h,
                                      //             ),
                                      //             GestureDetector(
                                      //               child: Text(
                                      //                 'Skip',
                                      //                 style: GoogleFonts
                                      //                     .workSans(
                                      //                   color: Colors
                                      //                       .white,
                                      //                   fontSize: 13.sp,
                                      //                   fontWeight:
                                      //                       FontWeight
                                      //                           .w600,
                                      //                   decoration:
                                      //                       TextDecoration
                                      //                           .underline,
                                      //                 ),
                                      //               ),
                                      //               onTap: () {
                                      //                 Get.back();
                                      //                 Future.delayed(
                                      //                     Duration(
                                      //                         seconds:
                                      //                             1),
                                      //                     () =>
                                      //                         _playLevelOrPopQuiz());
                                      //               },
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   );
                                      // })
                                    );
                                    //}
                                  },
                            onPressed2: () {
                              _setState(() {
                                color = Color(0xff00C673);
                              });
                              bool value = documentSnapshot.get('replay_level');
                              documentSnapshot.get('account_balance');
                              Future.delayed(Duration(seconds: 1), () {
                                firestore
                                    .collection('User')
                                    .doc(userId)
                                    .update({
                                  'previous_session_info': 'Level_4_setUp_page',
                                  if (value != true)
                                    'last_level': 'Level_4_setUp_page',
                                }).then((value) {
                                  Get.offNamed('/Level4SetUp');
                                });
                              });
                            },
                          );
                        })
                      ],
                    ));
              },
            ),
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
            'previous_session_info': 'Level_5_setUp_page',
            if (value != true) 'last_level': 'Level_5_setUp_page',
            //  'previous_session_info': 'Coming_soon',
            //if (value != true) 'last_level': 'Level_5_setUp_page',
          });
          // Get.off(
          //   () => ComingSoon(),
          //   duration: Duration(milliseconds: 500),
          //   transition: Transition.downToUp,
          // );
          Get.off(
            () => LevelFiveSetUpPage(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          );
        });
      },
    );
    // return showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) {
    //       return WillPopScope(
    //         onWillPop: () {
    //           return Future.value(false);
    //         },
    //         child: AlertDialog(
    //           elevation: 3.0,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(4.w)),
    //           titlePadding: EdgeInsets.zero,
    //           title: Container(
    //             width: 100.w,
    //             child: Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: Text(
    //                 'Congrats! You’ve managed to achieve your savings goal! Mission accomplished!',
    //                 textAlign: TextAlign.center,
    //                 style: GoogleFonts.workSans(
    //                     fontSize: 14.sp,
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.w500),
    //               ),
    //             ),
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.only(
    //                   topRight: Radius.circular(4.w),
    //                   topLeft: Radius.circular(4.w),
    //                 ),
    //                 color: Color(0xffE9E5FF)),
    //           ),
    //           content: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               ElevatedButton(
    //                   onPressed: () async {
    //                     SharedPreferences pref =
    //                         await SharedPreferences.getInstance();
    //                     var userId = pref.getString('uId');
    //                     DocumentSnapshot snap = await firestore
    //                         .collection('User')
    //                         .doc(userId)
    //                         .get();
    //                     bool value = snap.get('replay_level');
    //                     level = snap.get('last_level');
    //                     level = level.toString().substring(6, 7);
    //                     int lev = int.parse(level);
    //                     if (lev == 2 && value == true) {
    //                       firestore
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({'replay_level': false});
    //                     }
    //                     Future.delayed(Duration(seconds: 2), () {
    //                       FirebaseFirestore.instance
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({
    // 'previous_session_info': 'Level_2_Pop_Quiz',
    // 'level_id' : 0,
    // if (value != true) 'last_level': 'Level_2_Pop_Quiz',
    //                       });
    //                       Get.off(
    //                         () => LevelThreeSetUpPage(),
    //                         duration: Duration(milliseconds: 500),
    //                         transition: Transition.downToUp,
    //                       );
    //                     });
    //                   },
    //                   child: Text('Play Pop Quiz')),
    //               ElevatedButton(
    //                   onPressed: () async {
    //                     SharedPreferences pref =
    //                         await SharedPreferences.getInstance();
    //                     var userId = pref.getString('uId');
    //                     DocumentSnapshot snap = await firestore
    //                         .collection('User')
    //                         .doc(userId)
    //                         .get();
    //                     bool value = snap.get('replay_level');
    //                     level = snap.get('last_level');
    //                     level = level.toString().substring(6, 7);
    //                     int lev = int.parse(level);
    //                     if (lev == 2 && value == true) {
    //                       firestore
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({'replay_level': false});
    //                     }
    //                     Future.delayed(Duration(seconds: 2), () {
    //                       FirebaseFirestore.instance
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({
    //                         'previous_session_info': 'Level_3_setUp_page',
    //                         if (value != true)
    //                           'last_level': 'Level_3_setUp_page',
    //                       });
    //                       Get.off(
    //                         () => LevelThreeSetUpPage(),
    //                         duration: Duration(milliseconds: 500),
    //                         transition: Transition.downToUp,
    //                       );
    //                     });
    //                   },
    //                   child: Text('Play Next Level'))
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
// _billPayment(int balance, int index) async {
//   Color color = Colors.white;
//   DocumentSnapshot snap =
//   await firestore.collection('User').doc(userId).get();
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   int homeLoan = snap.get('home_loan');
//   int transportLoan = snap.get('transport_loan');
//   rentPrice = pref.getInt('rentPrice')!;
//   transportPrice = pref.getInt('transportPrice')!;
//
//   if (home == 'EMI') {
//     if (homeLoan <= rentPrice) {
//       setState(() {
//         rentPrice = homeLoan;
//         pref.setInt('rentPrice', 0);
//       });
//     }
//   }
//   if (transport == 'Other') {
//     if (transportLoan <= transportPrice) {
//       setState(() {
//         transportPrice = transportLoan;
//         pref.setInt('transportPrice', 0);
//       });
//     }
//   }
//
//   // return showDialog(
//   //     context: context, // <<----
//   //     barrierDismissible: false,
//   //     builder: (BuildContext context) {
//   //       return WillPopScope(
//   //         onWillPop: () {
//   //           return Future.value(false);
//   //         },
//   //   child:
//   return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: DraggableBottomSheet(
//         backgroundWidget: Container(
//           width: 100.w,
//           height: 100.h,
//           decoration: boxDecoration,
//           child: Column(
//             children: [
//               Spacer(),
//               GameScorePage(
//                 level: level,
//                 document: document,
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 2.h),
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: 54.h,
//                   width: 80.w,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(
//                         8.w,
//                       ),
//                       color: Color(0xff6A81F4)),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         if (home == 'Rent' ||
//                             (home == 'EMI' && homeLoan != 0))
//                           Padding(
//                             padding: EdgeInsets.only(
//                               top: 2.h,
//                             ),
//                             child: Center(
//                               child: RichText(
//                                 textAlign: TextAlign.left,
//                                 overflow: TextOverflow.clip,
//                                 text: TextSpan(
//                                     text: 'House Rent/EMI ',
//                                     style: GoogleFonts.workSans(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16.sp),
//                                     children: [
//                                       TextSpan(
//                                         text: '\$' + rentPrice.toString(),
//                                         style: GoogleFonts.workSans(
//                                             color: Color(0xffFEBE16),
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 16.sp),
//                                       ),
//                                     ]),
//                               ),
//                             ),
//                           ),
//                         if (transport == 'Public' ||
//                             (transport == 'Other' && transportLoan != 0))
//                           Padding(
//                             padding: EdgeInsets.only(
//                               top: 1.h,
//                             ),
//                             child: Center(
//                               child: RichText(
//                                 textAlign: TextAlign.left,
//                                 overflow: TextOverflow.clip,
//                                 text: TextSpan(
//                                     text: 'Transport EMI ',
//                                     style: GoogleFonts.workSans(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16.sp),
//                                     children: [
//                                       TextSpan(
//                                         text:
//                                         '\$' + transportPrice.toString(),
//                                         style: GoogleFonts.workSans(
//                                             color: Color(0xffFEBE16),
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 16.sp),
//                                       ),
//                                     ]),
//                               ),
//                             ),
//                           ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: 1.h,
//                           ),
//                           child: Center(
//                             child: RichText(
//                               textAlign: TextAlign.left,
//                               overflow: TextOverflow.clip,
//                               text: TextSpan(
//                                   text: 'Lifestyle EMI ',
//                                   style: GoogleFonts.workSans(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16.sp),
//                                   children: [
//                                     TextSpan(
//                                       text: '\$' + lifestylePrice.toString(),
//                                       style: GoogleFonts.workSans(
//                                           color: Color(0xffFEBE16),
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16.sp),
//                                     ),
//                                   ]),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: 1.h,
//                           ),
//                           child: Center(
//                             child: RichText(
//                               textAlign: TextAlign.left,
//                               overflow: TextOverflow.clip,
//                               text: TextSpan(
//                                   text: 'Fund Left ',
//                                   style: GoogleFonts.workSans(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16.sp),
//                                   children: [
//                                     TextSpan(
//                                       text: '\$' + balance.toString(),
//                                       style: GoogleFonts.workSans(
//                                           color: Color(0xffFEBE16),
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16.sp),
//                                     ),
//                                   ]),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 4.h,
//                         ),
//                         Padding(
//                             padding: EdgeInsets.only(top: 2.h),
//                             child: StatefulBuilder(
//                                 builder: (context, _setState) {
//                                   return Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: 62.w,
//                                     height: 7.h,
//                                     decoration: BoxDecoration(
//                                         color: color,
//                                         borderRadius:
//                                         BorderRadius.circular(12.w)),
//                                     child: TextButton(
//                                         onPressed: color == Color(0xff00C673)
//                                             ? () {}
//                                             : () async {
//                                           _setState(() {
//                                             color = Color(0xff00C673);
//                                             balance =
//                                                 snap.get('account_balance');
//                                             bill = rentPrice +
//                                                 transportPrice +
//                                                 lifestylePrice;
//
//                                             balance = balance - bill!;
//                                           });
//
//                                           // if (home == 'Rent' ||
//                                           //     (home == 'EMI' &&
//                                           //         homeLoan == 0) || ) {
//                                           //
//                                           //   bill = snap.get(
//                                           //       'bill_payment');
//                                           //   _setState(() {
//                                           //     balance =
//                                           //         balance - bill!;
//                                           //   });
//                                           // } else if (home ==
//                                           //         'EMI' &&
//                                           //     homeLoan >
//                                           //         rentPrice) {
//                                           //
//                                           //   bill = snap.get(
//                                           //       'bill_payment');
//                                           //   _setState(() {
//                                           //     balance =
//                                           //         balance - bill!;
//                                           //   });
//                                           // } else {
//                                           //
//                                           //   rentPrice = homeLoan;
//                                           //
//                                           //   _setState(() {
//                                           //     bill = rentPrice +
//                                           //         transportPrice +
//                                           //         lifestylePrice;
//                                           //     balance =
//                                           //         balance - bill!;
//                                           //     pref.setInt(
//                                           //         'rentPrice', 0);
//                                           //     pref.setInt(
//                                           //         'level4TotalPrice',
//                                           //         transportPrice +
//                                           //             lifestylePrice);
//                                           //   });
//                                           //   firestore
//                                           //       .collection('User')
//                                           //       .doc(userId)
//                                           //       .update({
//                                           //     'account_balance':
//                                           //         FieldValue
//                                           //             .increment(
//                                           //                 -balance),
//                                           //     'bill_payment':
//                                           //         transportPrice +
//                                           //             lifestylePrice,
//                                           //   });
//                                           // }
//                                           if (balance >= 0) {
//                                             firestore
//                                                 .collection('User')
//                                                 .doc(userId)
//                                                 .update({
//                                               'account_balance': balance,
//                                               if (home == 'EMI' &&
//                                                   homeLoan != 0)
//                                                 'home_loan':
//                                                 FieldValue.increment(
//                                                     -rentPrice),
//                                               if (transport == 'Other' &&
//                                                   transportLoan != 0)
//                                                 'transport_loan':
//                                                 FieldValue.increment(
//                                                     -transportPrice),
//                                             }).then((value) {
//                                               Navigator.pop(context);
//                                               _montlyDiscretionaryFund(
//                                                   balance, index);
//                                               // controller.animateToPage(
//                                               //     index + 1,
//                                               //     duration:
//                                               //     Duration(
//                                               //         seconds:
//                                               //         1),
//                                               //     curve: Curves
//                                               //         .easeIn);
//                                               // controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
//                                             });
//                                           } else {
//                                             _showDialogForRestartLevel(
//                                                 context);
//                                           }
//                                         },
//                                         child: Padding(
//                                           padding: EdgeInsets.only(
//                                             left: 3.w,
//                                           ),
//                                           child: Center(
//                                             child: FittedBox(
//                                               child: RichText(
//                                                 textAlign: TextAlign.left,
//                                                 overflow: TextOverflow.clip,
//                                                 text: TextSpan(
//                                                   text: 'Done ',
//                                                   style: GoogleFonts.workSans(
//                                                       color: color ==
//                                                           Color(0xff00C673)
//                                                           ? Colors.white
//                                                           : Color(0xff4D5DDD),
//                                                       fontWeight: FontWeight.w500,
//                                                       fontSize: 15.sp),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         )),
//                                   );
//                                 })),
//                         SizedBox(
//                           height: 2.h,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Spacer(),
//               Spacer(),
//             ],
//           ),
//         ),
//         previewChild: PreviewOfBottomDrawer(),
//         expandedChild: ExpandedBottomDrawer(),
//         minExtent: 14.h,
//         maxExtent: 55.h,
//       ));
//   //   );
//   // });
// }
//
// _montlyDiscretionaryFund(int balance, int index) async {
//
//   DocumentSnapshot snap =
//   await firestore.collection('User').doc(userId).get();
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   int homeLoan = snap.get('home_loan');
//   int index1 = snap.get('level_id');
//
//   int transportLoan = snap.get('transport_loan');
//   Color color = Colors.white;
//   homeLoanValue = 0;
//   transportLoanValue = 0;
//   lifestyleLoanValue = 0;
//   int totalFundAmount = 0;
//   if (home == 'Rent' && transport == 'Public') {
//     setState(() {
//       fundName = ['Mutual Fund'];
//     });
//   }
//
//   if (home == 'EMI' && transport == 'Other') {
//     setState(() {
//       fundName = ['Home Loan', 'Car Loan', 'Mutual Fund'];
//     });
//   }
//
//   if (home == 'Rent' && transport == 'Other') {
//     setState(() {
//       fundName = ['Car Loan', 'Mutual Fund'];
//     });
//   }
//
//   if (home == 'EMI' && transport == 'Public') {
//     setState(() {
//       fundName = ['Home Loan', 'Mutual Fund'];
//     });
//   }
//
//   if ((home == 'EMI' && homeLoan == 0) && transport == 'Public') {
//     setState(() {
//       fundName = ['Mutual Fund'];
//     });
//   }
//
//   if ((home == 'EMI' && homeLoan == 0) && transport == 'Other') {
//     setState(() {
//       fundName = ['Car Loan', 'Mutual Fund'];
//     });
//   }
//
//   if ((transport == 'Other' && transportLoan == 0) && home == 'Rent') {
//     setState(() {
//       fundName = ['Mutual Fund'];
//     });
//   }
//
//   if ((transport == 'Other' && transportLoan == 0) && home == 'EMI') {
//     setState(() {
//       fundName = ['Home Loan', 'Mutual Fund'];
//     });
//   }
//
//   if ((home == 'EMI' && homeLoan == 0) &&
//       (transport == 'Other' && transportLoan == 0)) {
//     setState(() {
//       fundName = ['Mutual Fund'];
//     });
//   }
//
//   return showDialog(
//       context: context, // <<----
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: Container(
//             width: 100.w,
//             height: 100.h,
//             decoration: boxDecoration,
//             child: Scaffold(
//                 backgroundColor: Colors.transparent,
//                 body: DraggableBottomSheet(
//                   backgroundWidget: Container(
//                     width: 100.w,
//                     height: 100.h,
//                     decoration: boxDecoration,
//                     child: Column(
//                       children: [
//                         Spacer(),
//                         GameScorePage(
//                           level: level,
//                           document: document,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 2.h),
//                           child: Container(
//                             alignment: Alignment.center,
//                             height: 54.h,
//                             width: 80.w,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(
//                                   8.w,
//                                 ),
//                                 color: Color(0xff6A81F4)),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       top: 2.h, left: 3.w, right: 3.w),
//                                   child: Text(
//                                     'Monthly Discretionary Fund',
//                                     style: GoogleFonts.workSans(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 2.h,
//                                 ),
//                                 ListView.builder(
//                                     physics: NeverScrollableScrollPhysics(),
//                                     shrinkWrap: true,
//                                     itemCount: fundName.length,
//                                     itemBuilder: (context, index) {
//                                       return StatefulBuilder(
//                                         builder: (context, _setState1) {
//                                           return Column(
//                                             children: [
//                                               Padding(
//                                                 padding: EdgeInsets.only(
//                                                   top: 1.h,
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     fundName[index],
//                                                     style:
//                                                     GoogleFonts.workSans(
//                                                         color:
//                                                         Colors.white,
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .w500,
//                                                         fontSize: 16.sp),
//                                                     textAlign: TextAlign.left,
//                                                     overflow:
//                                                     TextOverflow.clip,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 1.h,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                                 children: [
//                                                   GestureDetector(
//                                                     child: Container(
//                                                       height: 5.h,
//                                                       width: 12.w,
//                                                       child: Icon(
//                                                         Icons.remove,
//                                                         color:
//                                                         Color(0xff979797),
//                                                       ),
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius.only(
//                                                           topLeft:
//                                                           Radius.circular(
//                                                               2.w),
//                                                           bottomLeft:
//                                                           Radius.circular(
//                                                               2.w),
//                                                         ),
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                     onTap: () {
//                                                       if (fundName[index] ==
//                                                           'Home Loan' &&
//                                                           homeLoanValue !=
//                                                               0) {
//                                                         _setState1(() {
//                                                           homeLoanValue =
//                                                               homeLoanValue -
//                                                                   100;
//                                                         });
//                                                       }
//                                                       if (fundName[index] ==
//                                                           'Car Loan' &&
//                                                           transportLoanValue !=
//                                                               0) {
//                                                         _setState1(() {
//                                                           transportLoanValue =
//                                                               transportLoanValue -
//                                                                   100;
//                                                         });
//                                                       }
//                                                       if (fundName[index] ==
//                                                           'Mutual Fund' &&
//                                                           lifestyleLoanValue !=
//                                                               0) {
//                                                         _setState1(() {
//                                                           lifestyleLoanValue =
//                                                               lifestyleLoanValue -
//                                                                   100;
//                                                         });
//                                                       }
//
//                                                     },
//                                                   ),
//                                                   Container(
//                                                     width: 26.w,
//                                                     height: 5.h,
//                                                     child: Text(
//                                                       '${fundName[index] == 'Home Loan' ? homeLoanValue.toString() : fundName[index] == 'Car Loan' ? transportLoanValue : lifestyleLoanValue}',
//                                                       style: GoogleFonts
//                                                           .workSans(
//                                                         color: Colors.black,
//                                                         fontSize: 12.sp,
//                                                         fontWeight:
//                                                         FontWeight.w600,
//                                                       ),
//                                                     ),
//                                                     alignment:
//                                                     Alignment.center,
//                                                     color: Color(0xffFCE681),
//                                                   ),
//                                                   GestureDetector(
//                                                     child: Container(
//                                                       height: 5.h,
//                                                       width: 12.w,
//                                                       child: Icon(
//                                                         Icons.add,
//                                                         color:
//                                                         Color(0xff979797),
//                                                       ),
//                                                       decoration:
//                                                       BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius.only(
//                                                           bottomRight:
//                                                           Radius.circular(
//                                                               2.w),
//                                                           topRight:
//                                                           Radius.circular(
//                                                               2.w),
//                                                         ),
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                     onTap: () {
//                                                       if (fundName[index] ==
//                                                           'Home Loan') {
//                                                         if (homeLoanValue ==
//                                                             homeLoan) {
//                                                           Fluttertoast.showToast(
//                                                               msg:
//                                                               'Your Home EMI is only $homeLoan Left');
//                                                         } else {
//                                                           _setState1(() {
//                                                             homeLoanValue =
//                                                                 homeLoanValue +
//                                                                     100;
//                                                           });
//                                                         }
//                                                       }
//                                                       if (fundName[index] ==
//                                                           'Car Loan') {
//                                                         if (transportLoanValue ==
//                                                             transportLoan) {
//                                                           Fluttertoast.showToast(
//                                                               msg:
//                                                               'Your Transport EMI is only $transportLoan Left');
//                                                         } else {
//                                                           _setState1(() {
//                                                             transportLoanValue =
//                                                                 transportLoanValue +
//                                                                     100;
//                                                           });
//                                                         }
//                                                       }
//                                                       if (fundName[index] ==
//                                                           'Mutual Fund') {
//                                                         _setState1(() {
//                                                           lifestyleLoanValue =
//                                                               lifestyleLoanValue +
//                                                                   100;
//                                                         });
//                                                       }
//
//
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 height: 2.h,
//                                               ),
//                                               if (home == 'EMI' &&
//                                                   homeLoan == 0 &&
//                                                   index ==
//                                                       fundName.length - 1)
//                                                 Container(
//                                                   child: ElevatedButton(
//                                                     onPressed: () {},
//                                                     child: FittedBox(
//                                                       child: Text(
//                                                         'Home Loan Fully Paid',
//                                                         style: GoogleFonts
//                                                             .workSans(
//                                                           color: Colors.white,
//                                                           fontSize: 12.sp,
//                                                           fontWeight:
//                                                           FontWeight.w600,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     style: ButtonStyle(
//                                                       backgroundColor:
//                                                       MaterialStateProperty
//                                                           .all(
//                                                         Color(0xff9e9e9e),
//                                                       ),
//                                                       shape: MaterialStateProperty.all(
//                                                           RoundedRectangleBorder(
//                                                               borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                   2.w))),
//                                                     ),
//                                                   ),
//                                                   height: 5.h,
//                                                   width: 50.w,
//                                                 ),
//                                               if (home == 'EMI' &&
//                                                   homeLoan == 0 &&
//                                                   index ==
//                                                       fundName.length - 1)
//                                                 SizedBox(
//                                                   height: 2.h,
//                                                 ),
//                                               if (transport == 'Other' &&
//                                                   transportLoan == 0 &&
//                                                   index ==
//                                                       fundName.length - 1)
//                                                 Container(
//                                                   child: ElevatedButton(
//                                                     onPressed: () {},
//                                                     child: FittedBox(
//                                                       child: Text(
//                                                         'Transport Loan Fully Paid',
//                                                         style: GoogleFonts
//                                                             .workSans(
//                                                           color: Colors.white,
//                                                           fontSize: 12.sp,
//                                                           fontWeight:
//                                                           FontWeight.w600,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     style: ButtonStyle(
//                                                       backgroundColor:
//                                                       MaterialStateProperty
//                                                           .all(
//                                                         Color(0xff9e9e9e),
//                                                       ),
//                                                       shape: MaterialStateProperty.all(
//                                                           RoundedRectangleBorder(
//                                                               borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                   2.w))),
//                                                     ),
//                                                   ),
//                                                   height: 5.h,
//                                                   width: 50.w,
//                                                 ),
//                                               if (home == 'EMI' &&
//                                                   homeLoan == 0 &&
//                                                   index ==
//                                                       fundName.length - 1)
//                                                 SizedBox(
//                                                   height: 2.h,
//                                                 ),
//                                               // if (home == 'EMI' &&
//                                               //     value == 0 &&
//                                               //     index == 0)
//                                               //   SizedBox(
//                                               //     height: 2.h,
//                                               //   ),
//                                               // if (home == 'EMI' &&
//                                               //     value == 0 &&
//                                               //     index == 0)
//                                               //   Container(
//                                               //     child: ElevatedButton(
//                                               //       onPressed: () {},
//                                               //       child: Text(
//                                               //           'Home Loan Fully Paid'),
//                                               //       style: ButtonStyle(
//                                               //           backgroundColor:
//                                               //           MaterialStateProperty
//                                               //               .all(
//                                               //             Color(0xffA8A8A8),
//                                               //           )),
//                                               //     ),
//                                               //     height: 5.h,
//                                               //     width: 50.w,
//                                               //   ),
//                                               // if (home == 'EMI' &&
//                                               //     value == 0 &&
//                                               //     index == 0)
//                                               //   SizedBox(
//                                               //     height: 2.h,
//                                               //   ),
//                                             ],
//                                           );
//                                         },
//                                       );
//                                     }),
//                                 Padding(
//                                     padding: EdgeInsets.only(top: 2.h),
//                                     child: StatefulBuilder(
//                                         builder: (context, _setState) {
//                                           return Container(
//                                             alignment: Alignment.centerLeft,
//                                             width: 62.w,
//                                             height: 7.h,
//                                             decoration: BoxDecoration(
//                                                 color: color,
//                                                 borderRadius:
//                                                 BorderRadius.circular(12.w)),
//                                             child: TextButton(
//                                                 onPressed: color ==
//                                                     Color(0xff00C673)
//                                                     ? () {}
//                                                     : () {
//                                                   _setState(() {
//                                                     color =
//                                                         Color(0xff00C673);
//                                                     totalFundAmount =
//                                                         homeLoanValue +
//                                                             transportLoanValue +
//                                                             lifestyleLoanValue;
//                                                     balance = balance -
//                                                         totalFundAmount;
//                                                   });
//
//                                                   if (balance >= 0) {
//                                                     firestore
//                                                         .collection('User')
//                                                         .doc(userId)
//                                                         .update({
//                                                       'account_balance':
//                                                       balance,
//                                                       if (home == 'EMI' &&
//                                                           homeLoan != 0)
//                                                         'home_loan': FieldValue
//                                                             .increment(
//                                                             -homeLoanValue),
//                                                       if (transport ==
//                                                           'Other' &&
//                                                           transportLoan !=
//                                                               0)
//                                                         'transport_loan':
//                                                         FieldValue
//                                                             .increment(
//                                                             -transportLoanValue),
//                                                     }).then((value) {
//                                                       if (home == 'EMI' &&
//                                                           homeLoan == 0) {
//                                                         pref.setInt(
//                                                             'rentPrice', 0);
//                                                         pref.setInt(
//                                                             'level4TotalPrice',
//                                                             transportPrice +
//                                                                 lifestylePrice);
//                                                         firestore
//                                                             .collection(
//                                                             'User')
//                                                             .doc(userId)
//                                                             .update({
//                                                           'bill_payment':
//                                                           transportPrice +
//                                                               lifestylePrice,
//                                                         });
//                                                       }
//                                                       if (transport ==
//                                                           'Other' &&
//                                                           transportLoan ==
//                                                               0) {
//                                                         pref.setInt(
//                                                             'transportPrice',
//                                                             0);
//                                                         pref.setInt(
//                                                             'level4TotalPrice',
//                                                             rentPrice +
//                                                                 lifestylePrice);
//                                                         firestore
//                                                             .collection(
//                                                             'User')
//                                                             .doc(userId)
//                                                             .update({
//                                                           'bill_payment':
//                                                           rentPrice +
//                                                               lifestylePrice,
//                                                         });
//                                                       }
//                                                       firestore
//                                                           .collection(
//                                                           'User')
//                                                           .doc(userId)
//                                                           .update({
//                                                         'account_balance':
//                                                         FieldValue
//                                                             .increment(
//                                                             2000),
//                                                       });
//                                                     }).then((value) {
//                                                       int index1 = snap
//                                                           .get('level_id');
//
//
//                                                       Navigator.pop(
//                                                           context);
//                                                       Future.delayed(
//                                                           Duration(
//                                                               seconds: 1),
//                                                               () => controller.animateToPage(
//                                                               index + 1,
//                                                               duration:
//                                                               Duration(
//                                                                   seconds:
//                                                                   1),
//                                                               curve: Curves
//                                                                   .easeIn));
//                                                     });
//                                                   } else {
//                                                     _showDialogForRestartLevel(
//                                                         context);
//                                                   }
//                                                 },
//                                                 child: Padding(
//                                                   padding:
//                                                   EdgeInsets.only(left: 3.w),
//                                                   child: Center(
//                                                     child: FittedBox(
//                                                       child: RichText(
//                                                         textAlign: TextAlign.left,
//                                                         overflow:
//                                                         TextOverflow.clip,
//                                                         text: TextSpan(
//                                                           text: 'Done ',
//                                                           style: GoogleFonts.workSans(
//                                                               color: color ==
//                                                                   Color(
//                                                                       0xff00C673)
//                                                                   ? Colors.white
//                                                                   : Color(
//                                                                   0xff4D5DDD),
//                                                               fontWeight:
//                                                               FontWeight.w500,
//                                                               fontSize: 15.sp),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )),
//                                           );
//                                         })),
//                                 SizedBox(
//                                   height: 2.h,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         Spacer(),
//                         Spacer(),
//                         Spacer(),
//                       ],
//                     ),
//                   ),
//                   previewChild: PreviewOfBottomDrawer(),
//                   expandedChild: ExpandedBottomDrawer(),
//                   minExtent: 14.h,
//                   maxExtent: 55.h,
//                 )),
//           ),
//         );
//       });
// }
// _showDialogForRestartLevel(BuildContext context) {
//   return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: AlertDialog(
//             elevation: 3.0,
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.circular(displayWidth(context) * .04)),
//             actionsPadding: EdgeInsets.all(8.0),
//             backgroundColor: Color(0xff6646E6),
//             content: Text(
//               'Oops! You do not have enough money in your account to make this purchase.\n Press restart to try again.',
//               style: GoogleFonts.workSans(
//                   color: Colors.white, fontWeight: FontWeight.w600),
//               textAlign: TextAlign.center,
//             ),
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//                     firestore.collection('User').doc(userId).update({
//                       'previous_session_info': 'Level_2_setUp_page',
//                       'bill_payment': 0,
//                       'level_id': 0,
//                       'credit_card_balance': 0,
//                       'credit_card_bill': 0,
//                       'credit_score': 0,
//                       'payable_bill': 0,
//                       'quality_of_life': 0,
//                       'score': 0
//                     });
//                     Navigator.pushReplacement(
//                         context,
//                         PageTransition(
//                             child: LevelTwoSetUpPage(
//                                 controller: PageController()),
//                             type: PageTransitionType.bottomToTop,
//                             duration: Duration(milliseconds: 500)));
//                   },
//                   style: ButtonStyle(
//                       backgroundColor:
//                       MaterialStateProperty.all(Colors.white)),
//                   child: Text(
//                     'Restart level',
//                     style: GoogleFonts.workSans(
//                       color: Color(0xff6646E6),
//                     ),
//                   )),
//             ],
//           ),
//         );
//       });
// }
//
// _optionSelect(
//     int balance,
//     int gameScore,
//     int qualityOfLife,
//     int qol2,
//     int index,
//     AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
//     category,
//     int price) async {
//   if (index == snapshot.data!.docs.length - 1) {
//     firestore.collection('User').doc(userId).update({
//       'level_id': index + 1,
//       'level_2_id': index + 1,
//     }).then((value) => Future.delayed(
//         Duration(seconds: 1),
//             () => _levelCompleteSummary(
//             context, gameScore, balance, qualityOfLife)));
//   }
//   if (balance >= 0) {
//     firestore.collection('User').doc(userId).update({
//       'account_balance': balance,
//       'quality_of_life': FieldValue.increment(qol2),
//       'game_score': gameScore + balance + qualityOfLife,
//       'level_id': index + 1,
//       'level_2_id': index + 1,
//       'need': category == 'Need'
//           ? FieldValue.increment(price)
//           : FieldValue.increment(0),
//       'want': category == 'Want'
//           ? FieldValue.increment(price)
//           : FieldValue.increment(0),
//     });
//     controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
//   } else {
//     setState(() {
//       scroll = false;
//     });
//     _showDialogForRestartLevel(context);
//   }
// }

// _levelCompleteSummary(BuildContext context, int gameScore, int balance,
//     int qualityOfLife) async {
//   var forPortrait = displayHeight(context);
//   var bottomHeightPotrait = displayHeight(context) * .14;
//   forPortrait = forPortrait - bottomHeightPotrait;
//
//   DocumentSnapshot documentSnapshot =
//   await firestore.collection('User').doc(userId).get();
//   int need = documentSnapshot['need'];
//   int want = documentSnapshot['want'];
//   int bill = documentSnapshot['bill_payment'];
//   int accountBalance = documentSnapshot['account_balance'];
//
//   Color color = Colors.white;
//   return showDialog(
//       context: context, // <<----
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: Container(
//             width: displayWidth(context),
//             height: displayHeight(context),
//             decoration: boxDecoration,
//             child: Scaffold(
//                 backgroundColor: Colors.transparent,
//                 body: DraggableBottomSheet(
//                   backgroundWidget: Container(
//                     width: displayWidth(context),
//                     height: forPortrait,
//                     decoration: boxDecoration,
//                     child: Column(
//                       children: [
//                         GameScorePage(
//                           level: level,
//                           document: document,
//                         ),
//                         SizedBox(
//                           height: forPortrait * .04,
//                         ),
//                         Flexible(
//                           child: Container(
//                             alignment: Alignment.center,
//                             height: forPortrait * .86 - bottomHeightPotrait,
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: displayWidth(context) * .80,
//                               height: forPortrait * .81 - bottomHeightPotrait,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(
//                                     displayWidth(context) * .08,
//                                   ),
//                                   color: Color(0xff6A81F4)),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.center,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                           top: displayHeight(context) * .02,
//                                           left: displayWidth(context) * .04,
//                                           right: displayWidth(context) * .04),
//                                       child: Text(
//                                         'Congratulations! You have completed this level successfully ',
//                                         style: GoogleFonts.workSans(
//                                           fontSize: 16.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         top: displayHeight(context) * .02,
//                                       ),
//                                       child: Center(
//                                         child: RichText(
//                                           textAlign: TextAlign.left,
//                                           overflow: TextOverflow.clip,
//                                           text: TextSpan(
//                                               text: 'Salary Earned : ',
//                                               style: GoogleFonts.workSans(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 16.sp),
//                                               children: [
//                                                 TextSpan(
//                                                   text:
//                                                   '\$' + 6000.toString(),
//                                                   style: GoogleFonts.workSans(
//                                                       color:
//                                                       Color(0xffFEBE16),
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                       fontSize: 16.sp),
//                                                 ),
//                                               ]),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         top: displayHeight(context) * .01,
//                                       ),
//                                       child: Center(
//                                         child: RichText(
//                                           textAlign: TextAlign.left,
//                                           overflow: TextOverflow.clip,
//                                           text: TextSpan(
//                                               text: 'Bills Paid : ',
//                                               style: GoogleFonts.workSans(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 16.sp),
//                                               children: [
//                                                 TextSpan(
//                                                   text:
//                                                   '${(((bill * 6) / 6000) * 100).floor()}' +
//                                                       '%',
//                                                   style: GoogleFonts.workSans(
//                                                       color:
//                                                       Color(0xffFEBE16),
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                       fontSize: 16.sp),
//                                                 ),
//                                               ]),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         top: displayHeight(context) * .01,
//                                       ),
//                                       child: Center(
//                                         child: RichText(
//                                           textAlign: TextAlign.left,
//                                           overflow: TextOverflow.clip,
//                                           text: TextSpan(
//                                               text: 'Spent on Needs : ',
//                                               style: GoogleFonts.workSans(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 16.sp),
//                                               children: [
//                                                 TextSpan(
//                                                   text:
//                                                   '${((need / 6000) * 100).floor()}' +
//                                                       '%',
//                                                   style: GoogleFonts.workSans(
//                                                       color:
//                                                       Color(0xffFEBE16),
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                       fontSize: 16.sp),
//                                                 ),
//                                               ]),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         top: displayHeight(context) * .01,
//                                       ),
//                                       child: Center(
//                                         child: RichText(
//                                           textAlign: TextAlign.left,
//                                           overflow: TextOverflow.clip,
//                                           text: TextSpan(
//                                               text: 'Spent on Wants : ',
//                                               style: GoogleFonts.workSans(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 16.sp),
//                                               children: [
//                                                 TextSpan(
//                                                   text:
//                                                   '${((want / 6000) * 100).floor()}' +
//                                                       '%',
//                                                   style: GoogleFonts.workSans(
//                                                       color:
//                                                       Color(0xffFEBE16),
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                       fontSize: 16.sp),
//                                                 ),
//                                               ]),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         top: displayHeight(context) * .01,
//                                       ),
//                                       child: Center(
//                                         child: RichText(
//                                           textAlign: TextAlign.left,
//                                           overflow: TextOverflow.clip,
//                                           text: TextSpan(
//                                               text: 'Money Saved : ',
//                                               style: GoogleFonts.workSans(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 16.sp),
//                                               children: [
//                                                 TextSpan(
//                                                   text:
//                                                   '${((accountBalance / 6000) * 100).floor()}' +
//                                                       '%',
//                                                   style: GoogleFonts.workSans(
//                                                       color:
//                                                       Color(0xffFEBE16),
//                                                       fontWeight:
//                                                       FontWeight.w500,
//                                                       fontSize: 16.sp),
//                                                 ),
//                                               ]),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                         padding: EdgeInsets.only(
//                                             top:
//                                             displayHeight(context) * .04),
//                                         child: StatefulBuilder(
//                                             builder: (context, setState) {
//                                               return Container(
//                                                 alignment: Alignment.centerLeft,
//                                                 width:
//                                                 displayWidth(context) * .62,
//                                                 height:
//                                                 displayHeight(context) * .07,
//                                                 decoration: BoxDecoration(
//                                                     color: color,
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         displayWidth(
//                                                             context) *
//                                                             .12)),
//                                                 child: color == Color(0xff00C673)
//                                                     ? TextButton(
//                                                     onPressed: () {},
//                                                     child: Padding(
//                                                       padding:
//                                                       EdgeInsets.only(
//                                                           left: 6.0),
//                                                       child: Center(
//                                                         child: FittedBox(
//                                                           child: Text(
//                                                             'Play Next Level',
//                                                             style: GoogleFonts.workSans(
//                                                                 color: color ==
//                                                                     Color(
//                                                                         0xff00C673)
//                                                                     ? Colors
//                                                                     .white
//                                                                     : Color(
//                                                                     0xff4D5DDD),
//                                                                 fontWeight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontSize:
//                                                                 15.sp),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .left,
//                                                             overflow:
//                                                             TextOverflow
//                                                                 .clip,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ))
//                                                     : TextButton(
//                                                     onPressed: () {
//                                                       setState(() {
//                                                         color =
//                                                             Color(0xff00C673);
//                                                       });
//                                                       int myBal =
//                                                       documentSnapshot.get(
//                                                           'account_balance');
//
//                                                       if (myBal < 1200) {
//                                                         Future.delayed(
//                                                             Duration(
//                                                                 seconds: 1),
//                                                                 () =>
//                                                                 _showDialogWhenAmountLessSavingGoal(
//                                                                     context));
//                                                       } else {
//                                                         Future.delayed(
//                                                             Duration(
//                                                                 seconds: 2),
//                                                                 () => showDialog(
//                                                                 barrierDismissible:
//                                                                 false,
//                                                                 context:
//                                                                 context,
//                                                                 builder:
//                                                                     (context) {
//                                                                   return WillPopScope(
//                                                                     onWillPop:
//                                                                         () {
//                                                                       return Future.value(
//                                                                           false);
//                                                                     },
//                                                                     child:
//                                                                     AlertDialog(
//                                                                       elevation:
//                                                                       3.0,
//                                                                       shape: RoundedRectangleBorder(
//                                                                           borderRadius:
//                                                                           BorderRadius.circular(displayWidth(context) * .04)),
//                                                                       actionsPadding:
//                                                                       EdgeInsets.all(8.0),
//                                                                       backgroundColor:
//                                                                       Color(0xff6646E6),
//                                                                       content:
//                                                                       Text(
//                                                                         'Woohoo! Invites unlocked!  \n\n Invite your friends to play the game and challenge them to beat your score!',
//                                                                         style: GoogleFonts.workSans(
//                                                                             color: Colors.white,
//                                                                             fontWeight: FontWeight.w600),
//                                                                         textAlign:
//                                                                         TextAlign.center,
//                                                                       ),
//                                                                       actions: [
//                                                                         Row(
//                                                                           mainAxisAlignment:
//                                                                           MainAxisAlignment.spaceEvenly,
//                                                                           children: [
//                                                                             ElevatedButton(
//                                                                                 onPressed: () async {
//                                                                                   bool value = documentSnapshot.get('replay_level');
//                                                                                   level = documentSnapshot.get('last_level');
//                                                                                   int myBal = documentSnapshot.get('account_balance');
//
//                                                                                   level = level.toString().substring(6, 7);
//                                                                                   int lev = int.parse(level);
//
//                                                                                   if (value == true) {
//                                                                                     Future.delayed(
//                                                                                         Duration(seconds: 1),
//                                                                                             () => showDialog(
//                                                                                             context: context,
//                                                                                             barrierDismissible: false,
//                                                                                             builder: (context) {
//                                                                                               return WillPopScope(
//                                                                                                 onWillPop: () {
//                                                                                                   return Future.value(false);
//                                                                                                 },
//                                                                                                 child: AlertDialog(
//                                                                                                   elevation: 3.0,
//                                                                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(displayWidth(context) * .04)),
//                                                                                                   titlePadding: EdgeInsets.zero,
//                                                                                                   title: Container(
//                                                                                                     width: displayWidth(context),
//                                                                                                     child: Padding(
//                                                                                                       padding: EdgeInsets.all(8.0),
//                                                                                                       child: Text(
//                                                                                                         'Congratulations! You have completed this level successfully',
//                                                                                                         textAlign: TextAlign.center,
//                                                                                                         style: GoogleFonts.workSans(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.w500),
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                     decoration: BoxDecoration(
//                                                                                                         borderRadius: BorderRadius.only(
//                                                                                                           topRight: Radius.circular(displayWidth(context) * .04),
//                                                                                                           topLeft: Radius.circular(displayWidth(context) * .04),
//                                                                                                         ),
//                                                                                                         color: Color(0xffE9E5FF)),
//                                                                                                   ),
//                                                                                                   content: Column(
//                                                                                                     mainAxisSize: MainAxisSize.min,
//                                                                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                                                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                                                                                     children: [
//                                                                                                       if (lev > 1)
//                                                                                                         Text(
//                                                                                                           'Which level you want play ?',
//                                                                                                           style: GoogleFonts.workSans(fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w400),
//                                                                                                         ),
//                                                                                                       if (lev > 1) _level1(lev),
//                                                                                                       if (lev > 2) _level2(lev),
//                                                                                                       if (lev > 3) _level3(lev),
//                                                                                                       if (lev > 4) _level4(lev),
//                                                                                                       if (lev > 5) _level5(lev),
//                                                                                                       Padding(
//                                                                                                         padding: EdgeInsets.only(top: displayHeight(context) * .03),
//                                                                                                         child: Text(
//                                                                                                           'Want to play current level ?',
//                                                                                                           style: GoogleFonts.workSans(fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w400),
//                                                                                                         ),
//                                                                                                       ),
//                                                                                                       if (lev == 1) _level1(lev),
//                                                                                                       if (lev == 2) _level2(lev),
//                                                                                                       if (lev == 3) _level3(lev),
//                                                                                                       if (lev == 4) _level4(lev),
//                                                                                                       if (lev == 5) _level5(lev),
//                                                                                                     ],
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               );
//                                                                                             }));
//                                                                                   } else {
//                                                                                     FlutterShare.share(title: 'https://finshark.page.link/finshark',
//                                                                                         text: 'Hey! Have you tried out the Finshark app? It\'s a fun game that helps you build smart financial habits. You can learn to budget, invest and more. I think you\'ll like it!',
//                                                                                         linkUrl: 'https://finshark.page.link/finshark',
//                                                                                         chooserTitle: 'https://finshark.page.link/finshark').then((value) {
//                                                                                       // Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelThreeSetUpPage(controller: PageController()))));
//                                                                                     }).then((value) {
//                                                                                       Navigator.pop(context);
//                                                                                       Future.delayed(Duration(seconds: 1), () => _playLevelOrPopQuiz());
//                                                                                     });
//                                                                                   }
//                                                                                 },
//                                                                                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
//                                                                                 child: Text(
//                                                                                   'Click here to invite ',
//                                                                                   style: GoogleFonts.workSans(
//                                                                                     color: Color(0xff6646E6),
//                                                                                   ),
//                                                                                 )),
//                                                                             GestureDetector(
//                                                                               child: Text(
//                                                                                 'Skip',
//                                                                                 style: GoogleFonts.workSans(
//                                                                                   color: Colors.white,
//                                                                                   fontWeight: FontWeight.w600,
//                                                                                   decoration: TextDecoration.underline,
//                                                                                 ),
//                                                                               ),
//                                                                               onTap: () {
//                                                                                 Navigator.pop(context);
//                                                                                 Future.delayed(Duration(seconds: 1), () => _playLevelOrPopQuiz());
//                                                                               },
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   );
//                                                                 }));
//                                                       }
//                                                     },
//                                                     child: Padding(
//                                                       padding:
//                                                       EdgeInsets.only(
//                                                           left: 6.0),
//                                                       child: Center(
//                                                         child: FittedBox(
//                                                           child: Text(
//                                                             'Play Next Level',
//                                                             style: GoogleFonts.workSans(
//                                                                 color: color ==
//                                                                     Color(
//                                                                         0xff00C673)
//                                                                     ? Colors
//                                                                     .white
//                                                                     : Color(
//                                                                     0xff4D5DDD),
//                                                                 fontWeight:
//                                                                 FontWeight
//                                                                     .w500,
//                                                                 fontSize:
//                                                                 15.sp),
//                                                             textAlign:
//                                                             TextAlign
//                                                                 .left,
//                                                             overflow:
//                                                             TextOverflow
//                                                                 .clip,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     )),
//                                               );
//                                             })),
//                                     SizedBox(
//                                       height: displayHeight(context) * .02,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   previewChild: PreviewOfBottomDrawer(),
//                   expandedChild: ExpandedBottomDrawer(),
//                   minExtent: displayHeight(context) * .14,
//                   maxExtent: displayHeight(context) * .55,
//                 )),
//           ),
//         );
//       });
// }
// _playLevelOrPopQuiz() {
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: AlertDialog(
//             elevation: 3.0,
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.circular(displayWidth(context) * .04)),
//             titlePadding: EdgeInsets.zero,
//             title: Container(
//               width: displayWidth(context),
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'Congrats! You’ve managed to achieve your savings goal! Mission accomplished!',
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.workSans(
//                       fontSize: 14.sp,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(displayWidth(context) * .04),
//                     topLeft: Radius.circular(displayWidth(context) * .04),
//                   ),
//                   color: Color(0xffE9E5FF)),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                     onPressed: () {
//                       Future.delayed(Duration(seconds: 2), () {
//                         firestore.collection("User").doc(userId).update({
//                           'bill_payment': 0,
//                           'credit_card_bill': 0,
//                           'previous_session_info': 'Level_2_Pop_Quiz',
//                           'last_level': 'Level_2_Pop_Quiz',
//                           'credit_card_balance': 0,
//                           'account_balance': 0,
//                           'level_id': 0,
//                           'credit_score': 0,
//                           'payable_bill': 0,
//                           'score': 0,
//                           'need': 0,
//                           'want': 0,
//                           'level_2_popQuiz_id': 0,
//                         });
//                         Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => PopQuiz(levelId: 0)));
//                       });
//                     },
//                     child: Text('Play Pop Quiz')),
//                 ElevatedButton(
//                     onPressed: () {
//                       Future.delayed(Duration(seconds: 2), () {
//                         FirebaseFirestore.instance
//                             .collection('User')
//                             .doc(userId)
//                             .update({
//                           'previous_session_info': 'Level_3_setUp_page',
//                           'bill_payment': 0,
//                           'level_id': 0,
//                           'credit_card_balance': 0,
//                           'credit_card_bill': 0,
//                           'credit_score': 0,
//                           'payable_bill': 0,
//                           'last_level': 'Level_3_setUp_page',
//                           'replay_level': false,
//                           'score': 0,
//                           'need': 0,
//                           'want': 0,
//                           'level_3_popQuiz_id': 0
//                         });
//                         Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LevelThreeSetUpPage(
//                                     controller: PageController())));
//                       });
//                     },
//                     child: Text('Play Next Level'))
//               ],
//             ),
//           ),
//         );
//       });
// }
// _showDialogWhenAmountLessSavingGoal(BuildContext context) {
//   return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: AlertDialog(
//             elevation: 3.0,
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.circular(displayWidth(context) * .04)),
//             actionsPadding: EdgeInsets.all(8.0),
//             backgroundColor: Color(0xff6646E6),
//             content: Text(
//               'Oops! You haven\’t managed to achieve your savings goal of \$1200. Please try again!',
//               style: GoogleFonts.workSans(
//                   color: Colors.white, fontWeight: FontWeight.w600),
//               textAlign: TextAlign.center,
//             ),
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//                     firestore.collection('User').doc(userId).update({
//                       'previous_session_info': 'Level_2_setUp_page',
//                       'bill_payment': 0,
//                       'level_id': 0,
//                       'credit_card_balance': 0,
//                       'credit_card_bill': 0,
//                       'credit_score': 0,
//                       'payable_bill': 0,
//                       'quality_of_life': 0,
//                       'score': 0,
//                       'account_balance': 0,
//                       'need': 0,
//                       'want': 0,
//                     });
//                     Navigator.pushReplacement(
//                         context,
//                         PageTransition(
//                             child: LevelTwoSetUpPage(
//                                 controller: PageController()),
//                             type: PageTransitionType.bottomToTop,
//                             duration: Duration(milliseconds: 500)));
//                   },
//                   style: ButtonStyle(
//                       backgroundColor:
//                       MaterialStateProperty.all(Colors.white)),
//                   child: Text(
//                     'Restart level',
//                     style: GoogleFonts.workSans(
//                       color: Color(0xff6646E6),
//                     ),
//                   )),
//             ],
//           ),
//         );
//       });
// }
// _level1(int lev) {
//   return Padding(
//       padding: EdgeInsets.only(top: displayWidth(context) * .03),
//       child: Container(
//         width: displayWidth(context) * .40,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(displayWidth(context) * .12)),
//         child: ElevatedButton(
//           onPressed: () async {
//             DocumentSnapshot document =
//             await firestore.collection('User').doc(userId).get();
//             gameScore = document.get('game_score');
//             if (lev == 1) {
//               firestore.collection('User').doc(userId).update({
//                 'replay_level': false,
//                 'previous_session_info': 'Level_1',
//                 'account_balance': 0,
//                 'bill_payment': 0,
//                 'credit_card_balance': 0,
//                 'credit_card_bill': 0,
//                 'credit_score': 0,
//                 'level_id': 0,
//                 'payable_bill': 0,
//                 'quality_of_life': 0,
//                 'score': 0,
//                 'last_level': 'Level_1',
//               });
//               Navigator.pushReplacement(
//                   context,
//                   PageTransition(
//                       child: AllQueLevelOne(
//                         billPayment: 0,
//                         gameScore: gameScore,
//                         level: 'Level_1',
//                         levelId: 0,
//                         qOl: 0,
//                         savingBalance: 200,
//                         creditCardBalance: 0,
//                         creditCardBill: 0,
//                         payableBill: 0,
//                       ),
//                       duration: Duration(milliseconds: 500),
//                       type: PageTransitionType.bottomToTop));
//             } else {
//               firestore.collection('User').doc(userId).update({
//                 'previous_session_info': 'Level_1',
//                 'account_balance': 0,
//                 'bill_payment': 0,
//                 'credit_card_balance': 0,
//                 'credit_card_bill': 0,
//                 'credit_score': 0,
//                 'level_id': 0,
//                 'payable_bill': 0,
//                 'quality_of_life': 0,
//                 'score': 0
//               });
//               Navigator.pushReplacement(
//                   context,
//                   PageTransition(
//                       child: AllQueLevelOne(
//                         billPayment: 0,
//                         gameScore: gameScore,
//                         level: 'Level_1',
//                         levelId: 0,
//                         qOl: 0,
//                         savingBalance: 200,
//                         creditCardBalance: 0,
//                         creditCardBill: 0,
//                         payableBill: 0,
//                       ),
//                       duration: Duration(milliseconds: 500),
//                       type: PageTransitionType.bottomToTop));
//             }
//           },
//           child: Text('Level 1'),
//           style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(
//                 Color(0xff828FCE),
//               )),
//         ),
//       ));
// }
// _level2(int lev) {
//   return Padding(
//       padding: EdgeInsets.only(top: displayWidth(context) * .01),
//       child: Container(
//         width: displayWidth(context) * .40,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(displayWidth(context) * .12)),
//         child: ElevatedButton(
//           onPressed: () {
//             if (lev == 2) {
//               firestore.collection('User').doc(userId).update({
//                 'replay_level': false,
//                 'previous_session_info': 'Level_2_setUp_page',
//                 'last_level': 'Level_2_setUp_page',
//                 'account_balance': 0,
//                 'bill_payment': 0,
//                 'credit_card_balance': 0,
//                 'credit_card_bill': 0,
//                 'credit_score': 0,
//                 'level_id': 0,
//                 'payable_bill': 0,
//                 'quality_of_life': 0,
//                 'score': 0
//               });
//               Navigator.pushReplacement(
//                   context,
//                   PageTransition(
//                       child: LevelTwoSetUpPage(
//                         controller: PageController(),
//                       ),
//                       duration: Duration(milliseconds: 500),
//                       type: PageTransitionType.bottomToTop));
//             } else {
//               firestore.collection('User').doc(userId).update({
//                 'previous_session_info': 'Level_2_setUp_page',
//                 'account_balance': 0,
//                 'bill_payment': 0,
//                 'credit_card_balance': 0,
//                 'credit_card_bill': 0,
//                 'credit_score': 0,
//                 'level_id': 0,
//                 'payable_bill': 0,
//                 'quality_of_life': 0,
//                 'score': 0
//               });
//               Navigator.pushReplacement(
//                   context,
//                   PageTransition(
//                       child: LevelTwoSetUpPage(
//                         controller: PageController(),
//                       ),
//                       duration: Duration(milliseconds: 500),
//                       type: PageTransitionType.bottomToTop));
//             }
//           },
//           child: Text('Level 2'),
//           style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(
//                 Color(0xff828FCE),
//               )),
//         ),
//       ));
// }
// _level3(int lev) {
//   return Padding(
//       padding: EdgeInsets.only(top: displayWidth(context) * .02),
//       child: Container(
//         width: displayWidth(context) * .40,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(displayWidth(context) * .12)),
//         child: ElevatedButton(
//           onPressed: () {
//             if (lev == 3) {
//               firestore.collection('User').doc(userId).update({
//                 'replay_level': false,
//                 'previous_session_info': 'Level_3_setUp_page',
//                 'last_level': 'Level_3_setUp_page',
//                 'account_balance': 0,
//                 'bill_payment': 0,
//                 'credit_card_balance': 0,
//                 'credit_card_bill': 0,
//                 'credit_score': 0,
//                 'level_id': 0,
//                 'payable_bill': 0,
//                 'quality_of_life': 0,
//                 'score': 0
//               });
//               Navigator.pushReplacement(
//                   context,
//                   PageTransition(
//                       child: LevelThreeSetUpPage(
//                         controller: PageController(),
//                       ),
//                       duration: Duration(milliseconds: 500),
//                       type: PageTransitionType.bottomToTop));
//             }
//             Navigator.pushReplacement(
//                 context,
//                 PageTransition(
//                     child: LevelThreeSetUpPage(
//                       controller: PageController(),
//                     ),
//                     duration: Duration(milliseconds: 500),
//                     type: PageTransitionType.bottomToTop));
//           },
//           child: Text('Level 3'),
//           style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(
//                 Color(0xff828FCE),
//               )),
//         ),
//       ));
// }
// _level4(int lev) {
//   return Padding(
//       padding: EdgeInsets.only(top: displayWidth(context) * .02),
//       child: Container(
//         width: displayWidth(context) * .40,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(displayWidth(context) * .12)),
//         child: ElevatedButton(
//           onPressed: () {},
//           child: Text('Level 4'),
//           style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(
//                 Color(0xff828FCE),
//               )),
//         ),
//       ));
// }
// _level5(int lev) {
//   return Padding(
//       padding: EdgeInsets.only(top: displayWidth(context) * .02),
//       child: Container(
//         width: displayWidth(context) * .40,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(displayWidth(context) * .12)),
//         child: ElevatedButton(
//           onPressed: () {},
//           child: Text('Level 5'),
//           style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(
//                 Color(0xff828FCE),
//               )),
//         ),
//       ));
// }
}

class LevelSummary extends StatelessWidget {
  final int need;
  final int want;
  final int bill;
  final int accountBalance;
  final int netWorth;
  final int mutualFund;
  final Color color;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;

  const LevelSummary(
      {Key? key,
      required this.need,
      required this.want,
      required this.bill,
      required this.accountBalance,
      required this.netWorth,
      required this.mutualFund,
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
          color: Color(0xff6A81F4)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (accountBalance + netWorth) >= 30000
                ? normalText(
                    "Congratulations you\'ve managed to save up \$30K! You now have enough savings to pay the down payment for a house or car. Go to the next level to make your first big purchase!")
                : normalText(
                    "Oops! Unfortunately you haven\'t managed to achieve your goal of \$30k."
                    "Purchasing a house or car needs you to pay an upfront booking amount. But don\'t lose hope. You can try again!"),
            richText('Salary Earned : ', '\$' + 60000.toString(), 2.h),
            richText('Total MF Investment : ', mutualFund.toString(), 1.h),
            (((netWorth - mutualFund) / mutualFund) * 100 ==
                null) ? richText(
                'Return on Investment : ', 0.toString(),
                1.h) : richText(
                'Return on Investment : ', '${(((netWorth - mutualFund) / mutualFund) * 100).floor()}' +
                        '%',
                1.h),
            // richText('Bills Paid : ',
            //     '${(((bill * 30) / 60000) * 100).floor()}' + '%', 1.h),
            // richText('Spend on Needs : ',
            //     '${((need / 60000) * 100).floor()}' + '%', 1.h),
            // richText('Spend on Wants : ',
            //     '${((want / 60000) * 100).floor()}' + '%', 1.h),
            richText('Money Saved : ',
                '${((accountBalance / 60000) * 100).floor()}' + '%', 1.h),
            (accountBalance + netWorth) >= 30000
                ? buttonStyle(color, 'Play Next Level', onPressed1)
                : buttonStyle(color, 'Try Again', onPressed2),
            SizedBox(
              height: 2.h,
            )
          ],
        ),
      ),
    );
  }
}

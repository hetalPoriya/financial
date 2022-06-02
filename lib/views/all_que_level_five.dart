import 'package:financial/shareable_screens/background_widget.dart';
import 'package:financial/shareable_screens/bill_payment_widget.dart';
import 'package:financial/shareable_screens/fund_allocation_screen.dart';
import 'package:financial/shareable_screens/game_question_container.dart';
import 'package:financial/shareable_screens/insight_widget.dart';
import 'package:financial/shareable_screens/mutual_fund_widget.dart';
import 'package:financial/controllers/level_five_controller.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/models/level_five_list.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/level_five_setUp_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/models/que_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

class AllQueLevelFive extends StatefulWidget {
  const AllQueLevelFive({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelFiveState createState() => _AllQueLevelFiveState();
}

class _AllQueLevelFiveState extends State<AllQueLevelFive> {
  int priceOfOption = 0;
  String option = '';
  int? bill;

  //get bill data
  int rentPrice = 0;
  int transportPrice = 0;
  int lifestylePrice = 0;
  int totalHomeLoan = 0;
  int totalTransportLoan = 0;
  int homeLoanFund = 0;
  int transportLoanFund = 0;
  int fund = 0;
  int investment = 0;

  //page controller
  PageController controllerForInner = PageController();
  int currentIndex = 0;
  int totalMutualFund = 0;
  int lastMonthIncDecValue = 0;
  int lastMonthIncDecPer = 0;
  Random rnd = Random();
  int? randomNumberTotalPositive;
  int count = 0;

  final _controller = Get.put<UserInfoController>(UserInfoController());

  //for model
  QueModel? queModel;
  List<QueModel> list = [];
  List<int> innerList = [0, 1, 2];

  getAllData() async {
    rentPrice = storeValue.read('rentPrice')!;
    transportPrice = storeValue.read('transportPrice')!;
    lifestylePrice = storeValue.read('lifestylePrice')!;
    count = storeValue.read('count');
    if (count == null) {
      count = 0;
    }

    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();

    totalMutualFund = snapshot.get('mutual_fund');
    totalHomeLoan = snapshot.get('home_loan');
    totalTransportLoan = snapshot.get('transport_loan');
    randomNumberTotalPositive = storeValue.read('randomNumberValue');
    controllerForInner = PageController(
        initialPage: storeValue.read('level4or5innerPageViewId'));

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Level_5").get();
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
    getLevelId().then((value) => getAllData());
    _displayFundAllocationBox();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(UserInfoController());
    final levelFiveCon = Get.put(LevelFiveController());
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
                  .collection('Level_5')
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
                                calculationForProgress(onPressed: () {
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
                        itemBuilder: (context, index) {
                          document = snapshot.data!.docs[index];
                          controllerForInner = PageController(
                              initialPage:
                                  storeValue.read('level4or5innerPageViewId'));
                          return document['card_type'] == 'GameQuestion'
                              ? StatefulBuilder(
                                  builder: (context, setStateWidget) {
                                  return PageView.builder(
                                    itemCount: innerList.length,
                                    scrollDirection: Axis.vertical,
                                    controller: controllerForInner,
                                    physics: NeverScrollableScrollPhysics(),
                                    onPageChanged: (value) async {
                                      DocumentSnapshot doc = await firestore
                                          .collection('User')
                                          .doc(userId)
                                          .get();
                                      totalHomeLoan = doc.get('home_loan');
                                      totalTransportLoan =
                                          doc.get('transport_loan');

                                      if (currentIndex == 1) {
                                        storeValue.write(
                                            'level4or5innerPageViewId', 1);
                                        totalMutualFund =
                                            doc.get('mutual_fund');
                                        investment = doc.get('investment');
                                        levelFiveCon.getEMITotal();
                                        levelFiveCon.getYourEmiData(document);
                                        // _displayFundAllocationBox();
                                        //levelFiveCon.getEMITotal();
                                      }
                                      if (currentIndex == 2) if (index != 0) {
                                        balance = doc.get('account_balance');
                                        storeValue.write(
                                            'level4or5innerPageViewId', 2);
                                        _displayFundAllocationBox();
                                        _showDialogOfMutualFund(setStateWidget);
                                      }
                                    },
                                    itemBuilder: (context, ind) {
                                      Color color = Colors.white;
                                      currentIndex = ind;
                                      if (currentIndex == 0) {
                                        storeValue.write(
                                            'level4or5innerPageViewId', 0);
                                        if (totalHomeLoan <= rentPrice) {
                                          rentPrice = totalHomeLoan;
                                          storeValue.write(
                                              'rentPrice', rentPrice);
                                        }
                                        if (totalTransportLoan <=
                                            transportPrice) {
                                          transportPrice = totalTransportLoan;
                                          storeValue.write(
                                              'transportPrice', transportPrice);
                                        }
                                        print(
                                            'CRedit Emi ${levelFiveCon.checkForEmiCredit}');
                                      }
                                      return BackgroundWidget(
                                        level: level,
                                        document: document,
                                        container: ind == 0
                                            ? StatefulBuilder(
                                                builder: (context, _setState) {
                                                  levelFiveCon
                                                      .getYourEmiData(document);
                                                  return GetBuilder<
                                                          LevelFiveController>(
                                                      builder: (levelFiveCon) {
                                                    return GameQuestionContainer(
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
                                                          .gameQuestionOption(
                                                              color: list[index]
                                                                          .isSelected1 ==
                                                                      true
                                                                  ? Colors.white
                                                                  : AllColors
                                                                      .yellow),
                                                      textStyle2: AllTextStyles
                                                          .gameQuestionOption(
                                                              color: list[index]
                                                                          .isSelected2 ==
                                                                      true
                                                                  ? Colors.white
                                                                  : AllColors
                                                                      .yellow),
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
                                                                _setState(() {
                                                                  list[index]
                                                                          .isSelected1 =
                                                                      true;
                                                                  balance =
                                                                      snap.get(
                                                                          'account_balance');
                                                                  option = document[
                                                                      'option_1'];
                                                                  priceOfOption =
                                                                      document[
                                                                          'option_1_price'];
                                                                });
                                                                _optionSelect(
                                                                    balance,
                                                                    _setState,
                                                                    priceOfOption,
                                                                    index,
                                                                    document);
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
                                                              print(levelFiveCon
                                                                  .totalEMIAmount);
                                                              print(levelFiveCon
                                                                  .checkForEmiCredit);
                                                              if (levelFiveCon
                                                                          .totalEMIAmount <=
                                                                      5000 &&
                                                                  levelFiveCon
                                                                          .checkForEmiCredit <
                                                                      0) {
                                                                return Get
                                                                    .defaultDialog(
                                                                  title: '',
                                                                  titlePadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  middleText:
                                                                      'You\'ve exceeded your eligible limit of 5000 EMIs. please pay full amount',
                                                                  barrierDismissible:
                                                                      false,
                                                                  onWillPop:
                                                                      () {
                                                                    return Future
                                                                        .value(
                                                                            false);
                                                                  },
                                                                  backgroundColor:
                                                                      AllColors
                                                                          .darkPurple,
                                                                  middleTextStyle:
                                                                      AllTextStyles
                                                                          .dialogStyleMedium(),
                                                                  confirm:
                                                                      restartOrOkButton(
                                                                          text:
                                                                              'Ok',
                                                                          onPressed:
                                                                              () {
                                                                            Get.back();
                                                                          }),
                                                                );
                                                              } else {
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
                                                                  _setState(() {
                                                                    list[index]
                                                                            .isSelected2 =
                                                                        true;
                                                                    balance =
                                                                        snap.get(
                                                                            'account_balance');
                                                                    option =
                                                                        document[
                                                                            'option_2'];
                                                                    priceOfOption =
                                                                        document[
                                                                            'option_2_price'];
                                                                  });

                                                                  _optionSelect(
                                                                    balance,
                                                                    _setState,
                                                                    priceOfOption,
                                                                    index,
                                                                    document,
                                                                  );
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      msg: AllStrings
                                                                          .optionAlreadySelected);
                                                                }
                                                              }
                                                            },
                                                    );
                                                  });
                                                },
                                              )
                                            : ind == 1
                                                ? StatefulBuilder(builder:
                                                    (context, _setState) {
                                                    levelFiveCon.getYourEmiData(
                                                        document);
                                                    return GetBuilder<
                                                            LevelFiveController>(
                                                        builder:
                                                            (levelFiveCon) {
                                                      print(
                                                          'Credit ${levelFiveCon.creditEmi.toString()}');
                                                      return BillPaymentWidget(
                                                        color: color,
                                                        billPayment: (rentPrice +
                                                                transportPrice +
                                                                lifestylePrice +
                                                                levelFiveCon
                                                                    .billAmountEmi)
                                                            .toString(),
                                                        forPlan1: rentPrice
                                                            .toString(),
                                                        forPlan2: transportPrice
                                                            .toString(),
                                                        forPlan3: lifestylePrice
                                                            .toString(),
                                                        forPlan4: levelFiveCon
                                                            .billAmountEmi
                                                            .toString(),
                                                        forPlan5: levelFiveCon
                                                            .creditEmi
                                                            .toString(),
                                                        text1: 'House EMI: ',
                                                        text2: 'Car EMI: ',
                                                        text3: 'Lifestyle: ',
                                                        text4: 'Other EMIs ',
                                                        text5:
                                                            'Available Credit Limit ',
                                                        onPressed:
                                                            color ==
                                                                    AllColors
                                                                        .green
                                                                ? () {}
                                                                : () async {
                                                                    DocumentSnapshot
                                                                        snap =
                                                                        await firestore
                                                                            .collection('User')
                                                                            .doc(userId)
                                                                            .get();
                                                                    _setState(
                                                                        () {
                                                                      color = AllColors
                                                                          .green;
                                                                      balance =
                                                                          snap.get(
                                                                              'account_balance');
                                                                      bill = rentPrice +
                                                                          transportPrice +
                                                                          lifestylePrice +
                                                                          levelFiveCon
                                                                              .billAmountEmi;
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
                                                                          .doc(
                                                                              userId)
                                                                          .update({
                                                                        'account_balance':
                                                                            balance,
                                                                        'game_score': gameScore +
                                                                            balance +
                                                                            qualityOfLife,
                                                                        'level_5_balance':
                                                                            balance,
                                                                        if (totalHomeLoan !=
                                                                            0)
                                                                          'home_loan':
                                                                              FieldValue.increment(-rentPrice),
                                                                        if (totalTransportLoan !=
                                                                            0)
                                                                          'transport_loan':
                                                                              FieldValue.increment(-transportPrice),
                                                                      }).then(
                                                                              (value) {
                                                                        _setState(
                                                                            () {
                                                                          if (totalHomeLoan !=
                                                                              0)
                                                                            totalHomeLoan =
                                                                                totalHomeLoan - rentPrice;
                                                                          if (totalTransportLoan !=
                                                                              0)
                                                                            totalTransportLoan =
                                                                                totalTransportLoan - transportPrice;
                                                                          if (totalHomeLoan ==
                                                                              0) {
                                                                            storeValue.write('rentPrice',
                                                                                0);
                                                                          }
                                                                          if (totalTransportLoan ==
                                                                              0) {
                                                                            storeValue.write('transportPrice',
                                                                                0);
                                                                          }
                                                                        });
                                                                        controllerForInner.nextPage(
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                            curve: Curves.easeIn);
                                                                        // storeValue.write('level4or5innerPageViewId', 1);
                                                                      }).then((value) =>
                                                                              levelFiveCon.decreaseMonthForEmi());
                                                                    } else {
                                                                      _showDialogForRestartLevel();
                                                                    }
                                                                  },
                                                      );
                                                    });
                                                  })
                                                : StatefulBuilder(builder:
                                                    (context, _setState) {
                                                    return FundAllocationScreen(
                                                      netWorth: investment,
                                                      totalMutualFund:
                                                          totalMutualFund,
                                                      lastMonthIncDecValue:
                                                          lastMonthIncDecValue,
                                                      color: color,
                                                      widget: Column(children: [
                                                        GetBuilder<
                                                            UserInfoController>(
                                                          builder:
                                                              (_controller) =>
                                                                  ListView
                                                                      .builder(
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Column(
                                                                // mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Text(
                                                                    _controller
                                                                            .fundName[
                                                                        index],
                                                                    style: AllTextStyles
                                                                        .dialogStyleLarge(
                                                                            size:
                                                                                16.sp),
                                                                  ),
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
                                                                            Icons.remove,
                                                                            color:
                                                                                AllColors.lightGrey,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              topLeft: Radius.circular(2.w),
                                                                              bottomLeft: Radius.circular(2.w),
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          if (_controller.fundAllocation[index] !=
                                                                              0) {
                                                                            //_setState(() {
                                                                            _controller.fundAllocation[index] =
                                                                                _controller.fundAllocation[index] - 100;
                                                                            firestore.collection('User').doc(userId).update({
                                                                              'account_balance': FieldValue.increment(100),
                                                                            });
                                                                            //  });
                                                                            if (_controller.fundName[index] ==
                                                                                'Home EMI') {
                                                                              //  _setState(() {
                                                                              homeLoanFund = homeLoanFund - 100;
                                                                              //  });
                                                                            }
                                                                            if (_controller.fundName[index] ==
                                                                                'Transport EMI') {
                                                                              //_setState(() {
                                                                              transportLoanFund = transportLoanFund - 100;
                                                                              //  });
                                                                            }
                                                                            _controller.update();
                                                                          }
                                                                        },
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            26.w,
                                                                        height:
                                                                            5.h,
                                                                        child:
                                                                            Text(
                                                                          _controller
                                                                              .fundAllocation[index]
                                                                              .toString(),
                                                                          style: AllTextStyles.workSansSmall(
                                                                              fontSize: 12.sp,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.center,
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
                                                                            Icons.add,
                                                                            color:
                                                                                AllColors.lightGrey,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              bottomRight: Radius.circular(2.w),
                                                                              topRight: Radius.circular(2.w),
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          firestore
                                                                              .collection('User')
                                                                              .doc(userId)
                                                                              .update({
                                                                            'account_balance':
                                                                                FieldValue.increment(-100),
                                                                          });
                                                                          if (_controller.fundName[index] ==
                                                                              'Home EMI') {
                                                                            if (homeLoanFund + 100 >
                                                                                totalHomeLoan) {
                                                                              Fluttertoast.showToast(msg: 'Your Home EMI is only $totalHomeLoan Left');
                                                                            } else {
                                                                              // _setState(() {
                                                                              _controller.fundAllocation[index] = _controller.fundAllocation[index] + 100;
                                                                              homeLoanFund = homeLoanFund + 100;
                                                                              // });
                                                                            }
                                                                          } else if (_controller.fundName[index] ==
                                                                              'Transport EMI') {
                                                                            if (transportLoanFund + 100 >
                                                                                totalTransportLoan) {
                                                                              Fluttertoast.showToast(msg: 'Your Transport EMI is only $totalTransportLoan Left');
                                                                            } else {
                                                                              //_setState(() {
                                                                              _controller.fundAllocation[index] = _controller.fundAllocation[index] + 100;
                                                                              transportLoanFund = transportLoanFund + 100;
                                                                              // });
                                                                            }
                                                                          } else {
                                                                            //_setState(() {
                                                                            _controller.fundAllocation[index] =
                                                                                _controller.fundAllocation[index] + 100;
                                                                            // });
                                                                          }
                                                                          _controller
                                                                              .update();
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
                                                                _controller
                                                                    .fundName
                                                                    .length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                          ),
                                                        ),
                                                        if (totalHomeLoan == 0)
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 2.h,
                                                              ),
                                                              Container(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child:
                                                                      FittedBox(
                                                                    child: Text(
                                                                      'Home Loan Fully Paid',
                                                                      style: AllTextStyles
                                                                          .dialogStyleSmall(),
                                                                    ),
                                                                  ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty
                                                                            .all(
                                                                      AllColors
                                                                          .lightGrey2,
                                                                    ),
                                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(2.w))),
                                                                  ),
                                                                ),
                                                                height: 5.h,
                                                                width: 50.w,
                                                              ),
                                                            ],
                                                          ),
                                                        if (totalTransportLoan ==
                                                            0)
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 2.h,
                                                              ),
                                                              Container(
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child:
                                                                      FittedBox(
                                                                    child: Text(
                                                                        'Transport Loan Fully Paid',
                                                                        style: AllTextStyles
                                                                            .dialogStyleSmall()),
                                                                  ),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty
                                                                            .all(
                                                                      AllColors
                                                                          .lightGrey2,
                                                                    ),
                                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(2.w))),
                                                                  ),
                                                                ),
                                                                height: 5.h,
                                                                width: 50.w,
                                                              ),
                                                            ],
                                                          ),
                                                      ]),
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
                                                                    _controller
                                                                        .fundAllocation
                                                                        .forEach(
                                                                            (item) {
                                                                      fund +=
                                                                          item;
                                                                    });
                                                                    //fund = fundAllocation[0] + fundAllocation[1];
                                                                    //balance = balance - fund;
                                                                    //totalFundAmount = homeLoanValue + transportLoanValue + lifestyleLoanValue;
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
                                                                      'level_id':
                                                                          index +
                                                                              1,
                                                                      'level_5_id':
                                                                          index +
                                                                              1,
                                                                      'mutual_fund':
                                                                          FieldValue.increment(
                                                                              _controller.fundAllocation[0]),
                                                                      'level_5_investment':   FieldValue.increment(
                                                                          _controller.fundAllocation[0]),
                                                                      'investment':
                                                                          FieldValue.increment(
                                                                              _controller.fundAllocation[0]),
                                                                      if (totalHomeLoan !=
                                                                          0)
                                                                        'home_loan':
                                                                            FieldValue.increment(-homeLoanFund),
                                                                      if (totalTransportLoan !=
                                                                          0)
                                                                        'transport_loan':
                                                                            FieldValue.increment(-transportLoanFund),
                                                                      // if (home == 'EMI' && homeLoan != 0) 'home_loan': FieldValue.increment(-homeLoanValue),
                                                                      // if (transport == 'Other' && transportLoan != 0) 'transport_loan': FieldValue.increment(-transportLoanValue),
                                                                    }).then((value) {
                                                                      balance =
                                                                          balance +
                                                                              2000;
                                                                      if (totalHomeLoan !=
                                                                          0)
                                                                        _setState(
                                                                            () {
                                                                          totalHomeLoan =
                                                                              totalHomeLoan - homeLoanFund;
                                                                        });
                                                                      if (totalTransportLoan !=
                                                                          0)
                                                                        _setState(
                                                                            () {
                                                                          totalTransportLoan =
                                                                              totalTransportLoan - transportLoanFund;
                                                                        });
                                                                      firestore
                                                                          .collection(
                                                                              'User')
                                                                          .doc(
                                                                              userId)
                                                                          .update({
                                                                        'account_balance':
                                                                            FieldValue.increment(2000),
                                                                        'level_5_balance':
                                                                        balance,
                                                                        'game_score': gameScore +
                                                                            balance +
                                                                            qualityOfLife,
                                                                      });
                                                                      _setState(
                                                                          () {
                                                                        fund =
                                                                            0;
                                                                        homeLoanFund =
                                                                            0;
                                                                        transportLoanFund =
                                                                            0;
                                                                        int value =
                                                                            storeValue.read('level4or5innerPageViewId');
                                                                        if (index == snapshot.data!.docs.length - 1 &&
                                                                            value ==
                                                                                2) {
                                                                          firestore.collection('User').doc(userId).update({
                                                                            'level_id':
                                                                                index + 1,
                                                                            'level_5_id':
                                                                                index + 1,
                                                                          }).then((value) => Future.delayed(
                                                                              Duration(seconds: 1),
                                                                              () => calculationForProgress(onPressed: () {
                                                                                    Get.back();
                                                                                    _levelCompleteSummary(context, gameScore, balance, qualityOfLife);
                                                                                  })));
                                                                        } else {
                                                                          controller.nextPage(
                                                                              duration: Duration(seconds: 1),
                                                                              curve: Curves.easeIn);
                                                                          storeValue.write(
                                                                              'level4or5innerPageViewId',
                                                                              0);
                                                                        }
                                                                      });
                                                                    });
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
                                        'level_5_id': index + 1,
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
      onPressed: () {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_5_setUp_page',
          'level_id': 0,
          'level_5_balance': 0,
          'level_5_qol': 0,
          'level_5_investment': 0,
          'List': FieldValue.delete(),
        }).then((value) => Get.off(
              () => LevelFiveSetUpPage(),
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
          ? rnd.nextInt(15 + 5) - 15
          : rnd.nextInt(16);
      print('number ${number}');
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
                      netWorth: investment,
                      lastMonthIncDecPer: lastMonthIncDecPer,
                      lastMonthIncDecValue: lastMonthIncDecValue,
                      number: number,
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

  _optionSelect(int balance, StateSetter setState1, int priceOfOption,
      int index, document) async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    setState1(() {
      balance = snap.get('account_balance');
      qualityOfLife = snap.get('quality_of_life');
    });
    if (balance >= priceOfOption) {
      setState1(() {
        balance = balance - priceOfOption;
      });

      if (list[index].isSelected2 == true && document['total_month'] != 0) {
        var list = LevelFiveList(
            queId: document['id'],
            month: document['total_month'],
            emiAmount: document['emi_amount']);
        firestore.collection('User').doc(userId).update({
          'List': FieldValue.arrayUnion([list.toMap()]),
          //  'List': FieldValue.arrayUnion(list.toMap()]),
        }).then((value) {
          firestore.collection('User').doc(userId).update({
            'total_emi_level_5': FieldValue.increment(
                document['total_month'] * document['emi_amount'])
          });
        });
      }

      firestore.collection('User').doc(userId).update({
        'level_id': index + 1,
        'level_5_id': index + 1,
        'quality_of_life': FieldValue.increment(qualityOfLife),
        'game_score': gameScore + balance + qualityOfLife,
        'level_5_balance': FieldValue.increment(-priceOfOption),
        'level_5_qol': FieldValue.increment(qualityOfLife),
        'account_balance': FieldValue.increment(-priceOfOption),
      }).then((value) {
        controllerForInner.nextPage(
            duration: Duration(seconds: 1), curve: Curves.easeIn);
        // storeValue.write('level4or5innerPageViewId', 0);
        // balance = snap.get('account_balance');
        // if (document['month'] != 0)
        //   Future.delayed(
        //       Duration(milliseconds: 500), () => _billPayment(balance, index));
      });
    } else {
      _showDialogForRestartLevel();
    }
  }

  _displayFundAllocationBox() async {
    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    totalHomeLoan = snapshot.get('home_loan');
    totalTransportLoan = snapshot.get('transport_loan');
    if (totalHomeLoan == 0 && totalTransportLoan == 0) {
      //  setStateWidget((){
      _controller.fundName = ['Mutual Fund'];
      _controller.fundAllocation = [0];
      // });
    }

    if (totalHomeLoan == 0 && totalTransportLoan != 0) {
      // setStateWidget!((){
      _controller.fundName = ['Mutual Fund', 'Transport EMI'];
      _controller.fundAllocation = [0, 0];
      // });

    }

    if (totalHomeLoan != 0 && totalTransportLoan == 0) {
      // setStateWidget((){
      _controller.fundName = ['Mutual Fund', 'Home EMI'];
      _controller.fundAllocation = [0, 0];
      //  });

    }

    if (totalHomeLoan != 0 && totalTransportLoan != 0) {
      //setStateWidget!((){
      _controller.fundName = ['Mutual Fund', 'Home EMI', 'Transport EMI'];
      _controller.fundAllocation = [0, 0, 0];
      // });
    }
    _controller.update();
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
                            onPressed1: color == AllColors.green
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
                                      'level_5_balance': accountBalance,
                                      'level_5_qol': qol,
                                      'level_5_investment': mutualFund
                                      //if(value != true) 'last_level':'Coming_soon',
                                    }).then(
                                      (value) => Fluttertoast.showToast(
                                          msg: 'ComingSoon'),
                                      //     Future.delayed(
                                      // Duration(milliseconds: 500),
                                      //     () => _playLevelOrPopQuiz()),

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
                                      //           Color(AllColors.darkPurple),
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
                                      //                           AllColors.darkPurple),
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
                                color = AllColors.green;
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
          color: AllColors.lightBlue),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (accountBalance + netWorth) >= 30000
                ? normalText(text: AllStrings.level5SummaryTitleWhenComplete)
                : normalText(text: AllStrings.level5SummaryTitleWhenLose),
            richText(
                text1: AllStrings.salaryEarned,
                text2: AllStrings.countrySymbol + 60000.toString(),
                paddingTop: 2.h),
            richText(
                text1: AllStrings.totalMfInvestment,
                text2: mutualFund.toString(),
                paddingTop: 1.h),
            (((netWorth - mutualFund) / mutualFund) * 100 == null)
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
                    onPressed: onPressed1)
                : buttonStyle(
                    color: color,
                    text: AllStrings.tryAgain,
                    onPressed: onPressed2),
            SizedBox(
              height: 2.h,
            )
          ],
        ),
      ),
    );
  }
}

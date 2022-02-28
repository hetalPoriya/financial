

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:financial/controllers/LevelFourOptionsController.dart';
import 'package:financial/views/AllQueLevelFive.dart';
import 'package:financial/views/AllQueLevelFour.dart';
import 'package:financial/views/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class LevelFourAndFiveOptions extends StatefulWidget {
  LevelFourAndFiveOptions({Key? key}) : super(key: key);

  @override
  _LevelFourAndFiveOptionsState createState() =>
      _LevelFourAndFiveOptionsState();
}

class _LevelFourAndFiveOptionsState extends State<LevelFourAndFiveOptions>
    with SingleTickerProviderStateMixin {
  //animation controller and for selected option
  late AnimationController _animationController;

  var userId;
  String level = '';
  final storeValue = GetStorage();

  getUid() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // userId = pref.getString('uId');
    userId = storeValue.read('uId');
    DocumentSnapshot doc = await firestore.collection('User').doc(userId).get();
    setState(() {
      level = doc.get('previous_session_info');
    });
  }

  //slider value
  double _rent = 5;
  double _transport = 3;
  double _lifestyle = 3;

  final _controller = LevelFourOptionsController();

  @override
  void initState() {
    getUid();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Timer(Duration(milliseconds: 500), () => _animationController.forward());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
            ),
            child: Container(
                width: 100.w,
                height: 100.h,
                decoration: boxDecoration,
                child: PageView.builder(
                    itemCount: _controller.bills.length,
                    controller: _controller.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index1) {
                      return PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              _controller.bills[index1].optionsValue!.length,
                          itemBuilder: (context, index) {
                            index = _controller.bills[index1].isSelectedOption;
                            return StatefulBuilder(
                              builder: (context, _setState1) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 6.h,
                                            width: 40.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.w),
                                              color: Color(0xffEF645B),
                                            ),
                                            child: Center(
                                                child: _text(
                                              '${_controller.bills[index1].step}',
                                              Colors.white,
                                              FontWeight.w500,
                                              18.sp,
                                            )),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 13.w, right: 7.w),
                                          child: GestureDetector(
                                            onTap: () async {
                                              Get.off(
                                                () => ProfilePage(),
                                                duration:
                                                    Duration(milliseconds: 500),
                                                transition: Transition.downToUp,
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/settings.png',
                                              width: 8.w,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 12.w, left: 12.w),
                                        child: _text(
                                          '${_controller.bills[index1].text}',
                                          Colors.white,
                                          FontWeight.w600,
                                          18.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Container(
                                      width: 80.w,
                                      height: 64.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          6.w,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 1.h),
                                            child: Container(
                                              width: 55.w,
                                              //color: Colors.red,
                                              child: Image.asset(
                                                '${_controller.bills[index1].optionsValue![index].image}',
                                               // width: 55.w,
                                                height: 16.h,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                              activeTrackColor:
                                                  Color(0xffE6E2F6),
                                              inactiveTrackColor:
                                                  Color(0xffE6E2F6),
                                              trackShape:
                                                  RoundedRectSliderTrackShape(),
                                              trackHeight: 2.w,
                                              thumbColor: Color(0xff563DC1),
                                              overlayColor: Color(0xffE6E2F6),
                                              tickMarkShape:
                                                  RoundSliderTickMarkShape(),
                                              activeTickMarkColor: Colors.white,
                                              inactiveTickMarkColor:
                                                  Colors.white,
                                              valueIndicatorColor:
                                                  Color(0xff563DC1),
                                              valueIndicatorTextStyle:
                                                  TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: Slider(
                                              value: index1 == 0
                                                  ? _rent
                                                  : index1 == 1
                                                      ? _transport
                                                      : index1 == 2
                                                          ? _lifestyle
                                                          : _rent,
                                              min: 0,
                                              max: index1 == 0
                                                  ? 100
                                                  : index1 == 1
                                                      ? 50
                                                      : index1 == 2
                                                          ? 50
                                                          : 100,
                                              divisions: index1 == 0
                                                  ? 4
                                                  : index1 == 1
                                                      ? 2
                                                      : index1 == 2
                                                          ? 2
                                                          : 4,
                                              onChanged: (value) {
                                                _setState1(
                                                  () {
                                                    _controller.bills[index1]
                                                            .isSelectedButton =
                                                        false;
                                                    if (index1 == 0) {
                                                      _rent = value;
                                                    }
                                                    if (index1 == 1) {
                                                      _transport = value;
                                                      _rent = _transport;
                                                    } else {
                                                      _lifestyle = value;
                                                      _rent = _lifestyle;
                                                    }
                                                    if (value == 0.0) index = 0;
                                                    if (value == 25.0)
                                                      index = 1;
                                                    if (value == 50.0)
                                                      index = 2;
                                                    if (index1 == 2 &&
                                                        value == 75.0)
                                                      index = 3;
                                                    if (index1 == 0 &&
                                                        value == 100.0)
                                                      index = 4;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 1.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                _text(
                                                    '${_controller.bills[index1].options1}',
                                                    Color(0xff563DC1),
                                                    FontWeight.w700,
                                                    10.sp),
                                                _text(
                                                    '${_controller.bills[index1].options2}',
                                                    Color(0xff563DC1),
                                                    FontWeight.w700,
                                                    10.sp),
                                                _text(
                                                    '${_controller.bills[index1].options3}',
                                                    Color(0xff563DC1),
                                                    FontWeight.w700,
                                                    10.sp),
                                                if (index1 == 0)
                                                  _text(
                                                      '${_controller.bills[index1].options4}',
                                                      Color(0xff563DC1),
                                                      FontWeight.w700,
                                                      10.sp),
                                                if (index1 == 0)
                                                  _text(
                                                      '${_controller.bills[index1].options5}',
                                                      Color(0xff563DC1),
                                                      FontWeight.w700,
                                                      10.sp),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(1.w),
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3.w),
                                                color: Color(0xffF6F7FE),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 1.h),
                                                  child: _text(
                                                      '${_controller.bills[index1].optionsValue![index].description}',
                                                      Color(0xff3D3D3D),
                                                      FontWeight.w400,
                                                      10.sp),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              // SharedPreferences pref =
                                              // await SharedPreferences
                                              //     .getInstance();
                                              _setState1(() {
                                                _controller.bills[index1]
                                                    .isSelectedOption = index;
                                                _controller.bills[index1]
                                                    .isSelectedButton = true;
                                                // if (index1 == 0) {
                                                //   rentPrice = _controller.bills[index1]
                                                //       .optionsValue![index]
                                                //       .rent!;
                                                //   // pref.setString('Home', 'EMI');
                                                //   // String? home =
                                                //   // pref.getString('Home');
                                                //
                                                //   // firestore
                                                //   //     .collection('User')
                                                //   //     .doc(userId)
                                                //   //     .update({
                                                //   //   'home_loan': rentPrice * 60,
                                                //   // });
                                                //   storeValue.write(
                                                //       'rentPrice', rentPrice);
                                                // }
                                                if (index1 == 0) {
                                                  rentPrice = _controller
                                                      .bills[index1]
                                                      .optionsValue![index]
                                                      .rent!;
                                                  storeValue.write(
                                                      'rentPrice', rentPrice);
                                                }
                                                if (index1 == 1) {
                                                  transportPrice = _controller
                                                      .bills[index1]
                                                      .optionsValue![index]
                                                      .rent!;
                                                  storeValue.write(
                                                      'transportPrice',
                                                      transportPrice);
                                                }
                                                if (index1 == 2) {
                                                  lifestylePrice = _controller
                                                      .bills[index1]
                                                      .optionsValue![index]
                                                      .rent!;
                                                  storeValue.write(
                                                      'lifestylePrice',
                                                      lifestylePrice);
                                                }
                                              });
                                            },
                                            child: Container(
                                                height: 6.h,
                                                width: 55.w,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: _controller
                                                                  .bills[index1]
                                                                  .isSelectedButton ==
                                                              true
                                                          ? [
                                                              Color(0xff0DA867),
                                                              Color(0xff2DDA91),
                                                              Color(0xff2DDA91),
                                                              Color(0xff0DA867)
                                                            ]
                                                          : [
                                                              Color(0xff7655E8),
                                                              Color(0xff8C46ED),
                                                              Color(0xff8C46ED),
                                                              Color(0xff7655E8)
                                                            ],
                                                      // begin: Alignment.bottomLeft,
                                                      // end: Alignment.topRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.w)),
                                                child: Center(
                                                  child: _text(
                                                    level ==
                                                            'Level_4_setUp_page'
                                                        ? ' \$ ${_controller.bills[index1].optionsValue![index].rent}/month'
                                                        : 'EMI \$ ${_controller.bills[index1].optionsValue![index].rent}/month',
                                                    Colors.white,
                                                    FontWeight.w400,
                                                    14.sp,
                                                  ),
                                                )),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                            ),
                                            child: _text(
                                              _controller
                                                  .bills[index1]
                                                  .optionsValue![index]
                                                  .bottomText
                                                  .toString(),
                                              Color(0xffcccccc),
                                              FontWeight.w300,
                                              08.sp,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: index1 == 0
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (index1 == 1 || index1 == 2)
                                          Padding(
                                            padding: EdgeInsets.only(left: 1.w),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  _controller.pageController
                                                      .previousPage(
                                                          duration: Duration(
                                                              seconds: 1),
                                                          curve: Curves.easeIn);
                                                },
                                                child: Container(
                                                  width: 35.w,
                                                  height: 7.h,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                28.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                28.0),
                                                      )),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            child: Icon(
                                                          Icons
                                                              .arrow_back_ios_outlined,
                                                          size: 18.0,
                                                          color:
                                                              Color(0xff6D00C2),
                                                        )),
                                                        SizedBox(
                                                          width: 3.w,
                                                        ),
                                                        GradientText(
                                                            text: 'Prev',
                                                            style: GoogleFonts
                                                                .workSans(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                            gradient: const LinearGradient(
                                                                colors: [
                                                                  Colors.white,
                                                                  Color(
                                                                      0xff6D00C2)
                                                                ],
                                                                transform:
                                                                    GradientRotation(
                                                                        math.pi /
                                                                            2))),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 1.w),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: _controller.bills[index1]
                                                          .isSelectedButton ==
                                                      true
                                                  ? () async {
                                                      _lifestyle = 3;
                                                      if (index1 ==
                                                          _controller.bills
                                                                  .length -
                                                              1) {
                                                        storeValue.write(
                                                            'count', 0);
                                                        storeValue.write(
                                                            'level4or5innerPageViewId',
                                                            0);
                                                        storeValue.write(
                                                            'randomNumberValue',
                                                            0);
                                                        storeValue.write(
                                                            'count', 0);
                                                        storeValue.write('update', 0);
                                                        storeValue.write('tBalance', 0);
                                                        storeValue.write('tQol', 0);
                                                        storeValue.write('tInvestment', 0);
                                                        storeValue.write('tCredit', 0);
                                                        storeValue.write('tUser', 0);
                                                        //storeValue.write('mutualFundProfit',0);
                                                        if (level ==
                                                            'Level_4_setUp_page') {
                                                          level4TotalPrice =
                                                              rentPrice +
                                                                  transportPrice +
                                                                  lifestylePrice;
                                                          storeValue.write(
                                                              'level4TotalPrice',
                                                              level4TotalPrice);

                                                          bool? replayLevel;
                                                          firestore
                                                              .collection(
                                                                  'User')
                                                              .doc(userId)
                                                              .get()
                                                              .then((doc) => {
                                                                    replayLevel =
                                                                        doc.get(
                                                                            'replay_level'),
                                                                  });
                                                          firestore
                                                              .collection(
                                                                  'User')
                                                              .doc(userId)
                                                              .update({
                                                            if (replayLevel !=
                                                                true)
                                                              'last_level':
                                                                  'Level_4',
                                                            'previous_session_info':
                                                                'Level_4',
                                                            'account_balance':
                                                                2000,
                                                            'bill_payment':
                                                                level4TotalPrice,
                                                            'credit_card_balance':
                                                                0,
                                                            'credit_card_bill':
                                                                0,
                                                            'credit_score': 0,
                                                            'level_id': 0,
                                                            'payable_bill': 0,
                                                            'quality_of_life':
                                                                0,
                                                            'score': 0,
                                                            'need': 0,
                                                            'want': 0,
                                                            'mutual_fund': 0,
                                                            'home_loan': 0,
                                                            'transport_loan': 0,
                                                            'investment': 0
                                                          }).then((value) {
                                                            getUser(4).then((value){Get.off(
                                                                  () =>
                                                                  AllQueLevelFour(),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                  500),
                                                              transition:
                                                              Transition
                                                                  .downToUp,
                                                            );});
                                                          });
                                                        }
                                                        if (level ==
                                                            'Level_5_setUp_page') {
                                                          level4TotalPrice =
                                                              rentPrice +
                                                                  transportPrice +
                                                                  lifestylePrice;
                                                          storeValue.write(
                                                              'level4TotalPrice',
                                                              level4TotalPrice);
                                                          rentPrice =
                                                              rentPrice * 30;
                                                          transportPrice =
                                                              transportPrice *
                                                                  30;
                                                          bool? replayLevel;
                                                          firestore
                                                              .collection(
                                                                  'User')
                                                              .doc(userId)
                                                              .get()
                                                              .then((doc) => {
                                                                    replayLevel =
                                                                        doc.get(
                                                                            'replay_level'),
                                                                  });
                                                          firestore
                                                              .collection(
                                                                  'User')
                                                              .doc(userId)
                                                              .update({
                                                            if (replayLevel !=
                                                                true)
                                                              'last_level':
                                                                  'Level_5',
                                                            'previous_session_info':
                                                                'Level_5',
                                                            'account_balance':
                                                                2000,
                                                            'bill_payment':
                                                                level4TotalPrice,
                                                            'credit_card_balance':
                                                                0,
                                                            'credit_card_bill':
                                                                0,
                                                            'credit_score': 0,
                                                            'level_id': 0,
                                                            'payable_bill': 0,
                                                            'quality_of_life':
                                                                0,
                                                            'score': 0,
                                                            'need': 0,
                                                            'want': 0,
                                                            'mutual_fund': 0,
                                                            'home_loan':
                                                                rentPrice,
                                                            'transport_loan':
                                                                transportPrice,
                                                            'investment': 0
                                                          }).then((value) {
                                                            getUser(4).then((value){Get.off(
                                                                  () =>
                                                                  AllQueLevelFive(),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                  500),
                                                              transition:
                                                              Transition
                                                                  .downToUp,
                                                            );});
                                                          });
                                                        }
                                                      } else {
                                                        _controller
                                                            .pageController
                                                            .nextPage(
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .easeIn);
                                                      }
                                                    }
                                                  : () {},
                                              child: Container(
                                                width: 35.w,
                                                height: 7.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(28.0),
                                                      bottomLeft:
                                                          Radius.circular(28.0),
                                                    )),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GradientText(
                                                          text: 'Next',
                                                          style: GoogleFonts
                                                              .workSans(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white),
                                                          gradient: const LinearGradient(
                                                              colors: [
                                                                Colors.white,
                                                                Color(
                                                                    0xff6D00C2)
                                                              ],
                                                              transform:
                                                                  GradientRotation(
                                                                      math.pi /
                                                                          2))),
                                                      SizedBox(
                                                        width: 3.w,
                                                      ),
                                                      Container(
                                                          child: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                        size: 18.0,
                                                        color:
                                                            Color(0xff6D00C2),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //   SlideTransition(
                                              //     position: Tween<Offset>(
                                              //             begin: Offset(1, 0), end: Offset.zero)
                                              //         .animate(_animationController),
                                              //     child: FadeTransition(
                                              //       opacity: _animationController,
                                              //       child: Container(
                                              //         width: displayWidth(context) * .35,
                                              //         height: displayHeight(context) * .07,
                                              //         decoration: BoxDecoration(
                                              //             color: Colors.white,
                                              //             borderRadius: BorderRadius.only(
                                              //               topLeft: Radius.circular(28.0),
                                              //               bottomLeft: Radius.circular(28.0),
                                              //             )),
                                              //         child: Padding(
                                              //           padding: EdgeInsets.only(
                                              //               left: displayWidth(context) * .04),
                                              //           child: Row(
                                              //             mainAxisAlignment: MainAxisAlignment.center,
                                              //             children: [
                                              //               GradientText(
                                              //                   text: 'Next',
                                              //                   style: GoogleFonts.workSans(
                                              //                       fontSize: 16.sp,
                                              //                       fontWeight: FontWeight.w500,
                                              //                       color: Colors.white),
                                              //                   gradient: const LinearGradient(
                                              //                       colors: [
                                              //                         Colors.white,
                                              //                         Color(0xff6D00C2)
                                              //                       ],
                                              //                       transform:
                                              //                           GradientRotation(math.pi / 2))),
                                              //               SizedBox(
                                              //                 width: displayWidth(context) * .03,
                                              //               ),
                                              //               Container(
                                              //                   child: Icon(
                                              //                 Icons.arrow_forward_ios_outlined,
                                              //                 size: 18.0,
                                              //                 color: Color(0xff6D00C2),
                                              //               )),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    )
                                  ],
                                );
                              },
                            );
                          });
                    }))),
      ),
    );
  }
}

_text(String text, Color color, FontWeight fontWeight, double size) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
        color: color, fontWeight: fontWeight, fontSize: size),
  );
}

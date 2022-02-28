
import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:financial/views/AllDoneScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class LevelTwoAndThreeOptions extends StatefulWidget {
  LevelTwoAndThreeOptions({Key? key}) : super(key: key);

  @override
  _LevelTwoAndThreeOptionsState createState() =>
      _LevelTwoAndThreeOptionsState();
}

class _LevelTwoAndThreeOptionsState extends State<LevelTwoAndThreeOptions>
    with SingleTickerProviderStateMixin {
//animation controller and for selected option
  late AnimationController _animationController;
  int myIndex = 0;
  final plans = GetStorage();
  //controller
  PageController _controller = PageController();
  List<LevelTwoAndThreeSlider> billsOfLevelTwoAndThree = [
    LevelTwoAndThreeSlider(
        text: 'WHERE WILL YOU LIVE?',
        step: 'Step 1',
        selectedOption: 0,
        sliderData: [
          SliderDataForLevelTwoAndThree(
              text: 'LOW COST APARTMENT WITH ROOMMATES',
              rent: 200,
              image: 'assets/level_1_first_image.png'),
          SliderDataForLevelTwoAndThree(
              text: 'SHARED APARTMENT WITH INDIVIDUAL ROOM',
              rent: 300,
              image: 'assets/level_1_second_image.png'),
          SliderDataForLevelTwoAndThree(
              text: 'LIVE SOLO IN YOUR OWN APARTMENT',
              rent: 400,
              image: 'assets/level_1_third_image.png'),
        ]),
    LevelTwoAndThreeSlider(
        text: 'TV AND BROADBAND PLAN',
        step: 'Step 2',
        selectedOption: 0,
        sliderData: [
          SliderDataForLevelTwoAndThree(
              text: 'NO TV. 1 MBPS UNLIMITED INTERNET',
              rent: 50,
              image: 'assets/level_2_first_image.png'),
          SliderDataForLevelTwoAndThree(
              text: 'CABLE TV. 25 MBPS UNLIMITED INTERNET',
              rent: 80,
              image: 'assets/level_2_second_image.png'),
          SliderDataForLevelTwoAndThree(
              text: 'TV & OTT SUBSCRIPTION. 100 MBPS UNLIMITED INTERNET',
              rent: 120,
              image: 'assets/level_2_third_image.png'),
        ]),
    LevelTwoAndThreeSlider(
        selectedOption: 0,
        text: 'GROCERY PLAN',
        step: 'Step 3',
        sliderData: [
          SliderDataForLevelTwoAndThree(
              text: 'CHEAP GROCERIES AND COOK AT HOME',
              rent: 100,
              image: 'assets/level_3_first_image.png'),
          SliderDataForLevelTwoAndThree(
              text: 'ORGANIC GROCERIES AND EAT OUT WEEKLY',
              rent: 150,
              image: 'assets/level_3_second_image.png'),
          SliderDataForLevelTwoAndThree(
              text: 'PREMIUM GROCERIES AND EAT OUT OFTEN',
              rent: 200,
              image: 'assets/level_3_third_image.png'),
        ]),
    LevelTwoAndThreeSlider(
        selectedOption: 0,
        text: 'CELLPHONE PLAN',
        step: 'Step 4',
        sliderData: [
          SliderDataForLevelTwoAndThree(
              text: '1MB DATA, 100 CALL MINUTES AND TEXTS',
              rent: 50,
              image: 'assets/level_4_first_image.png'),
          SliderDataForLevelTwoAndThree(
              text: '5 GB DATA, UNLIMITED TEXT AND CALL',
              rent: 80,
              image: 'assets/level_4_second_image.png'),
          SliderDataForLevelTwoAndThree(
              text: 'UNLIMITED DATA, TEXTING AND CALLING',
              rent: 120,
              image: 'assets/level_4_third_image.png'),
        ])
  ];

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    Timer(Duration(milliseconds: 600), () => _animationController.forward());
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
                    itemCount: billsOfLevelTwoAndThree.length,
                    controller: _controller,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index1) {
                      return Column(
                        children: [
                          Spacer(),
                          Center(
                            child: Container(
                              height: 7.h,
                              width: 62.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.w),
                                color: Color(0xffEF645B),
                              ),
                              child: Center(
                                  child: Text(
                                '${billsOfLevelTwoAndThree[index1].step}',
                                style: GoogleFonts.workSans(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(right: 2.w, left: 2.w),
                              child: Text(
                                '${billsOfLevelTwoAndThree[index1].text}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.workSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: billsOfLevelTwoAndThree[index1]
                                  .sliderData
                                  ?.length,
                              itemBuilder: (context, index) {
                                return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(-1, 0),
                                      //  begin: Offset(2.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(_animationController),
                                    child: FadeTransition(
                                      opacity: _animationController,
                                      child: Column(
                                        children: [
                                          StatefulBuilder(
                                              builder: (context, _setState) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  myIndex = index;
                                                  billsOfLevelTwoAndThree[
                                                              index1]
                                                          .selectedOption =
                                                      index + 1;
                                                });
                                              },
                                              child: Card(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: billsOfLevelTwoAndThree[
                                                                        index1]
                                                                    .selectedOption ==
                                                                index + 1
                                                            ? [
                                                                Color(
                                                                    0xff2DDA91),
                                                                Color(
                                                                    0xff0DA867)
                                                              ]
                                                            : [
                                                                Colors.white,
                                                                Colors.white
                                                              ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width: 85.w,
                                                  height: 16.h,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 30.w,
                                                        child: Container(
                                                          child: Image.asset(
                                                            '${billsOfLevelTwoAndThree[index1].sliderData![index].image}',
                                                            width: 15.w,
                                                            height: 10.h,
                                                            fit: BoxFit.contain,
                                                            color: billsOfLevelTwoAndThree[
                                                                            index1]
                                                                        .selectedOption ==
                                                                    index + 1
                                                                ? Colors.white
                                                                : null,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 55.w,
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Spacer(),
                                                                Spacer(),
                                                                Text(
                                                                  '${billsOfLevelTwoAndThree[index1].sliderData![index].text}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GoogleFonts.workSans(
                                                                      color: billsOfLevelTwoAndThree[index1].selectedOption ==
                                                                              index +
                                                                                  1
                                                                          ? Colors
                                                                              .white
                                                                          : Color(
                                                                              0xff3D3D3D),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          11.sp),
                                                                ),
                                                                Spacer(),
                                                                RichText(
                                                                    text: TextSpan(
                                                                        text:
                                                                            '${'\$${billsOfLevelTwoAndThree[index1].sliderData![index].rent}\/'}',
                                                                        style: GoogleFonts.workSans(
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            color: billsOfLevelTwoAndThree[index1].selectedOption == index + 1
                                                                                ? Colors.white
                                                                                : Color(0xff4D5DDD),
                                                                            fontSize: 13.sp),
                                                                        children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'month',
                                                                        style: GoogleFonts.workSans(
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            color: billsOfLevelTwoAndThree[index1].selectedOption == index + 1
                                                                                ? Colors.white
                                                                                : Color(0xff4D5DDD),
                                                                            fontSize: 12.sp),
                                                                      )
                                                                    ])),
                                                                Spacer(),
                                                                Spacer(),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                elevation: 6.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            );
                                          }),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                        ],
                                      ),
                                    ));
                              }),
                          Text(
                            'Please choose one option',
                            style: GoogleFonts.workSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: index1 == 0
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                if (index1 != 0)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        _controller.previousPage(
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeIn);
                                      },
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(-1, 0),
                                          end: Offset.zero,
                                        ).animate(_animationController),
                                        child: FadeTransition(
                                          opacity: _animationController,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 1.w, left: 1.w),
                                            child: Container(
                                              width: 30.w,
                                              height: 7.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(28.0),
                                                    topRight:
                                                        Radius.circular(28.0),
                                                  )),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      child: Icon(
                                                    Icons
                                                        .arrow_back_ios_outlined,
                                                    size: 18.0,
                                                    color: Color(0xff6D00C2),
                                                  )),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  GradientText(
                                                      text: 'Prev',
                                                      style:
                                                          GoogleFonts.workSans(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                      gradient:
                                                          const LinearGradient(
                                                              colors: [
                                                            Colors.white,
                                                            Color(0xff6D00C2)
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
                                  ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: billsOfLevelTwoAndThree[index1]
                                                .selectedOption ==
                                            0
                                        ? () {}
                                        : () async {
                                            // SharedPreferences pref =
                                            //     await SharedPreferences
                                            //         .getInstance();

                                            if (index1 == 0) {
                                              forPlan1 =
                                                  billsOfLevelTwoAndThree[
                                                          index1]
                                                      .sliderData![myIndex]
                                                      .rent!;
                                              plans.write('plan1', forPlan1);
                                            }
                                            if (index1 == 1) {
                                              forPlan2 =
                                                  billsOfLevelTwoAndThree[
                                                          index1]
                                                      .sliderData![myIndex]
                                                      .rent!;
                                              plans.write('plan2', forPlan2);
                                            }
                                            if (index1 == 2) {
                                              forPlan3 =
                                                  billsOfLevelTwoAndThree[
                                                          index1]
                                                      .sliderData![myIndex]
                                                      .rent!;
                                              plans.write('plan3', forPlan3);
                                            }
                                            if (index1 == 3) {
                                              forPlan4 =
                                                  billsOfLevelTwoAndThree[
                                                          index1]
                                                      .sliderData![myIndex]
                                                      .rent!;
                                              plans.write('plan4', forPlan4);
                                            }

                                            if (index1 ==
                                                billsOfLevelTwoAndThree.length -
                                                    1) {
                                              globalVar = forPlan1 +
                                                  forPlan2 +
                                                  forPlan3 +
                                                  forPlan4;
                                              Get.off(() => AllDone(),
                                                duration:Duration(milliseconds: 500),
                                                transition: Transition.downToUp,);
                                            } else {
                                              _controller.nextPage(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  curve: Curves.easeIn);
                                            }

                                            // if(billsOfLevelTwoAndThree[
                                            // index1]
                                            //     .selectedOption == 1){
                                            //   forPlan1 = billsOfLevelTwoAndThree[index1]
                                            //       .sliderData![index]
                                            //       .emi!;
                                            //   pref.setInt('transportPrice',
                                            //       transportPrice);
                                            // }
                                            // if (isSelected1 == true) {
                                            //   forPlan4 = 50;
                                            //   globalVar = globalVar + forPlan4;
                                            //   pref.setInt('plan4', 50);
                                            //   Navigator.pushReplacement(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               AllDone()));
                                            // } else if (isSelected2 == true) {
                                            //   forPlan4 = 80;
                                            //   globalVar = globalVar + forPlan4;
                                            //   pref.setInt('plan4', 80);
                                            //   Navigator.pushReplacement(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               AllDone()));
                                            // } else if (isSelected3 == true) {
                                            //   forPlan4 = 120;
                                            //   globalVar = globalVar + forPlan4;
                                            //   pref.setInt('plan4', 120);
                                            //   Navigator.pushReplacement(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               AllDone()));
                                            // }
                                          },
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(_animationController),
                                      child: FadeTransition(
                                        opacity: _animationController,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 1.w, left: 1.w),
                                          child: Container(
                                            width: 30.w,
                                            height: 7.h,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(28.0),
                                                  bottomLeft:
                                                      Radius.circular(28.0),
                                                )),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 4.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GradientText(
                                                      text: 'Next',
                                                      style:
                                                          GoogleFonts.workSans(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                      gradient:
                                                          const LinearGradient(
                                                              colors: [
                                                            Colors.white,
                                                            Color(0xff6D00C2)
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
                                                    color: Color(0xff6D00C2),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      );
                    }))),
      ),
    );
  }
}

class LevelTwoAndThreeSlider {
  String? step;
  String? text;
  int? selectedOption;

  List<SliderDataForLevelTwoAndThree>? sliderData;

  LevelTwoAndThreeSlider(
      {this.step, this.text, this.sliderData, required this.selectedOption});

  factory LevelTwoAndThreeSlider.fromJson(Map<String, dynamic> json) =>
      LevelTwoAndThreeSlider(
        sliderData: List<SliderDataForLevelTwoAndThree>.from(json['sliderData']
            .map((x) => SliderDataForLevelTwoAndThree.fromJson(json))),
        text: json['text'],
        step: json['step'],
        selectedOption: json['selectedOption'],
      );

  Map<String, dynamic> toJson() => {
        'sliderData': List<SliderDataForLevelTwoAndThree>.from(
            sliderData!.map((x) => x.toJson())),
        'text': text,
        'step': step,
        'selectedOption': selectedOption
      };
}

class SliderDataForLevelTwoAndThree {
  String? text;
  String? image;
  int? rent;

  SliderDataForLevelTwoAndThree({this.text, this.image, this.rent});

  factory SliderDataForLevelTwoAndThree.fromJson(Map<String, dynamic> json) =>
      SliderDataForLevelTwoAndThree(
        text: json['text'],
        image: json['image'],
        rent: json['rent'],
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'image': image,
        'rent': rent,
      };
}

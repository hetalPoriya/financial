import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/all_done_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
              image: AllImages.level1FirstImage),
          SliderDataForLevelTwoAndThree(
              text: 'SHARED APARTMENT WITH INDIVIDUAL ROOM',
              rent: 300,
              image: AllImages.level1SecondImage),
          SliderDataForLevelTwoAndThree(
              text: 'LIVE SOLO IN YOUR OWN APARTMENT',
              rent: 400,
              image: AllImages.level1ThirdImage),
        ]),
    LevelTwoAndThreeSlider(
        text: 'TV AND BROADBAND PLAN',
        step: 'Step 2',
        selectedOption: 0,
        sliderData: [
          SliderDataForLevelTwoAndThree(
              text: 'NO TV. 1 MBPS UNLIMITED INTERNET',
              rent: 50,
              image: AllImages.level2FirstImage),
          SliderDataForLevelTwoAndThree(
              text: 'CABLE TV. 25 MBPS UNLIMITED INTERNET',
              rent: 80,
              image: AllImages.level2SecondImage),
          SliderDataForLevelTwoAndThree(
              text: 'TV & OTT SUBSCRIPTION. 100 MBPS UNLIMITED INTERNET',
              rent: 120,
              image: AllImages.level2ThirdImage),
        ]),
    LevelTwoAndThreeSlider(
        selectedOption: 0,
        text: 'GROCERY PLAN',
        step: 'Step 3',
        sliderData: [
          SliderDataForLevelTwoAndThree(
              text: 'CHEAP GROCERIES AND COOK AT HOME',
              rent: 100,
              image: AllImages.level3FirstImage),
          SliderDataForLevelTwoAndThree(
              text: 'ORGANIC GROCERIES AND EAT OUT WEEKLY',
              rent: 150,
              image: AllImages.level3SecondImage),
          SliderDataForLevelTwoAndThree(
              text: 'PREMIUM GROCERIES AND EAT OUT OFTEN',
              rent: 200,
              image: AllImages.level3ThirdImage),
        ]),
    LevelTwoAndThreeSlider(
        selectedOption: 0,
        text: 'CELLPHONE PLAN',
        step: 'Step 4',
        sliderData: [
          SliderDataForLevelTwoAndThree(
              text: '1MB DATA, 100 CALL MINUTES AND TEXTS',
              rent: 50,
              image: AllImages.level4FirstImage),
          SliderDataForLevelTwoAndThree(
              text: '5 GB DATA, UNLIMITED TEXT AND CALL',
              rent: 80,
              image: AllImages.level4SecondImage),
          SliderDataForLevelTwoAndThree(
              text: 'UNLIMITED DATA, TEXTING AND CALLING',
              rent: 120,
              image: AllImages.level4ThirdImage),
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
            snackBar:  SnackBar(
              content: Text(AllStrings.tapBack),
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
                                color: AllColors.darkOrange,
                              ),
                              child: Center(
                                  child: Text(
                                '${billsOfLevelTwoAndThree[index1].step}',
                                style: AllTextStyles.dialogStyleExtraLarge(),
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
                                style: AllTextStyles.dialogStyleExtraLarge(
                                    size: 17.sp),
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
                                                              AllColors.lightGreen,
                                                              AllColors.green
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
                                                                  style: AllTextStyles
                                                                      .workSansSmall(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        11.sp,
                                                                    color: billsOfLevelTwoAndThree[index1].selectedOption ==
                                                                            index +
                                                                                1
                                                                        ? Colors
                                                                            .white
                                                                        :Color(
                                                                        0xff3D3D3D),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                RichText(
                                                                    text: TextSpan(
                                                                        text: '${'${AllStrings.countrySymbol}${billsOfLevelTwoAndThree[index1].sliderData![index].rent}\/'}',
                                                                        style: AllTextStyles.workSansSmall(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              13.sp,
                                                                          color: billsOfLevelTwoAndThree[index1].selectedOption == index + 1
                                                                              ? Colors.white
                                                                              : AllColors.darkBlue,
                                                                        ),
                                                                        children: [
                                                                      TextSpan(
                                                                        text:
                                                                            'month',
                                                                        style: AllTextStyles.dialogStyleSmall(fontWeight: FontWeight.w400,color: billsOfLevelTwoAndThree[index1].selectedOption == index + 1
                                                                            ? Colors.white
                                                                            : AllColors.darkBlue)
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
                            style: AllTextStyles.dialogStyleSmall(fontWeight: FontWeight.w500),
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
                                                    color:AllColors.darkPink,
                                                  )),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  GradientText(
                                                      text: AllStrings.prev,
                                                      style:
                                                          AllTextStyles.dialogStyleLarge(size: 16.sp),
                                                      gradient:
                                                           LinearGradient(
                                                              colors: [
                                                            Colors.white,
                                                           AllColors.darkPink
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
                                              Get.off(
                                                () => AllDone(),
                                                duration:
                                                    Duration(milliseconds: 500),
                                                transition: Transition.downToUp,
                                              );
                                            } else {
                                              _controller.nextPage(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  curve: Curves.easeIn);
                                            }

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
                                                      text:AllStrings.next,
                                                      style:
                                                         AllTextStyles.dialogStyleLarge(size: 16.sp),
                                                      gradient:
                                                           LinearGradient(
                                                              colors: [
                                                            Colors.white,
                                                           AllColors.darkPink
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
                                                    color: AllColors.darkPink,
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

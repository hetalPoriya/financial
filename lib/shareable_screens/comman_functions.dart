import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:financial/ReusableScreen/ExpandedBottomDrawer.dart';
import 'package:financial/ReusableScreen/GameScorePage.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:financial/ReusableScreen/PreviewOfBottomDrawer.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllImages.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/ComingSoon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class BackgroundWidget extends StatefulWidget {
  final String level;
  final Widget container;
  final document;
  Decoration? decoration;

  BackgroundWidget(
      {Key? key,
      required this.container,
      required this.level,
      this.document,
      this.decoration})
      : super(key: key);

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  bool? showCase;
  GlobalKey one = GlobalKey();
  GlobalKey two = GlobalKey();
  var userId;

  String level = '';

  getLevelId() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    userId = GetStorage().read('uId');
    showCase = GetStorage().read('showCase');
    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    int levelId = snapshot.get('level_id');
    if (level == 'Level_1' && levelId == 0) {
      showCase == false
          ? WidgetsBinding.instance?.addPostFrameCallback((_) async {
              ShowCaseWidget.of(context)!.startShowCase([one, two]);
              GetStorage().write('showCase', true);
            })
          : null;
    }
    return null;
  }

  @override
  initState() {
    getLevelId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(AllStrings.tapBack),
            ),
            child: DraggableBottomSheet(
              backgroundWidget: Container(
                width: 100.w,
                height: 100.h,
                decoration: widget.decoration == null
                    ? boxDecoration
                    : widget.decoration,
                child: Column(
                  children: [
                    Spacer(),
                    GameScorePage(
                      level: widget.level,
                      document: widget.document,
                      keyValue: one,
                    ),
                    widget.container,
                    Spacer(),
                    Spacer(),
                    Spacer(),
                  ],
                ),
              ),
              previewChild: level == 'Level_1'
                  ? Showcase(
                      key: two,
                      description: AllStrings.showCaseBottomText,
                      descTextStyle:
                          AllTextStyles.workSansSmall(fontSize: 12.sp),
                      animationDuration: Duration(milliseconds: 500),
                      child: PreviewOfBottomDrawer(keyValue: two))
                  : PreviewOfBottomDrawer(keyValue: two),
              expandedChild: ExpandedBottomDrawer(),
              minExtent: 14.h,
              maxExtent: 55.h,
            ),
          )),
    );
  }
}

class GameQuestionContainer extends StatelessWidget {
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;
  final String description;
  final String option1;
  final String option2;
  final TextStyle textStyle1;
  final TextStyle textStyle2;
  final Color color1;
  final Color color2;
  final String level;
  final document;

  const GameQuestionContainer(
      {Key? key,
      required this.onPressed1,
      required this.onPressed2,
      required this.option1,
      required this.description,
      required this.option2,
      required this.textStyle1,
      required this.color1,
      required this.color2,
      required this.textStyle2,
      this.document,
      required this.level})
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
                child: Center(
                  child: normalText(description.toString()),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Container(
                  alignment: Alignment.center,
                  width: 62.w,
                  height: 7.h,
                  decoration: BoxDecoration(
                      color: color1, borderRadius: BorderRadius.circular(12.w)),
                  child: SizedBox(
                    height: 7.h,
                    width: 62.w,
                    child: TextButton(
                        style: ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: onPressed1,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              option1.toString(),
                              style: textStyle1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Container(
                  alignment: Alignment.center,
                  width: 62.w,
                  height: 7.h,
                  decoration: BoxDecoration(
                      color: color2, borderRadius: BorderRadius.circular(12.w)),
                  child: SizedBox(
                    height: 7.h,
                    width: 62.w,
                    child: TextButton(
                        style: ButtonStyle(alignment: Alignment.centerLeft),
                        onPressed: onPressed2,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              option2.toString(),
                              style: textStyle2,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InsightWidget extends StatelessWidget {
  final String level;
  final String description;
  final Color colorForContainer;
  final Color colorForText;
  final GestureTapCallback onTap;
  final document;

  InsightWidget({
    Key? key,
    required this.level,
    required this.description,
    required this.document,
    required this.colorForContainer,
    required this.colorForText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey one = GlobalKey();
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(AllStrings.tapBack),
            ),
            child: Column(
              children: [
                Spacer(),
                GameScorePage(
                  level: level,
                  document: document,
                  keyValue: one,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Container(
                    height: 54.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.w),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.w),
                                topLeft: Radius.circular(8.w),
                              ),
                              color: Color(0xffE9E5FF)),
                          child: Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 6.w),
                                child: Image.asset(
                                  AllImages.knowledgeImage,
                                  width: 60.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          width: 100.h,
                          height: 16.h,
                        ),
                        Container(
                          height: 38.h,
                          child: Padding(
                              padding: EdgeInsets.only(
                                left: 5.w,
                                right: 5.w,
                                top: 2.h,
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  description,
                                  style: AllTextStyles.workSansSmall(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.justify,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                GestureDetector(
                    onTap: onTap,
                    child: Container(
                        height: 8.h,
                        width: 75.w,
                        decoration: BoxDecoration(
                            color: colorForContainer,
                            borderRadius: BorderRadius.circular(12.w)),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: AllTextStyles.dialogStyleLarge(
                                color: colorForText, size: 16.sp),
                          ),
                        ))),
                Spacer(),
              ],
            ),
          )),
    );
  }
}

level5BillPayment(Widget widget, String image) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 4.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Image.asset(image,
                height: 4.h, width: 10.w, fit: BoxFit.contain),
          ),
        ),
        Container(
          child: widget,
        ),
      ],
    ),
  );
}

class BillPaymentWidget extends StatefulWidget {
  final String billPayment;
  final String? forPlan1;
  final String? forPlan2;
  final String? forPlan3;
  final String? forPlan4;
  final String? forPlan5;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
  final String? text5;
  final VoidCallback onPressed;
  final Color color;

  const BillPaymentWidget(
      {Key? key,
      required this.onPressed,
      required this.color,
      required this.billPayment,
      this.forPlan1,
      this.forPlan2,
      this.forPlan3,
      this.forPlan4,
      this.forPlan5,
      this.text1,
      this.text2,
      this.text3,
      this.text4,
      this.text5})
      : super(key: key);

  @override
  State<BillPaymentWidget> createState() => _BillPaymentWidgetState();
}

class _BillPaymentWidgetState extends State<BillPaymentWidget> {
  int rentPrice = 0;
  int transportPrice = 0;
  int homeLoan = 0;
  int transportLoan = 0;
  String? level;
  var userId;
  final storeValue = GetStorage();

  getData() async {
    userId = storeValue.read('uId');
    // rentPrice = storeValue.read('rentPrice');
    // transportPrice = storeValue.read('transportPrice');
    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    setState(() {
      level = snapshot.get('previous_session_info');
      homeLoan = snapshot.get('home_loan');
      transportLoan = snapshot.get('transport_loan');
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

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
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 54.h),
              child: IntrinsicHeight(child: StatefulBuilder(
                builder: (context, _setState) {
                  if (level == 'Level_5') {
                    _setState(() {
                      rentPrice = storeValue.read('rentPrice');
                      transportPrice = storeValue.read('transportPrice');
                    });
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        AllStrings.billsDue,
                        style: AllTextStyles.dialogStyleExtraLarge(size: 22.sp),
                        textAlign: TextAlign.center,
                      ),

                      (level == 'Level_4' || level == 'Level_5')
                          ? normalText(AllStrings.level4And5TitleTextForBill)
                          : normalText(
                              AllStrings.normalBillTitleText,
                            ),

                      (level == 'Level_5' && rentPrice != 0)
                          ? Column(
                              children: [
                                level5BillPayment(
                                    richText(
                                        widget.text1.toString(),
                                        '${'\$' + widget.forPlan1.toString()}',
                                        2.h,
                                        0.0,
                                        0.0,
                                        TextAlign.left),
                                    AllImages.house),
                                Text(
                                  '${AllStrings.outstandingAmount} ${'\$$homeLoan'}',
                                  style: AllTextStyles.dialogStyleMedium(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : richText(
                              widget.text1.toString(),
                              '${'\$' + widget.forPlan1.toString()}',
                              2.h,
                              0.0,
                              0.0,
                              TextAlign.left),

                      (level == 'Level_5' && transportPrice != 0)
                          ? Column(
                              children: [
                                level5BillPayment(
                                  richText(
                                      widget.text2.toString(),
                                      '${'\$' + widget.forPlan2.toString()}',
                                      2.h,
                                      0.0,
                                      0.0,
                                      TextAlign.left),
                                  AllImages.car,
                                ),
                                Text(
                                  '${AllStrings.outstandingAmount} ${'\$$transportLoan'}',
                                  style: AllTextStyles.dialogStyleMedium(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : richText(
                              widget.text2.toString(),
                              '${'\$' + widget.forPlan2.toString()}',
                              1.h,
                              0.0,
                              0.0,
                              TextAlign.left),

                      // if (level == 'Level_2' ||
                      //     level == 'Level_3' ||
                      //     level == 'Level_4')
                      //   richText(
                      //       widget.text3.toString(),
                      //       '${'\$' + widget.forPlan3.toString()}',
                      //       1.h,
                      //       0.0,
                      //       0.0,
                      //       TextAlign.left),

                      level == 'Level_5'
                          ? level5BillPayment(
                              richText(
                                  widget.text3.toString(),
                                  '${'\$' + widget.forPlan3.toString()}',
                                  2.h,
                                  0.0,
                                  0.0,
                                  TextAlign.left),
                              AllImages.lifeStyle,
                            )
                          : richText(
                              widget.text3.toString(),
                              '${'\$' + widget.forPlan3.toString()}',
                              1.h,
                              0.0,
                              0.0,
                              TextAlign.left),

                      if (level != 'Level_4')
                        richText(
                            widget.text4.toString(),
                            '${'\$' + widget.forPlan4.toString()}',
                            1.h,
                            0.0,
                            0.0,
                            TextAlign.left),

                      if (level == 'Level_5')
                        richText(
                            widget.text5.toString(),
                            '${'\$' + widget.forPlan5.toString()}',
                            1.h,
                            0.0,
                            0.0,
                            TextAlign.left),

                      Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 62.w,
                            height: 7.h,
                            decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(12.w)),
                            child: TextButton(
                                onPressed: widget.onPressed,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Center(
                                    child: FittedBox(
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        text: TextSpan(
                                            text: 'Pay now ',
                                            style:
                                                AllTextStyles.dialogStyleLarge(
                                              color: widget.color ==
                                                      AllColors.green
                                                  ? Colors.white
                                                  : AllColors.darkBlue,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '\$' +
                                                    widget.billPayment
                                                        .toString(),
                                                style: AllTextStyles
                                                    .dialogStyleLarge(
                                                  color: widget.color ==
                                                          AllColors.green
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
                      Spacer(),
                    ],
                  );
                },
              )),
            ),
          )),
    );
  }
}

class SalaryCreditedWidget extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const SalaryCreditedWidget(
      {Key? key, required this.color, required this.onPressed})
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
              normalText(AllStrings.salaryTitle, 20.sp, FontWeight.w600),
              normalText(AllStrings.salaryBody),
              buttonStyle(color, 'Okay ', onPressed),
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

class SetUpPage extends StatelessWidget {
  final String level;
  final String levelText;
  final String buttonText;
  final Widget container;
  final VoidCallback onPressed;

  const SetUpPage(
      {Key? key,
      required this.level,
      required this.levelText,
      required this.buttonText,
      required this.container,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: 100.w,
      height: 100.h,
      decoration: boxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(AllStrings.tapBack),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(
                  child: Container(
                    height: 8.h,
                    width: 62.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.w),
                      color: AllColors.darkOrange,
                    ),
                    child: Center(
                        child: Text(
                      level,
                      style: AllTextStyles.dialogStyleExtraLarge(),
                    )),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  levelText,
                  style: AllTextStyles.dialogStyleExtraLarge(size: 28.sp),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  width: 80.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9.w)),
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 00,
                          right: 00,
                          child: Image.asset(
                            AllImages.masterGroup,
                            height: 32.h,
                            alignment: Alignment.bottomRight,
                          )),
                      container,
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 8.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.w)),
                  child: TextButton(
                    onPressed: onPressed,
                    child: GradientText(
                        text: buttonText,
                        style: AllTextStyles.dialogStyleLarge(size: 16.sp),
                        gradient: LinearGradient(
                            colors: [Colors.white, AllColors.darkPink],
                            transform: GradientRotation(math.pi / 2))),
                  ),
                ),
                Spacer(),
              ],
            )),
      ),
    ));
  }
}

class MutualFundWidget extends StatelessWidget {
  final int totalMutualFund;
  final int lastMonthIncDecPer;
  final int number;
  final int netWorth;
  final int lastMonthIncDecValue;
  final VoidCallback onPressed;
  final Color color;

  const MutualFundWidget(
      {Key? key,
      required this.totalMutualFund,
      required this.lastMonthIncDecPer,
      required this.number,
      required this.netWorth,
      required this.lastMonthIncDecValue,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Center(
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
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 54.h),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        Spacer(),
                        normalText(
                            AllStrings.mutualFund, 22.sp, FontWeight.w600),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 2.h,
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                  text: lastMonthIncDecPer < 0
                                      ? AllStrings.mutualFundDecreaseText
                                      : AllStrings.mutualFundIncreaseText,
                                  style: AllTextStyles.dialogStyleLarge(
                                    size: 16.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: '${number.abs()}%'.toString(),
                                        style: AllTextStyles.dialogStyleLarge(
                                          size: 16.sp,
                                          color: AllColors.darkYellow,
                                        )),
                                    TextSpan(
                                      text: ' this month.',
                                      style: AllTextStyles.dialogStyleLarge(
                                        size: 16.sp,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        richText('Invested Amount :  ',
                            '${'\$' + totalMutualFund.toString()}', 1.h),
                        richText(
                            'Previous Month Value:  ',
                            '${'\$' + netWorth.toString()}',
                            1.h,
                            2.w,
                            2.w,
                            TextAlign.center),
                        richText('Current Value : ',
                            '${'\$' + lastMonthIncDecValue.toString()}', 1.h),
                        buttonStyle(
                            color, 'Okay', onPressed, TextAlign.center, 0.0),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class FundAllocationScreen extends StatelessWidget {
  final int totalMutualFund;
  final int lastMonthIncDecValue;
  final int netWorth;
  final Color color;
  final Widget widget;
  final VoidCallback onPressed;

  const FundAllocationScreen(
      {Key? key,
      required this.totalMutualFund,
      required this.lastMonthIncDecValue,
      required this.netWorth,
      required this.color,
      required this.widget,
      required this.onPressed})
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Center(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 2.h,
                ),
                normalText(
                    'Monthly Discretionary Fund', 18.sp, FontWeight.w600),
                richText('Invested Amount :  ',
                    '${'\$' + totalMutualFund.toString()}', 1.h),
                richText(
                    'Previous Month Value:  ',
                    '${'\$' + netWorth.toString()}',
                    0.h,
                    2.w,
                    2.w,
                    TextAlign.center),
                richText('Current Value : ',
                    '${'\$' + lastMonthIncDecValue.toString()}', 0.h),
                SizedBox(
                  height: 2.h,
                ),
                widget,
                buttonStyle(color, 'Done ', onPressed),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LevelSummaryScreen extends StatelessWidget {
  final String? level;
  Widget container;
  var document;

  LevelSummaryScreen(
      {Key? key, this.level, required this.container, this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              DraggableBottomSheet(
                backgroundWidget: Container(
                  decoration: boxDecoration,
                  width: 100.w,
                  height: 100.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: GameScorePage(
                      level: level.toString(),
                      document: document,
                    ),
                  ),
                ),
                previewChild: PreviewOfBottomDrawer(),
                expandedChild: ExpandedBottomDrawer(),
                minExtent: 14.h,
                maxExtent: 55.h,
              ),
              Material(
                elevation: 2.h,
                color: Colors.black26,
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  child: Image.asset(AllImages.summaryGif, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: container,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelSummaryForLevel1And2 extends StatelessWidget {
  final String? completeText;
  final String? text1;
  final String? text2;
  final double paddingTop;
  final Widget widget;
  final Map<String, double> dataMap;

  const LevelSummaryForLevel1And2(
      {Key? key,
        this.completeText,
        this.text1,
        this.text2,required this.paddingTop,required this.widget,
      // required this.need,
      // required this.want,
      // required this.accountBalance,
      required this.dataMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map<String, double> dataMap = {
    //   AllStrings.spendOnNeed: ((need / 200) * 100).floor().toDouble(),
    //   AllStrings.spendOnWant: ((want / 200) * 100).floor().toDouble(),
    //   AllStrings.savings: ((accountBalance / 200) * 100).floor().toDouble(),
    // };

    return Material(
      elevation: 1.h,
      borderRadius: BorderRadius.circular(
        8.w,
      ),
      child: Container(
        alignment: Alignment.center,
        height: 56.h,
        width: 80.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.w,
            ),
            color: AllColors.lightBlue),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  AllStrings.congratulations,
                  style: AllTextStyles.dialogStyleMedium(
                    size: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'You have successfully completed this level.',
                  style: AllTextStyles.dialogStyleMedium(
                    size: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 1.h,
                ),
                if(text1 != '')richText(text1.toString(), text2.toString(),paddingTop),
                // Text(
                //   AllStrings.level1And2CompleteText2,
                //   style: AllTextStyles.dialogStyleMedium(
                //       fontWeight: FontWeight.normal),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(
                //   height: 2.h,
                // ),
                Container(
                  height: 31.h,
                  width: 80.w,
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    animationDuration: Duration(milliseconds: 1000),
                    legendOptions: LegendOptions(
                        legendPosition: LegendPosition.top,
                        legendShape: BoxShape.circle,
                        legendTextStyle: AllTextStyles.dialogStyleMedium(
                            fontWeight: FontWeight.normal, size: 11.sp),
                    ),
                    chartLegendSpacing: 3.h,
                    // centerText: 'Finshark',
                    // centerTextStyle: AllTextStyles.dialogStyleSmall(size: 10.sp),
                    ringStrokeWidth: 8.w,
                    colorList: [
                      AllColors.lightOrange,
                      Colors.white70,
                      AllColors.lightGreen,
                      AllColors.extraLightBlue
                    ],
                    chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: false,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: true,
                        decimalPlaces: 0,
                        chartValueStyle: AllTextStyles.dialogStyleSmall()),
                  ),
                ),
                widget,
                SizedBox(
                  height: 1.h,
                ),
                // richText(AllStrings.totalCash, '\$' + (200.toString()), 4.h),
                // richText(AllStrings.spendOnNeed,
                //     '${((need / 200) * 100).floor()}' + '%', 1.h),
                // richText(AllStrings.spendOnWant,
                //     '${((want / 200) * 100).floor()}' + '%', 1.h),
                // richText(AllStrings.moneySaved,
                //     '${((accountBalance / 200) * 100).floor()}' + '%', 1.h),
                // buttonStyle(color, AllStrings.playNextLevel, onPressed),
                //
                // SizedBox(
                //   height: 2.h,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> getUser(int levelId) async {
  int countForUser = 0;

  int accountBalanceForUser = 0;
  int totalBalanceForUser = 0;

  int creditScoreForUser = 0;
  int totalCreditForUser = 0;

  int qolForUser = 0;
  int totalQolForUser = 0;

  int investmentForUser = 0;
  int totalInvestmentForUser = 0;

  String level = '';
  var storeValue = GetStorage();
  var userId;

  userId = storeValue.read('uId');
  QuerySnapshot snap = await firestore.collection('User').get();
  DocumentSnapshot documentSnapshot;

  documentSnapshot = await firestore.collection('User').doc(userId).get();
  level = documentSnapshot.get('previous_session_info');

  // QuerySnapshot<Map<String, dynamic>>? l1 =
  //     await firestore.collection('Level_1').get();
  // QuerySnapshot<Map<String, dynamic>>? l2 =
  //     await firestore.collection('Level_2').get();
  // QuerySnapshot<Map<String, dynamic>>? l3 =
  //     await firestore.collection('Level_3').get();
  // QuerySnapshot<Map<String, dynamic>>? l4 =
  //     await firestore.collection('Level_4').get();
  // QuerySnapshot<Map<String, dynamic>>? l5 =
  //     await firestore.collection('Level_5').get();

  snap.docs.forEach((document) async {
    documentSnapshot =
        await firestore.collection('User').doc(document.id).get();
    //levelForUser = documentSnapshot.get('previous_session_info');
    if ((documentSnapshot.data() as Map<String, dynamic>)
        .containsKey("level_1_balance")) {
      if (documentSnapshot.get('level_$levelId\_balance') != 0 &&
          document.id != userId) {
        countForUser = countForUser + 1;
        accountBalanceForUser = documentSnapshot.get('level_$levelId\_balance');
        qolForUser = documentSnapshot.get('level_$levelId\_qol');

        totalBalanceForUser = totalBalanceForUser + accountBalanceForUser;
        totalQolForUser = totalQolForUser + qolForUser;

        if (level == 'Level_3') {
          creditScoreForUser =
              documentSnapshot.get('level_$levelId\_creditScore');
          totalCreditForUser = totalCreditForUser + creditScoreForUser;
        }

        if (level == 'Level_4' || level == 'Level_5') {
          investmentForUser =
              documentSnapshot.get('level_$levelId\_investment');
          totalInvestmentForUser = totalInvestmentForUser + investmentForUser;
        }
      }

      storeValue.write('tBalance', totalBalanceForUser);
      storeValue.write('tQol', totalQolForUser);
      storeValue.write('tInvestment', totalInvestmentForUser);
      storeValue.write('tCredit', totalCreditForUser);
      storeValue.write('tUser', countForUser);
    }
  });
}

calculationForProgress(VoidCallback onPressed) async {
  int abPer = 0;
  int qolPer = 0;
  int creditPer = 0;
  int investmentper = 0;
  String level = '';
  int qol = 0;
  int accountBalance = 0;
  int creditScore = 0;
  int investment = 0;
  var storeValue = GetStorage();

  var userId = storeValue.read('uId');
  int totalBalanceForUser = storeValue.read('tBalance');
  int totalQolForUser = storeValue.read('tQol');
  int totalInvestmentForUser = storeValue.read('tInvestment');
  int totalCreditForUser = storeValue.read('tCredit');
  int countForUser = storeValue.read('tUser');

  DocumentSnapshot documentSnapshot =
      await firestore.collection('User').doc(userId).get();

  level = documentSnapshot.get('previous_session_info');
  accountBalance = documentSnapshot.get('account_balance');
  qol = documentSnapshot.get('quality_of_life');
  creditScore = documentSnapshot.get('credit_score');
  investment = documentSnapshot.get('investment');

  totalBalanceForUser = (totalBalanceForUser / countForUser).round();

  totalQolForUser = (totalQolForUser / countForUser).round();
  totalCreditForUser = (totalCreditForUser / countForUser).round();
  totalInvestmentForUser = (totalInvestmentForUser / countForUser).round();

  abPer = accountBalance - totalBalanceForUser;

  totalBalanceForUser == 0
      ? abPer = 0
      : abPer = ((abPer / totalBalanceForUser) * 100).floor();

  qolPer = qol - totalQolForUser;
  totalQolForUser == 0
      ? qolPer = 0
      : qolPer = ((qolPer / totalQolForUser) * 100).floor();

  if (level == 'Level_3') {
    creditPer = creditScore - totalCreditForUser;
    totalCreditForUser == 0
        ? creditPer = 0
        : creditPer = ((creditPer / totalCreditForUser) * 100).floor();
  }
  if (level == 'Level_4' || level == 'Level_5') {
    investmentper = investment - totalInvestmentForUser;
    totalInvestmentForUser == 0
        ? investmentper = 0
        : investmentper =
            ((investmentper / totalInvestmentForUser) * 100).floor();
  }

  savingAndQolDialog(abPer, qolPer, creditPer, investmentper, level, onPressed);
}

savingDialogText(String text1, String text2, String text3, Color color) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: RichText(
                text: TextSpan(
                    text: text1,
                    style: AllTextStyles.dialogStyleMedium(
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: text2,
                        style: AllTextStyles.dialogStyleMedium(
                            fontWeight: FontWeight.w500, color: color),
                      ),
                      TextSpan(
                        text: text3,
                        style: AllTextStyles.dialogStyleMedium(
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );

savingAndQolDialog(int abPer, int qolPer, int creditPer, int investmentPer,
    String levelForUser, VoidCallback onPressed) {
  String level = levelForUser.substring(6, 7);
  int lev = int.parse(level);

  Get.defaultDialog(
    title: 'Level $lev Progress',
    titlePadding: EdgeInsets.only(top: 2.h, bottom: 1.h),
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: AllColors.darkBlue2,
    titleStyle: AllTextStyles.dialogStyleLarge(
        size: 16.sp, fontWeight: FontWeight.w600),
    content: Padding(
      padding: EdgeInsets.only(right: 3.w, left: 3.w),
      child: Column(
        children: [
          Text(AllStrings.levelProgressTitle,
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
          SizedBox(
            height: 1.h,
          ),
          // Text(
          //     abPer > 0
          //         ? 'Your savings are ${abPer.abs()}% higher than other players. '
          //         : abPer < 0
          //             ? 'Your savings are ${abPer.abs()}% lower than other players. '
          //             : 'Your savings are ${abPer.abs()}% same as other players. ',
          //     style: GoogleFonts.workSans(
          //       fontSize: 14.sp,
          //       color: Colors.white,
          //       fontWeight: FontWeight.w500,
          //     ),
          //     textAlign: TextAlign.center),
          if (levelForUser == 'Level_1' ||
              levelForUser == 'Level_2' ||
              levelForUser == 'Level_3' ||
              levelForUser == 'Level_4' ||
              levelForUser == 'Level_5')
            abPer > 0
                ? savingDialogText(
                    AllStrings.savingsAre,
                    '${abPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : abPer < 0
                    ? savingDialogText(
                        AllStrings.savingsAre,
                        '${abPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : abPer == 0
                        ? savingDialogText('Your savings is ', 'the same ',
                            AllStrings.asOthers, AllColors.white24)
                        : null,
          //
          // SizedBox(
          //   height: 1.h,
          // ),

          if (levelForUser == 'Level_1' ||
              levelForUser == 'Level_2' ||
              levelForUser == 'Level_3' ||
              levelForUser == 'Level_4' ||
              levelForUser == 'Level_5')
            qolPer > 0
                ? savingDialogText(
                    AllStrings.lifestyleIs,
                    '${qolPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : qolPer < 0
                    ? savingDialogText(
                        AllStrings.lifestyleIs,
                        '${qolPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : qolPer == 0
                        ? savingDialogText(AllStrings.lifestyleIs, 'the same ',
                            AllStrings.asOthers, AllColors.white24)
                        : null,

          // if (levelForUser == 'Level_3')
          //   SizedBox(
          //     height: 1.h,
          //   ),

          if (levelForUser == 'Level_3')
            creditPer > 0
                ? savingDialogText(
                    AllStrings.creditScoreIs,
                    '${creditPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : creditPer < 0
                    ? savingDialogText(
                        AllStrings.creditScoreIs,
                        '${creditPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : creditPer == 0
                        ? savingDialogText(AllStrings.creditScoreIs,
                            'the same ', AllStrings.asOthers, AllColors.white24)
                        : null,

          // if (levelForUser == 'Level_4' || levelForUser == 'Level_5')
          //   SizedBox(
          //     height: 1.h,
          //   ),

          if (levelForUser == 'Level_4' || levelForUser == 'Level_5')
            investmentPer > 0
                ? savingDialogText(
                    AllStrings.investmentIs,
                    '${investmentPer.abs()}% higher ',
                    AllStrings.thanOthers,
                    AllColors.lightGreen)
                : investmentPer < 0
                    ? savingDialogText(
                        AllStrings.investmentIs,
                        '${investmentPer.abs()}% lower ',
                        AllStrings.thanOthers,
                        AllColors.lightOrange)
                    : investmentPer == 0
                        ? savingDialogText(AllStrings.investmentIs, 'the same ',
                            AllStrings.asOthers, AllColors.white24)
                        : null,
        ],
      ),
    ),
    confirm: restartOrOkButton('Keep Going', onPressed, Alignment.center),
  );
}

showDialogToShowIncreaseRent() {
  final storeValue = GetStorage();
  var userId = storeValue.read('uId');
  rentPrice = storeValue.read('rentPrice')!;
  transportPrice = storeValue.read('transportPrice')!;
  lifestylePrice = storeValue.read('lifestylePrice')!;

  rentPrice = rentPrice + ((rentPrice * 5) ~/ 100).toInt();
  transportPrice = transportPrice + ((transportPrice * 5) ~/ 100).toInt();
  lifestylePrice = lifestylePrice + ((lifestylePrice * 5) ~/ 100).toInt();

  storeValue.write('rentPrice', rentPrice);
  storeValue.write('transportPrice', transportPrice);
  storeValue.write('lifestylePrice', lifestylePrice);

  firestore
      .collection('User')
      .doc(userId)
      .update({'bill_payment': (rentPrice + transportPrice + lifestylePrice)});

  return Get.defaultDialog(
    title: 'Alert!',
    titlePadding: EdgeInsets.only(top: 2.w, bottom: 2.w),
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: AllColors.darkPurple,
    titleStyle: AllTextStyles.dialogStyleLarge(
        size: 16.sp, fontWeight: FontWeight.w800),
    content: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 1.w,
            right: 1.w,
            bottom: 4.w,
          ),
          child: Text(
            'Due to inflation, rent, transport and other prices have gone up by 5% over the last year. Your revised monthly expenses this year will be: ',
            textAlign: TextAlign.center,
            style: AllTextStyles.dialogStyleMedium(),
          ),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Home Rent ',
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '\$' + rentPrice.toString(),
                  style: AllTextStyles.dialogStyleMedium(
                    fontWeight: FontWeight.w500,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Transport ',
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '\$' + transportPrice.toString(),
                  style: AllTextStyles.dialogStyleMedium(
                    fontWeight: FontWeight.w500,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Lifestyle ',
              style:
                  AllTextStyles.dialogStyleMedium(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: '\$' + lifestylePrice.toString(),
                  style: AllTextStyles.dialogStyleMedium(
                    fontWeight: FontWeight.w500,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
      ],
    ),
    confirm: restartOrOkButton(
      'Ok',
      () {
        Get.back();
      },
    ),
  );
}

popQuizDialog(
  VoidCallback onPlayPopQuizPressed,
  VoidCallback onPlayNextLevelPressed,
) {
  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    title:
        'Congrats! You’ve managed to achieve your savings goal! Mission accomplished!',
    titleStyle: AllTextStyles.workSansSmall(fontWeight: FontWeight.w500),
    titlePadding: EdgeInsets.all(2.w),

    content: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50.w,
          height: 5.h,
          child: ElevatedButton(
            onPressed: onPlayPopQuizPressed,
            child: Text(
              AllStrings.playPopQuiz,
              style: AllTextStyles.dialogStyleSmall(size: 13.sp),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AllColors.lightBlue2,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          width: 50.w,
          height: 5.h,
          child: ElevatedButton(
            onPressed: onPlayNextLevelPressed,
            child: Text(
              AllStrings.playNextLevel,
              style: AllTextStyles.dialogStyleSmall(size: 13.sp),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                AllColors.lightBlue2,
              ),
            ),
          ),
        )
      ],
    ),
    contentPadding: EdgeInsets.all(4.w),
    // radius: 12.w,
  );
}

inviteDialog() async {
  var userId = GetStorage().read('uId');
  DocumentSnapshot snap = await firestore.collection('User').doc(userId).get();
  bool value = snap.get('replay_level');
  String level = snap.get('last_level');
  level = level.toString().substring(6, 7);
  int lev = int.parse(level);
  if (lev == 2 && value == true) {
    firestore.collection('User').doc(userId).update({'replay_level': false});
  }

  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    title: AllStrings.shareAppText,
    titleStyle: AllTextStyles.dialogStyleMedium(),
    backgroundColor: AllColors.darkPurple,
    titlePadding: EdgeInsets.all(4.w),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: ElevatedButton(
              onPressed: () async {
                //bool value = documentSnapshot.get('replay_level');
                // level = documentSnapshot.get('last_level');
                // int myBal = documentSnapshot.get('account_balance');
                // level = level.toString().substring(6, 7);
                // int lev = int.parse(level);
                // if (value == true) {
                //   Future.delayed(
                //       Duration(seconds: 1),
                //       () => showDialogForReplay(lev, userId),);
                // } else {
                FlutterShare.share(
                        title: 'https://finshark.page.link/finshark',
                        text: AllStrings.shareAppDesText,
                        linkUrl: 'https://finshark.page.link/finshark',
                        chooserTitle: 'https://finshark.page.link/finshark')
                    .then((value) {
                  // Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelThreeSetUpPage(controller: PageController()))));
                }).then((value) async {
                  Get.back();
                  FirebaseFirestore.instance
                      .collection('User')
                      .doc(userId)
                      .update({
                    //'previous_session_info': 'Level_5_setUp_page',
                    if (value != true) 'last_level': 'Level_5_setUp_page',
                    'previous_session_info': 'Coming_soon',
                    //if (value != true) 'last_level': 'Level_5_setUp_page',
                  });

                  Get.offAll(
                    () => ComingSoon(),
                    duration: Duration(milliseconds: 500),
                    transition: Transition.downToUp,
                  );
                  // Get.off(
                  //   () => LevelFiveSetUpPage(),
                  //   duration: Duration(milliseconds: 500),
                  //   transition: Transition.downToUp,
                  // );
                });
                // }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: Text(
                AllStrings.invite,
                style: AllTextStyles.dialogStyleSmall(
                  size: 13.sp,
                  color: AllColors.darkPurple,
                ),
              )),
          width: 51.w,
          height: 5.h,
        ),
        GestureDetector(
          child: Text(
            'Skip',
            style: GoogleFonts.workSans(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
          onTap: () {
            Get.back();
            var userId = GetStorage().read('uId');
            FirebaseFirestore.instance.collection('User').doc(userId).update({
              //'previous_session_info': 'Level_5_setUp_page',
              if (value != true) 'last_level': 'Level_5_setUp_page',
              'previous_session_info': 'Coming_soon',
              //if (value != true) 'last_level': 'Level_5_setUp_page',
            });
            Get.offAll(
              () => ComingSoon(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
            );
          },
        ),
      ],
    ),
    contentPadding: EdgeInsets.all(2.w),
    // radius: 12.w,
  );
}

restartLevelDialog(VoidCallback onPressed) {
  return Get.defaultDialog(
    title: '',
    titlePadding: EdgeInsets.zero,
    middleText: AllStrings.restartLevelText,
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: AllColors.darkPurple,
    middleTextStyle: AllTextStyles.dialogStyleMedium(),
    confirm: restartOrOkButton('Restart level', onPressed),
  );
}

richText(String text1, String text2, double paddingTop,
        [double? paddingLeft, double? paddingRight, TextAlign? textAlign]) =>
    Padding(
      padding: EdgeInsets.only(
          top: paddingTop,
          left: paddingLeft == null ? 0.0 : paddingLeft,
          right: paddingRight == null ? 0.0 : paddingRight),
      child: Center(
        child: RichText(
          textAlign: textAlign == null ? TextAlign.left : textAlign,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: text1,
              style: AllTextStyles.dialogStyleLarge(size: 16.sp),
              children: [
                TextSpan(
                  text: text2,
                  style: AllTextStyles.dialogStyleLarge(
                    size: 16.sp,
                    color: AllColors.darkYellow,
                  ),
                ),
              ]),
        ),
      ),
    );

normalText(String text, [double? fontSize, FontWeight? fontWeight]) => Padding(
      padding: EdgeInsets.only(top: 3.h, left: 3.w, right: 3.w),
      child: Text(
        text,
        style: AllTextStyles.dialogStyleMedium(
          size: fontSize == null ? 16.sp : fontSize.toDouble(),
          fontWeight: fontWeight == null ? FontWeight.w500 : fontWeight,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );

buttonStyle(Color color, String text, VoidCallback onPressed,
        [TextAlign? textAlign, double? left]) =>
    Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Container(
          alignment: Alignment.centerLeft,
          width: 62.w,
          height: 7.h,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12.w)),
          child: TextButton(
              onPressed: onPressed,
              // color == AllColors.green ? (){} : () async {
              //   setState(() {
              //     color = AllColors.green;
              //   });
              //   bool value = documentSnapshot.get('replay_level');
              //   level = documentSnapshot.get('last_level');
              //   level = level.toString().substring(6, 7);
              //   int lev = int.parse(level);
              //   if(lev == 1 && value == true){
              //     firestore.collection('User').doc(userId).update({
              //       'replay_level' : false
              //     });
              //   }
              //   firestore
              //       .collection('User')
              //       .doc(userId)
              //       .update({
              //     if (value != true)'last_level': 'Level_2_setUp_page',
              //     'previous_session_info': 'Level_2_setUp_page',
              //   });
              //   Future.delayed(
              //       Duration(seconds: 3),
              //           () =>  Get.off(() => LevelTwoSetUpPage(),
              //         duration:Duration(milliseconds: 500),
              //         transition: Transition.downToUp,));
              //   // gameScore = documentSnapshot
              //   //     .get('game_score');
              //   // if (lev != 1 &&
              //   //     value == true) {
              //   //   Future.delayed(
              //   //       Duration(seconds: 1),
              //   //       () => showDialogForReplay(lev, userId),
              //   //   );
              //   // } else {
              //
              //   // }
              // },
              child: Padding(
                padding: EdgeInsets.only(left: left == null ? 3.w : left),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      text,
                      style: AllTextStyles.dialogStyleLarge(
                        color: color == AllColors.green
                            ? Colors.white
                            : AllColors.darkBlue,
                      ),
                      textAlign: textAlign == null ? TextAlign.left : textAlign,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              )),
        ));

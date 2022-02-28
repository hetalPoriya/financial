import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:financial/ReusableScreen/ExpandedBottomDrawer.dart';
import 'package:financial/ReusableScreen/GameScorePage.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:financial/ReusableScreen/PreviewOfBottomDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class BackgroundWidget extends StatelessWidget {
  final String level;
  final Widget container;
  final document;

  const BackgroundWidget(
      {Key? key, required this.container, required this.level, this.document})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
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
                    container,
                    Spacer(),
                    Spacer(),
                    Spacer(),
                  ],
                ),
              ),
              previewChild: PreviewOfBottomDrawer(),
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
            color: Color(0xff6A81F4)),
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
                              // style:
                              // GoogleFonts.workSans(
                              //     color: list[index].isSelected2 == true ? Colors.white : Color(0xffFFA500),
                              //     fontWeight: FontWeight.w500,
                              //     fontSize: 15.sp),
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

  const InsightWidget(
      {Key? key,
      required this.level,
      required this.description,
      required this.document,
      required this.colorForContainer,
      required this.colorForText,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
            ),
            child: Column(
              children: [
                Spacer(),
                GameScorePage(
                  level: level,
                  document: document,
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
                                  'assets/knowledge_image.png',
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
                                  style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.sp),
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
                            style: GoogleFonts.workSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: colorForText),
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
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
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
      this.text1,
      this.text2,
      this.text3,
      this.text4})
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
              color: Color(0xff6A81F4)),
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
                        'BILLS DUE!',
                        style: GoogleFonts.workSans(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      (level == 'Level_4' || level == 'Level_5')
                          ? normalText('Your expenses this month.')
                          // Padding(
                          //         padding: EdgeInsets.only(
                          //             top: 3.h, left: 4.w, right: 4.w),
                          //         child: RichText(
                          //           textAlign: TextAlign.center,
                          //           overflow: TextOverflow.clip,
                          //           text: TextSpan(
                          //               text: 'Your expenses this month were ',
                          //               style: GoogleFonts.workSans(
                          //                   color: Colors.white,
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 16.sp),
                          //               children: [
                          //                 TextSpan(
                          //                   text: '\$' +
                          //                       widget.billPayment.toString(),
                          //                   style: GoogleFonts.workSans(
                          //                       color: Color(0xffFEBE16),
                          //                       fontWeight: FontWeight.w500,
                          //                       fontSize: 16.sp),
                          //                 ),
                          //               ]),
                          //         ),
                          //       )
                          : normalText(
                              'Your monthly bills have been generated.',
                            ),
                      // Padding(
                      //         padding: EdgeInsets.only(
                      //             top: 3.h, left: 4.w, right: 4.w),
                      //         child: Text(
                      //           'Your monthly bills have been generated.',
                      //           style: GoogleFonts.workSans(
                      //             fontSize: 16.sp,
                      //             fontWeight: FontWeight.w500,
                      //             color: Colors.white,
                      //           ),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       ),
                      // if (level == 'Level_2' ||
                      //     level == 'Level_3' ||
                      //     level == 'Level_4')
                      //   richText(
                      //       widget.text1.toString(),
                      //       '${'\$' + widget.forPlan1.toString()}',
                      //       2.h,
                      //       0.0,
                      //       0.0,
                      //       TextAlign.left),

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
                                    'assets/house.png'),
                                Text(
                                  'Outstanding Amount: ${'\$$homeLoan'}',
                                  style: GoogleFonts.workSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
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
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     top: 2.h,
                      //   ),
                      //   child: Center(
                      //     child: RichText(
                      //       textAlign: TextAlign.left,
                      //       overflow: TextOverflow.clip,
                      //       text: TextSpan(
                      //           text: widget.text1,
                      //           style: GoogleFonts.workSans(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: 16.sp),
                      //           children: [
                      //             TextSpan(
                      //               text: '\$' + widget.forPlan1.toString(),
                      //               style: GoogleFonts.workSans(
                      //                   color: Color(0xffFEBE16),
                      //                   fontWeight: FontWeight.w500,
                      //                   fontSize: 16.sp),
                      //             ),
                      //           ]),
                      //     ),
                      //   ),
                      // ),
                      // if (level == 'Level_2' ||
                      //     level == 'Level_3' ||
                      //     level == 'Level_4')
                      //   richText(
                      //       widget.text2.toString(),
                      //       '${'\$' + widget.forPlan2.toString()}',
                      //       1.h,
                      //       0.0,
                      //       0.0,
                      //       TextAlign.left),

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
                                  'assets/car.png',
                                ),
                                Text(
                                  'Outstanding Amount: ${'\$$transportLoan'}',
                                  style: GoogleFonts.workSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
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
                              'assets/lifestyle.png',
                            )
                          : richText(
                              widget.text3.toString(),
                              '${'\$' + widget.forPlan3.toString()}',
                              1.h,
                              0.0,
                              0.0,
                              TextAlign.left),

                      if (level == 'Level_1' ||
                          level == 'Level_2' ||
                          level == 'Level_3')
                        richText(
                            widget.text4.toString(),
                            '${'\$' + widget.forPlan4.toString()}',
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
                                            style: GoogleFonts.workSans(
                                                color: widget.color ==
                                                        Color(0xff00C673)
                                                    ? Colors.white
                                                    : Color(0xff4D5DDD),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.sp),
                                            children: [
                                              TextSpan(
                                                text: '\$' +
                                                    widget.billPayment
                                                        .toString(),
                                                style: GoogleFonts.workSans(
                                                    color: widget.color ==
                                                            Color(0xff00C673)
                                                        ? Colors.white
                                                        : Color(0xffFEBE16),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15.sp),
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
            color: Color(0xff6A81F4)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              normalText('Salary Credited', 20.sp, FontWeight.w600),
              normalText(
                  'Monthly salary of \$1000 has been credited to your account.'),
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
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
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
                      color: Color(0xffEF645B),
                    ),
                    child: Center(
                        child: Text(
                      level,
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
                Text(
                  levelText,
                  style: GoogleFonts.workSans(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
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
                            'assets/mastGroup.png',
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
                        style: GoogleFonts.workSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        gradient: const LinearGradient(
                            colors: [Colors.white, Color(0xff6D00C2)],
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
                color: Color(0xff6A81F4)),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 54.h),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        Spacer(),
                        normalText('Mutual Fund', 22.sp, FontWeight.w600),
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
                                      ? 'Due to a fall in stock markets your Mutual Fund value has decreased by '
                                      : 'Stock markets are going up! Your Mutual Fund has increased by ',
                                  style: GoogleFonts.workSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp),
                                  children: [
                                    TextSpan(
                                      text: '${number.abs()}%'.toString(),
                                      style: GoogleFonts.workSans(
                                          color: Color(0xffFEBE16),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp),
                                    ),
                                    TextSpan(
                                      text: ' this month.',
                                      style: GoogleFonts.workSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp),
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
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     top: 1.h,
                        //   ),
                        //   child: Center(
                        //     child: RichText(
                        //       textAlign: TextAlign.center,
                        //       overflow: TextOverflow.clip,
                        //       text: TextSpan(
                        //           text: 'FD investment : ',
                        //           style: GoogleFonts.workSans(
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 16.sp),
                        //           children: [
                        //             TextSpan(
                        //               text: '\$' +
                        //                   lastMonthIncDecValue.toString(),
                        //               style: GoogleFonts.workSans(
                        //                   color: Color(0xffFEBE16),
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 16.sp),
                        //             ),
                        //           ]),
                        //     ),
                        //   ),
                        // ),
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
            color: Color(0xff6A81F4)),
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
                // if (home == 'EMI' && homeLoan == 0 && index == fundName.length - 1)
                //   Container(
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       child: FittedBox(
                //         child: Text(
                //           'Home Loan Fully Paid',
                //           style: GoogleFonts.workSans(
                //             color: Colors.white,
                //             fontSize: 12.sp,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ),
                //       style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(
                //           Color(0xff9e9e9e),
                //         ),
                //         shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w))),
                //       ),
                //     ),
                //     height: 5.h,
                //     width: 50.w,
                //   ),
                // if (home == 'EMI' && homeLoan == 0 && index == fundName.length - 1)
                //   SizedBox(
                //     height: 2.h,
                //   ),
                // if (transport == 'Other' && transportLoan == 0 && index == fundName.length - 1)
                //   Container(
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       child: FittedBox(
                //         child: Text(
                //           'Transport Loan Fully Paid',
                //           style: GoogleFonts.workSans(
                //             color: Colors.white,
                //             fontSize: 12.sp,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ),
                //       style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(
                //           Color(0xff9e9e9e),
                //         ),
                //         shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w))),
                //       ),
                //     ),
                //     height: 5.h,
                //     width: 50.w,
                //   ),
                // if (home == 'EMI' && homeLoan == 0 && index == fundName.length - 1)
                //   SizedBox(
                //     height: 2.h,
                //   ),
                // if (home == 'EMI' &&
                //     value == 0 &&
                //     index == 0)
                //   SizedBox(
                //     height: 2.h,
                //   ),
                // if (home == 'EMI' &&
                //     value == 0 &&
                //     index == 0)
                //   Container(
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       child: Text(
                //           'Home Loan Fully Paid'),
                //       style: ButtonStyle(
                //           backgroundColor:
                //           MaterialStateProperty
                //               .all(
                //             Color(0xffA8A8A8),
                //           )),
                //     ),
                //     height: 5.h,
                //     width: 50.w,
                //   ),
                // if (home == 'EMI' &&
                //     value == 0 &&
                //     index == 0)
                //   SizedBox(
                //     height: 2.h,
                //   ),
                // Spacer(),
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

  QuerySnapshot<Map<String, dynamic>>? l1 =
      await firestore.collection('Level_1').get();
  QuerySnapshot<Map<String, dynamic>>? l2 =
      await firestore.collection('Level_2').get();
  QuerySnapshot<Map<String, dynamic>>? l3 =
      await firestore.collection('Level_3').get();
  QuerySnapshot<Map<String, dynamic>>? l4 =
      await firestore.collection('Level_4').get();
  QuerySnapshot<Map<String, dynamic>>? l5 =
      await firestore.collection('Level_5').get();

  snap.docs.forEach((document) async {
    documentSnapshot =
        await firestore.collection('User').doc(document.id).get();
    //levelForUser = documentSnapshot.get('previous_session_info');
    if ((documentSnapshot.data() as Map<String, dynamic>)
        .containsKey("level_1_balance")) {
      if (documentSnapshot.get('level_$levelId\_balance') != 0 &&
          document.id != userId) {
        countForUser = countForUser + 1;
        print('aa ${'level_$levelId\_balance'}');
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
      print('USer $countForUser');
      print('TotalBalance $totalBalanceForUser');
      print('TotalQOl $totalQolForUser');

      storeValue.write('tBalance', totalBalanceForUser);
      storeValue.write('tQol', totalQolForUser);
      storeValue.write('tInvestment', totalInvestmentForUser);
      storeValue.write('tCredit', totalCreditForUser);
      storeValue.write('tUser', countForUser);
    }
  });
}

calculationForProgress(VoidCallback onPressed) async {
  print('Called');
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

  print('totalBalanceForUser $totalBalanceForUser');
  print('totalBalanceForUser $accountBalance');
  totalBalanceForUser = (totalBalanceForUser / countForUser).round();
  print('Divide $totalBalanceForUser');
  totalQolForUser = (totalQolForUser / countForUser).round();
  totalCreditForUser = (totalCreditForUser / countForUser).round();
  totalInvestmentForUser = (totalInvestmentForUser / countForUser).round();

  abPer = accountBalance - totalBalanceForUser;
  print('abPer $abPer');
  totalBalanceForUser == 0
      ? abPer = 0
      : abPer = ((abPer / totalBalanceForUser) * 100).floor();

  print('abPer $abPer');
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

  print('Success');
  savingAndQolDialog(abPer, qolPer, creditPer, investmentper, level, onPressed);

  print('abper $abPer');
  print('abqol $qolPer');
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
            style: GoogleFonts.workSans(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: RichText(
                text: TextSpan(
                    text: text1,
                    style: GoogleFonts.workSans(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: text2,
                        style: GoogleFonts.workSans(
                          fontSize: 14.sp,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: text3,
                        style: GoogleFonts.workSans(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
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
    backgroundColor: Color(0xff5363F0),
    titleStyle: GoogleFonts.workSans(
      fontSize: 16.sp,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    content: Padding(
      padding: EdgeInsets.only(right: 3.w, left: 3.w),
      child: Column(
        children: [
          Text('You\'re doing great! See how you stack up to other finsharks.',
              style: GoogleFonts.workSans(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
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
              levelForUser == 'Level_4'||levelForUser == 'Level_5')
            abPer > 0
                ? savingDialogText(
                    'Your savings are ',
                    '${abPer.abs()}% higher ',
                    'than other players. ',
                    Color(0xff28D38B))
                : abPer < 0
                    ? savingDialogText(
                        'Your savings are ',
                        '${abPer.abs()}% lower ',
                        'than other players. ',
                        Color(0xffFF917C))
                    : abPer == 0
                        ? savingDialogText(
                            'Your savings is ',
                            'the same ',
                            'as other players.',
                            Color(0xffffffe6))
                        : null,
          //
          // SizedBox(
          //   height: 1.h,
          // ),

          if (levelForUser == 'Level_1' ||
              levelForUser == 'Level_2' ||
              levelForUser == 'Level_3' ||
              levelForUser == 'Level_4'||levelForUser == 'Level_5')
            qolPer > 0
                ? savingDialogText(
                    'Your quality of life score is ',
                    '${qolPer.abs()}% higher ',
                    'than other players. ',
                    Color(0xff28D38B))
                : qolPer < 0
                    ? savingDialogText(
                        'Your quality of life score is ',
                        '${qolPer.abs()}% lower ',
                        'than other players. ',
                        Color(0xffFF917C))
                    : qolPer == 0
                        ? savingDialogText(
                            'Your quality of life score is ',
                            'the same ',
                            'as other players. ',
                            Color(0xffffffe6))
                        : null,

          // if (levelForUser == 'Level_3')
          //   SizedBox(
          //     height: 1.h,
          //   ),

          if (levelForUser == 'Level_3')
            creditPer > 0
                ? savingDialogText(
                    'Your credit score is ',
                    '${creditPer.abs()}% higher ',
                    'than other players. ',
                    Color(0xff28D38B))
                : creditPer < 0
                    ? savingDialogText(
                        'Your credit score is ',
                        '${creditPer.abs()}% lower ',
                        'than other players. ',
                        Color(0xffFF917C))
                    : creditPer == 0
                        ? savingDialogText(
                            'Your credit score is ',
                            'the same ',
                            'as other players. ',
                            Color(0xffffffe6))
                        : null,

          // if (levelForUser == 'Level_4' || levelForUser == 'Level_5')
          //   SizedBox(
          //     height: 1.h,
          //   ),

          if (levelForUser == 'Level_4' || levelForUser == 'Level_5')
            investmentPer > 0
                ? savingDialogText(
                    'Your investment is ',
                    '${investmentPer.abs()}% higher ',
                    'than other players. ',
                    Color(0xff28D38B))
                : investmentPer < 0
                    ? savingDialogText(
                        'Your investment is ',
                        '${investmentPer.abs()}% lower ',
                        'than other players. ',
                        Color(0xffFF917C))
                    : investmentPer == 0
                        ? savingDialogText(
                            'Your investment is ',
                            'the same ',
                            'as other players. ',
                            Color(0xffffffe6))
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
    backgroundColor: Color(0xff6646E6),
    titleStyle: GoogleFonts.workSans(
      fontSize: 16.sp,
      color: Colors.white,
      fontWeight: FontWeight.w800,
    ),
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
            style: GoogleFonts.workSans(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Home Rent ',
              style: GoogleFonts.workSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp),
              children: [
                TextSpan(
                  text: '\$' + rentPrice.toString(),
                  style: GoogleFonts.workSans(
                      color: Color(0xffFEBE16),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Transport ',
              style: GoogleFonts.workSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp),
              children: [
                TextSpan(
                  text: '\$' + transportPrice.toString(),
                  style: GoogleFonts.workSans(
                      color: Color(0xffFEBE16),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp),
                ),
              ]),
        ),
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          text: TextSpan(
              text: 'Lifestyle ',
              style: GoogleFonts.workSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp),
              children: [
                TextSpan(
                  text: '\$' + lifestylePrice.toString(),
                  style: GoogleFonts.workSans(
                      color: Color(0xffFEBE16),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp),
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
    titleStyle: GoogleFonts.workSans(
      fontSize: 14.sp,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    //backgroundColor: Color(0xffE9E5FF),
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
              'Play Pop Quiz',
              style: GoogleFonts.workSans(fontSize: 13.sp, color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xff828FCE),
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
              'Play Next Level',
              style: GoogleFonts.workSans(fontSize: 13.sp, color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xff828FCE),
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

inviteDialog(dialog) {
  return Get.defaultDialog(
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    title:
        'Woohoo! Invites unlocked!  \n\n Invite your friends to play the game and challenge them to beat your score!',
    titleStyle: GoogleFonts.workSans(
      fontSize: 14.sp,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    backgroundColor: Color(0xff6646E6),
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
                        text:
                            'Hey! Have you tried out the Finshark app? It\'s a fun game that helps you build smart financial habits. You can learn to budget, invest and more. I think you\'ll like it!',
                        linkUrl: 'https://finshark.page.link/finshark',
                        chooserTitle: 'https://finshark.page.link/finshark')
                    .then((value) {
                  // Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelThreeSetUpPage(controller: PageController()))));
                }).then((value) {
                  Get.back();
                  Future.delayed(Duration(seconds: 1), () => dialog);
                });
                // }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              child: Text(
                'Click here to invite ',
                style: GoogleFonts.workSans(
                  fontSize: 13.sp,
                  color: Color(0xff6646E6),
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
            Future.delayed(Duration(seconds: 1), () => dialog);
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
    middleText:
        'Oops! You do not have enough money in your account to make this purchase. \n Press restart to try again.',
    barrierDismissible: false,
    onWillPop: () {
      return Future.value(false);
    },
    backgroundColor: Color(0xff6646E6),
    middleTextStyle: GoogleFonts.workSans(
      fontSize: 14.sp,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    confirm: restartOrOkButton('Restart level', onPressed),
  );
}
// showDialogForReplay(int lev,var userId) {
//   return Get.defaultDialog(
//     // barrierDismissible: false,
//     //onWillPop: () {return Future.value(false);},
//     title: 'Congratulations! You have completed this level successfully',
//     titleStyle: GoogleFonts.workSans(
//       fontSize: 14.sp,
//       color: Colors.black,
//       fontWeight: FontWeight.w500,
//     ),
//     //backgroundColor: Color(0xffE9E5FF),
//     titlePadding: EdgeInsets.all(2.w),
//     content: Container(
//       width: 100.w,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (lev > 1)
//             Text(
//               'Which level you want play ?',
//               style: GoogleFonts.workSans(
//                   fontSize: 12.sp,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w400),
//             ),
//           if (lev > 1) _level1(lev,userId),
//           if (lev > 2) _level2(lev,userId),
//           if (lev > 3) _level3(lev,userId),
//           if (lev > 4) _level4(lev,userId),
//           Padding(
//             padding: EdgeInsets.only(top: 3.h),
//             child: Text(
//               'Want to play current level ?',
//               style: GoogleFonts.workSans(
//                   fontSize: 12.sp,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w400),
//             ),
//           ),
//           if (lev == 1) _level1(lev,userId),
//           if (lev == 2) _level2(lev,userId),
//           if (lev == 3) _level3(lev,userId),
//           if (lev == 4) _level4(lev,userId),
//         ],
//       ),
//     ),
//     contentPadding: EdgeInsets.only(bottom: 0.w, top: 0.w),
//
//     // radius: 12.w,
//   );
// }
// Widget levelButton(String level, VoidCallback onPressed) => Padding(
//     padding: EdgeInsets.only(top: 3.w),
//     child: Container(
//       width: 40.w,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.w)),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         child: Text(level),
//         style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(
//           Color(0xff828FCE),
//         )),
//       ),
//     ));
// _level1(int lev, var userId) {
//   return levelButton(
//     'Level 1',
//     () async {
//       firestore.collection('User').doc(userId).update({
//         if (lev == 1) 'replay_level': false,
//         if (lev == 1) 'last_level': 'Level_1_setUp_page',
//         'previous_session_info': 'Level_1_setUp_page',
//         'account_balance': 0,
//         'level_id': 0,
//         'level_1_id': 0,
//         'quality_of_life': 0,
//         'need': 0,
//         'want': 0
//       }).then((value) => Get.off(
//             () => LevelOneSetUpPage(),
//             duration: Duration(milliseconds: 500),
//             transition: Transition.downToUp,
//           ));
//     },
//   );
//   // return Padding(
//   //     padding: EdgeInsets.only(top: 3.w),
//   //     child: Container(
//   //       width: 40.w,
//   //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.w)),
//   //       child: ElevatedButton(
//   //         onPressed: () async {
//   //           SharedPreferences pref = await SharedPreferences.getInstance();
//   //           userId = pref.getString('uId');
//   //           DocumentSnapshot document =
//   //           await firestore.collection('User').doc(userId).get();
//   //           gameScore = document.get('game_score');
//   //           if (lev == 1) {
//   //             firestore.collection('User').doc(userId).update({
//   //               'replay_level': false,
//   //               'previous_session_info': 'Level_1',
//   //               'account_balance': 0,
//   //               'bill_payment': 0,
//   //               'credit_card_balance': 0,
//   //               'credit_card_bill': 0,
//   //               'credit_score': 0,
//   //               'level_id': 0,
//   //               'payable_bill': 0,
//   //               'quality_of_life': 0,
//   //               'score': 0,
//   //               // 'last_level': 'Level_1',
//   //             });
//   //           } else {
//   //             firestore.collection('User').doc(userId).update({
//   //               'previous_session_info': 'Level_1',
//   //               'account_balance': 0,
//   //               'bill_payment': 0,
//   //               'credit_card_balance': 0,
//   //               'credit_card_bill': 0,
//   //               'credit_score': 0,
//   //               'level_id': 0,
//   //               'payable_bill': 0,
//   //               'quality_of_life': 0,
//   //               'score': 0
//   //             });
//   //           }
//   //           Get.off(() => AllQueLevelOne(),
//   //             duration:Duration(milliseconds: 500),
//   //             transition: Transition.downToUp,);
//   //         },
//   //         child: Text('Level 1'),
//   //         style: ButtonStyle(
//   //             backgroundColor: MaterialStateProperty.all(
//   //               Color(0xff828FCE),
//   //             )),
//   //       ),
//   //     ));
// }
// _level2(int lev, var userId) {
//   return levelButton(
//     'Level 2',
//     () {
//       firestore.collection('User').doc(userId).update({
//         if (lev == 2) 'replay_level': false,
//         if (lev == 2) 'last_level': 'Level_2_setUp_page',
//         'previous_session_info': 'Level_2_setUp_page',
//         'account_balance': 0,
//         'bill_payment': 0,
//         'level_id': 0,
//         'level_2_id': 0,
//         'quality_of_life': 0,
//         'need': 0,
//         'want': 0,
//       }).then((value) => Get.off(
//             () => LevelTwoSetUpPage(),
//             duration: Duration(milliseconds: 500),
//             transition: Transition.downToUp,
//           ));
//     },
//   );
// }
// _level3(int lev, var userId) {
//   return levelButton('Level 3', () {
//     firestore.collection('User').doc(userId).update({
//       if (lev == 3) 'replay_level': false,
//       if (lev == 3) 'last_level': 'Level_3_setUp_page',
//       'previous_session_info': 'Level_3_setUp_page',
//       'account_balance': 0,
//       'bill_payment': 0,
//       'credit_card_balance': 0,
//       'credit_card_bill': 0,
//       'credit_score': 0,
//       'level_id': 0,
//       'level_3_id': 0,
//       'payable_bill': 0,
//       'quality_of_life': 0,
//       'score': 0,
//       'need': 0,
//       'want': 0,
//     }).then((value) => Get.off(
//           () => LevelThreeSetUpPage(),
//           duration: Duration(milliseconds: 500),
//           transition: Transition.downToUp,
//         ));
//   });
// }
// _level4(int lev,var userId) {
//   return levelButton('Level 4', () {
//     firestore.collection('User').doc(userId).update({
//       if (lev == 3) 'replay_level': false,
//       if (lev == 3) 'last_level': 'Level_4_setUp_page',
//       'previous_session_info': 'Level_4_setUp_page',
//       'account_balance': 0,
//       'bill_payment': 0,
//       'level_id': 0,
//       'level_4_id': 0,
//       'quality_of_life': 0,
//       'need': 0,
//       'want': 0,
//       'home_loan' : 0,
//       'transport_loan' : 0,
//     }).then((value) => Get.off(
//           () => LevelFourSetUpPage(),
//       duration: Duration(milliseconds: 500),
//       transition: Transition.downToUp,
//     ));
//   });
// }

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
              style: GoogleFonts.workSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp),
              children: [
                TextSpan(
                  text: text2,
                  style: GoogleFonts.workSans(
                      color: Color(0xffFEBE16),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp),
                ),
              ]),
        ),
      ),
    );

normalText(String text, [double? fontSize, FontWeight? fontWeight]) => Padding(
      padding: EdgeInsets.only(top: 3.h, left: 3.w, right: 3.w),
      child: Text(
        text,
        style: GoogleFonts.workSans(
          fontSize: fontSize == null ? 16.sp : fontSize.toDouble(),
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
              // color == Color(0xff00C673) ? (){} : () async {
              //   setState(() {
              //     color = Color(0xff00C673);
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
                      style: GoogleFonts.workSans(
                          color: color == Color(0xff00C673)
                              ? Colors.white
                              : Color(0xff4D5DDD),
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp),
                      textAlign: textAlign == null ? TextAlign.left : textAlign,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              )),
        ));

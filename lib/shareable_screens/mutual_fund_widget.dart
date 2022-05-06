
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
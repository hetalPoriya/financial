
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
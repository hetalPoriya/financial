
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'custom_screens.dart';

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
    return Container(
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
                  text: 'Monthly Discretionary Fund', fontSize: 18.sp, fontWeight: FontWeight.w600),
              richText(
                  text1: 'Invested Amount :  ',
                  text2: '${AllStrings.countrySymbol + totalMutualFund.toString()}',
                  paddingTop: 1.h),
              richText(
                  text1: 'Previous Month Value:  ',
                  text2: '${AllStrings.countrySymbol + netWorth.toString()}',
                  paddingTop: 0.h,
                  paddingLeft: 2.w,
                  paddingRight: 2.w,
                  textAlign: TextAlign.center),
              richText(text1: 'Current Value : ',
                  text2: '${AllStrings.countrySymbol + lastMonthIncDecValue.toString()}', ),
              SizedBox(
                height: 2.h,
              ),
              widget,
              buttonStyle(color: color, text: 'Done ', onPressed: onPressed),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

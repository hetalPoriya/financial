import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';

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
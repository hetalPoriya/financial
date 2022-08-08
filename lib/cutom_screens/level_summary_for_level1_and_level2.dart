import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';

import 'custom_screens.dart';

class LevelSummaryForLevel1And2 extends StatelessWidget {
  final String? mainText;
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
      this.text2,
      required this.paddingTop,
      required this.widget,
      // required this.need,
      // required this.want,
      this.mainText,
      required this.dataMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  mainText.toString(),
                  style: AllTextStyles.workSansSmallWhite().copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  completeText.toString(),
                  style: AllTextStyles.workSansSmallWhite().copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 1.h,
                ),
                if (text1 != '')
                  richText(
                      text1: text1.toString(),
                      text2: text2.toString(),
                      paddingTop: paddingTop),
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
                      legendLabels: ({
                        'Needs': 'needs',
                        'AAA': 'WNa',
                        'AA': 'sa'
                      }),
                      legendTextStyle: AllTextStyles.workSansSmallWhite()
                          .copyWith(
                              fontWeight: FontWeight.normal, fontSize: 11.sp),
                    ),
                    chartLegendSpacing: 3.h,
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
                        chartValueStyle: AllTextStyles.workSansExtraSmall()
                            .copyWith(fontSize: 10.sp)),
                  ),
                ),
                widget,
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

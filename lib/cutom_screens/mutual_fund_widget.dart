import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/global_variable.dart';
import '../utils/utils.dart';
import 'custom_screens.dart';

class InvestmentGraph {
  InvestmentGraph(this.month, this.currentValue);

  final String? month;
  final double currentValue;
}

class MutualFundWidget extends StatelessWidget {
  final int totalMutualFund;
  final int lastMonthIncDecPer;
  final int number;
  final int netWorth;
  final int lastMonthIncDecValue;
  final VoidCallback onPressed;
  final Color color;

  MutualFundWidget(
      {Key? key,
      required this.totalMutualFund,
      required this.lastMonthIncDecPer,
      required this.number,
      required this.netWorth,
      required this.lastMonthIncDecValue,
      required this.onPressed,
      required this.color,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String>? savedStrList = Prefs.getStringList(PrefString.graphValue);
    incDesPer = savedStrList!.map((i) => int.parse(i)).toList();
    print('index ${incDesPer.length}');
    print('total value $incDesPer');
    print('keyValue ${incDesPer.asMap().containsKey(0)}');
    print('keyValue1 ${incDesPer.asMap().containsKey(1)}');
    print('keyValue2 ${incDesPer.asMap().containsKey(2)}');

    List<InvestmentGraph> investmentGraph = [
      InvestmentGraph('1M', 0),
      if (incDesPer.asMap().containsKey(0))
        InvestmentGraph('2M', incDesPer[0].toDouble()),
      if (incDesPer.asMap().containsKey(1))
        InvestmentGraph('3M', incDesPer[1].toDouble()),
      if (incDesPer.asMap().containsKey(2))
        InvestmentGraph('4M', incDesPer[2].toDouble()),
      if (incDesPer.asMap().containsKey(3))
        InvestmentGraph('5M', incDesPer[3].toDouble()),
      if (incDesPer.asMap().containsKey(4))
        InvestmentGraph('6M', incDesPer[4].toDouble()),
      if (incDesPer.asMap().containsKey(5))
        InvestmentGraph('7M', incDesPer[5].toDouble()),
      if (incDesPer.asMap().containsKey(6))
        InvestmentGraph('8M', incDesPer[6].toDouble()),
      if (incDesPer.asMap().containsKey(7))
        InvestmentGraph('9M', incDesPer[7].toDouble()),
      if (incDesPer.asMap().containsKey(8))
        InvestmentGraph('10M', incDesPer[8].toDouble()),
      if (incDesPer.asMap().containsKey(9))
        InvestmentGraph('11M', incDesPer[9].toDouble()),
      if (incDesPer.asMap().containsKey(10))
        InvestmentGraph('12M', incDesPer[10].toDouble()),
      if (incDesPer.asMap().containsKey(11))
        InvestmentGraph('13M', incDesPer[11].toDouble()),
      if (incDesPer.asMap().containsKey(12))
        InvestmentGraph('14M', incDesPer[12].toDouble()),
      if (incDesPer.asMap().containsKey(13))
        InvestmentGraph('15M', incDesPer[13].toDouble()),
      if (incDesPer.asMap().containsKey(14))
        InvestmentGraph('16M', incDesPer[14].toDouble()),
      if (incDesPer.asMap().containsKey(15))
        InvestmentGraph('17M', incDesPer[15].toDouble()),
      if (incDesPer.asMap().containsKey(16))
        InvestmentGraph('18M', incDesPer[16].toDouble()),
      if (incDesPer.asMap().containsKey(17))
        InvestmentGraph('19M', incDesPer[17].toDouble()),
      if (incDesPer.asMap().containsKey(18))
        InvestmentGraph('20M', incDesPer[18].toDouble()),
      if (incDesPer.asMap().containsKey(19))
        InvestmentGraph('21M', incDesPer[19].toDouble()),
      if (incDesPer.asMap().containsKey(20))
        InvestmentGraph('22M', incDesPer[20].toDouble()),
      if (incDesPer.asMap().containsKey(21))
        InvestmentGraph('23M', incDesPer[21].toDouble()),
      if (incDesPer.asMap().containsKey(22))
        InvestmentGraph('24M', incDesPer[22].toDouble()),
      if (incDesPer.asMap().containsKey(23))
        InvestmentGraph('25M', incDesPer[23].toDouble()),
      if (incDesPer.asMap().containsKey(24))
        InvestmentGraph('26M', incDesPer[24].toDouble()),
      if (incDesPer.asMap().containsKey(25))
        InvestmentGraph('27M', incDesPer[25].toDouble()),
      if (incDesPer.asMap().containsKey(26))
        InvestmentGraph('28M', incDesPer[26].toDouble()),
      if (incDesPer.asMap().containsKey(27))
        InvestmentGraph('29M', incDesPer[27].toDouble()),
      if (incDesPer.asMap().containsKey(28))
        InvestmentGraph('30M', incDesPer[28].toDouble()),
    ];

    print('length ${investmentGraph.length}');

    return Center(
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
          children: [
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Investment Portfolio',
              style: AllTextStyles.workSansLarge()
                  .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 1.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: RichText(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                      text: lastMonthIncDecPer < 0
                          ? AllStrings.mutualFundDecreaseText
                          : AllStrings.mutualFundIncreaseText,
                      style: AllTextStyles.workSansLarge().copyWith(
                        fontSize: 12.sp,
                      ),
                      children: [
                        TextSpan(
                            text: '${number.abs()}%'.toString(),
                            style: AllTextStyles.workSansLarge().copyWith(
                              fontSize: 12.sp,
                              color: AllColors.darkYellow,
                            )),
                        TextSpan(
                          text: ' this month.',
                          style: AllTextStyles.workSansLarge().copyWith(
                            fontSize: 12.sp,
                          ),
                        )
                      ])),
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
                'Investments ${AllStrings.countrySymbol + totalMutualFund.toString()}',
                style: AllTextStyles.workSansLarge().copyWith(
                  fontSize: 12.sp,
                )),
            SizedBox(
              height: 1.h,
            ),
            Text(
              'Current Value  ${AllStrings.countrySymbol + lastMonthIncDecValue.toString()}',
              style: AllTextStyles.workSansLarge().copyWith(
                  fontSize: 12.sp, color: AllColors.creditScore550to650),
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              'Overall gain   ${AllStrings.countrySymbol + '35K'}',
              style: AllTextStyles.workSansLarge().copyWith(
                  fontSize: 12.sp,
                  color: AllColors.creditScore650to750,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              height: 24.h,
              // width: 90.w,
              // color: AllColors.red,

              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  //Hide the gridlines of x-axis
                  majorGridLines: MajorGridLines(
                    width: 0,
                  ),
                  // interval: 7,
                  //Hide the axis line of x-axis
                  axisLine: AxisLine(width: 0),
                  title: AxisTitle(
                      text: 'Month',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                      )),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 6.sp),
                ),
                enableAxisAnimation: true,
                primaryYAxis: NumericAxis(
                  associatedAxisName: 'Current Value',
                  maximum: (lastMonthIncDecValue + 1000).toDouble(),
                  //maximum: 9000,
                  minimum: -100,
                  isVisible: false,
                  //Hide the gridlines of y-axis
                  majorGridLines: MajorGridLines(width: 0),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 6.sp),
                  //Hide the axis line of y-axis
                  axisLine: AxisLine(width: 0),
                  title: AxisTitle(
                      text: 'Current Value',
                      textStyle:
                          TextStyle(color: Colors.white, fontSize: 8.sp)),
                ),
                series: <ChartSeries>[
                  SplineSeries<InvestmentGraph, String>(
                      dataSource: investmentGraph,
                      xValueMapper: (InvestmentGraph investment, _) =>
                          investment.month,
                      yValueMapper: (InvestmentGraph investment, _) =>
                          investment.currentValue,
                      color: AllColors.creditScore550to650,
                      animationDuration: 2000,
                      markerSettings: MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          width: 1.w,
                          height: 1.w)),
                ],
                plotAreaBorderColor: Colors.transparent,
                // tooltipBehavior: TooltipBehavior(
                //   enable: true,
                //   canShowMarker: true,
                //   header: 'Month',
                //   shadowColor: AllColors.creditScore550to650,
                // ),
              ),
            ),
            buttonStyle(
                color: color,
                text: 'Okay',
                onPressed: onPressed,
                textAlign: TextAlign.center,
                topPadding: 0.h),
            SizedBox(
              height: 1.w,
            )
          ],
        ),

        //   child: IntrinsicHeight(
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 4.w),
        //       child: Column(
        //         children: [
        //           Spacer(),
        //           normalText(
        //               text: AllStrings.mutualFund,
        //               fontSize: 22.sp,
        //               fontWeight: FontWeight.w600),
        //           Padding(
        //             padding: EdgeInsets.only(
        //               top: 2.h,
        //             ),
        //             child: Center(
        //               child: RichText(
        //                 textAlign: TextAlign.center,
        //                 overflow: TextOverflow.clip,
        //                 text: TextSpan(
        //                     text: lastMonthIncDecPer < 0
        //                         ? AllStrings.mutualFundDecreaseText
        //                         : AllStrings.mutualFundIncreaseText,
        //                     style: AllTextStyles.workSansLarge(
        //                       size: 16.sp,
        //                     ),
        //                     children: [
        //                       TextSpan(
        //                           text: '${number.abs()}%'.toString(),
        //                           style: AllTextStyles.workSansLarge(
        //                             size: 16.sp,
        //                             color: AllColors.darkYellow,
        //                           )),
        //                       TextSpan(
        //                         text: ' this month.',
        //                         style: AllTextStyles.workSansLarge(
        //                           size: 16.sp,
        //                         ),
        //                       )
        //                     ]),
        //               ),
        //             ),
        //           ),
        //           richText(
        //               text1: 'Invested Amount :  ',
        //               text2: '${AllStrings.countrySymbol + totalMutualFund.toString()}',
        //               paddingTop: 1.h),
        //           richText(
        //               text1: 'Previous Month Value:  ',
        //               text2: '${AllStrings.countrySymbol + netWorth.toString()}',
        //               paddingTop: 1.h,
        //               paddingLeft: 2.w,
        //               paddingRight: 2.w,
        //               textAlign: TextAlign.center),
        //           richText(
        //               text1: 'Current Value : ',
        //               text2: '${AllStrings.countrySymbol + lastMonthIncDecValue.toString()}',
        //               paddingTop: 1.h),
        //           buttonStyle(
        //             color: color,
        //             text: 'Okay',
        //             onPressed: onPressed,
        //             textAlign: TextAlign.center,
        //           ),
        //           Spacer(),
        //         ],
        //       ),
        //     ),
        //   ),
      ),
    ));
  }
}

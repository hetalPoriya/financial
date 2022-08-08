
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:flutter/material.dart';
import '../utils/global_variable.dart';
import 'package:sizer/sizer.dart';

import 'custom_screens.dart';

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
    return Container(
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
                child: normalText(text: description.toString()),
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
                            option1.toString().replaceAll(
                                '\$',
                                AllStrings.countrySymbol),
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
                            option2.toString().replaceAll(
                                '\$',
                                AllStrings.countrySymbol),
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
    );
  }


}

import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
              normalText(text: AllStrings.salaryTitle, fontSize: 20.sp,fontWeight:  FontWeight.w600),
              normalText(text: AllStrings.salaryBody),
              buttonStyle(color: color,text:  'Okay ', onPressed: onPressed),
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
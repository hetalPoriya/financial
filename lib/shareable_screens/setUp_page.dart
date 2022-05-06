import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class SetUpPage extends StatelessWidget {
  final String level;
  final String levelText;
  final String buttonText;
  final Widget container;
  final Color color;
  final VoidCallback onPressed;

  const SetUpPage(
      {Key? key,
      required this.level,
      required this.levelText,
      required this.buttonText,
      required this.container,
      required this.onPressed,
      required this.color})
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
                      color: color, borderRadius: BorderRadius.circular(12.w)),
                  child: TextButton(
                    onPressed: onPressed,
                    child: GradientText(
                        text: buttonText,
                        style: AllTextStyles.dialogStyleLarge(size: 16.sp),
                        gradient: LinearGradient(
                            colors: color == AllColors.green
                                ? [Colors.white, Colors.white]
                                : [Colors.white, AllColors.darkPink],
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

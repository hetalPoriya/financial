
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/shareable_screens/game_score_page.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InsightWidget extends StatelessWidget {
  final String level;
  final String description;
  final Color colorForContainer;
  final Color colorForText;
  final GestureTapCallback onTap;
  final document;

  InsightWidget({
    Key? key,
    required this.level,
    required this.description,
    required this.document,
    required this.colorForContainer,
    required this.colorForText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey one = GlobalKey();
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(AllStrings.tapBack),
            ),
            child: Column(
              children: [
                Spacer(),
                GameScorePage(
                  level: level,
                  document: document,
                  keyValue: one,
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
                                  AllImages.knowledgeImage,
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
                                  style: AllTextStyles.workSansSmall(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.normal),
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
                            style: AllTextStyles.dialogStyleLarge(
                                color: colorForText, size: 16.sp),
                          ),
                        ))),
                Spacer(),
              ],
            ),
          )),
    );
  }
}
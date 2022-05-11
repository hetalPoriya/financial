
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/levels.dart';
import 'package:financial/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,),
        // extendBodyBehindAppBar: true,
        body: Container(
          decoration: boxDecoration,
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              Spacer(),
              Text(
                'finshark',
                style:AllTextStyles.finsharkRoboto(),
              ),
              SizedBox(
                height: 8.h,
              ),
              Image.asset(
                AllImages.comingSoon,
                width: 90.w,
                height: 20.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'COMING SOON',
                style: AllTextStyles.comingSoon(),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 18.h,
                width: 80.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w),
                    color: AllColors.lightBlue),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                  child: Center(
                    child: Text(
                      AllStrings.comingSoon,
                      style: AllTextStyles.dialogStyleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                width: 56.w,
                height: 6.h,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ))),
                  child: GradientText(
                    text:AllStrings.playAgain,
                    style: AllTextStyles.dialogStyleExtraLarge(fontWeight: FontWeight.w700,size: 18.sp),
                    gradient: LinearGradient(colors: [
                      AllColors.blue,
                      AllColors.purple,
                    ]),
                  ),
                  onPressed: () {
                    Future.delayed(
                        Duration(seconds: 1),
                            () =>  Get.to(() => SettingsPage(),
                          duration:Duration(milliseconds: 500),
                          transition: Transition.downToUp,));
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

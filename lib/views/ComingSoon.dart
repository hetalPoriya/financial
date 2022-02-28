
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:financial/views/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8.h,
              ),
              Image.asset(
                'assets/comingSoon.png',
                width: 90.w,
                height: 20.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'COMING SOON',
                style: GoogleFonts.balooDa(
                    color: Color(0xffFFD25E),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 18.h,
                width: 80.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w),
                    color: Color(0xff6A6BEF)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                  child: Center(
                    child: Text(
                      'We are under the process of creating something amazing. NEW LEVELS will be live soon!! ',
                      style: GoogleFonts.workSans(
                          color: Colors.white, fontSize: 14.sp),
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
                    text: 'Play Again',
                    style: GoogleFonts.workSans(
                        fontSize: 18.sp, fontWeight: FontWeight.w700),
                    gradient: LinearGradient(colors: [
                      Color(0xff4D6EF2),
                      Color(0xff6448E8),
                    ]),
                  ),
                  onPressed: () {
                    Future.delayed(
                        Duration(seconds: 1),
                            () =>  Get.off(() => ProfilePage(),
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

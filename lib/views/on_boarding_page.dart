import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/controllers/on_boarding_controller.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OnBoardingPage extends StatelessWidget {
  final _controller = OnBoardingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: PageView.builder(
              itemCount: _controller.sliderValue.sliderData.length,
              controller: _controller.pageController,
              onPageChanged:_controller.selectedPageIndex,
              itemBuilder: (context, index) {
                return Container(
                  width: 100.w, height: 100.h,
                  //  color: Colors.deepPurpleAccent,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        child: Image.asset(
                          '${_controller.sliderValue.imageLine1}',
                          fit: BoxFit.contain,
                        ),
                        top: 00.h,
                        left: 00.w,
                        width: 60.w,
                        height: 50.h,
                      ),
                      Positioned(
                        child: Image.asset(
                          '${_controller.sliderValue.imageLine2}',
                        ),
                        top: 20.h,
                        right: 00.w,
                        width: 60.w,
                        height: 50.h,
                      ),
                      Positioned(
                        child: Image.asset(
                          '${_controller.sliderValue.sliderData[index].image}',
                          height: 50.h,
                          width: 90.w,
                          fit: BoxFit.contain,
                        ),
                        top: 4.h,
                      ),
                      if (index == 0)
                        Positioned(
                            top: 59.h,
                            child: GradientText(
                              text:
                                  '${_controller.sliderValue.sliderData[index].text}',
                              style: AllTextStyles.dialogStyleExtraLarge(size: 30.sp,fontWeight: FontWeight.w700,color:Color(0xffA566FF), ),


                              gradient: LinearGradient(
                                colors: [
                                  AllColors.purple,
                                  AllColors.blue,
                                  Color(0xffFFFFFF),
                                  // AllColors.purple,
                                  // Color(AllColors.blue),
                                ],
                                // begin: Alignment.topLeft,
                                // end: Alignment.bottomRight
                              ),
                            )),
                      Positioned(
                          top: index == 0 ? 73.h : 57.h,
                          left: 8.w,
                          right: 8.w,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${_controller.sliderValue.sliderData[index].description}',
                              style: index == 0
                                  ?
                              AllTextStyles.roboto()
                                  : AllTextStyles.roboto(size: 16.sp,fontWeight: FontWeight.w600,  color: Color(0xff634BE9),),
                              textAlign: TextAlign.justify,
                            ),
                          )),
                      Positioned(
                        bottom: 3.h,
                        width: 100.w,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: List.generate(
                                  _controller.sliderValue.sliderData.length,
                                  (index) => Obx(() {
                                      return Container(
                                        width: _controller.selectedPageIndex.value == index ? 5.w : 2.w,
                                        height: 3.w,
                                       decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(2.w),
                                         color:_controller.selectedPageIndex.value == index ? Color(0xff5168F1) : Color(0xffF0E7FD),
                                       ),
                                        margin: EdgeInsets.all(1.w),
                                      );
                                    }
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _controller.forwardAction,
                                child: Container(
                                  height: 5.h,
                                  width: 24.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.w),
                                      gradient: LinearGradient(colors: [
                                        Color(0xff5463EF),
                                        Color(0xff634AE9),
                                      ])),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'NEXT',
                                        style: AllTextStyles.dialogStyleSmall(size: 13.sp),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}

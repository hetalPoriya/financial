import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/utils.dart';

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
    return Container(
      height: 54.h,
      width: 80.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 11.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.w),
                  topLeft: Radius.circular(8.w),
                ),
                color: Color(0xffE9E5FF)),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Image.asset(
                  AllImages.knowledgeImage,
                  width: 55.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            width: 100.h,
          ),
          Container(
            height: 43.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          top: 2.h,
                          bottom: 1.w
                        ),
                        child: Text(
                          description,
                          style: AllTextStyles.workSansSmallBlack().copyWith(
                              fontSize: 15.sp, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.justify,
                        )),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                          height: 5.h,
                          width: 100.w,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                             // color: Color(0xffE9E5FF),
                              // color: AllColors.settingsPageColor2,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.w),
                                bottomRight: Radius.circular(8.w),
                              )),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: AllTextStyles.workSansLarge().copyWith(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return SafeArea(
    //   child: Scaffold(
    //       backgroundColor: Colors.transparent,
    //       body: DoubleBackToCloseApp(
    //         snackBar: SnackBar(
    //           content: Text(AllStrings.tapBack),
    //         ),
    //         child:  Container(
    //           height: 54.h,
    //           width: 80.w,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(8.w),
    //             color: Colors.white,
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Container(
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.only(
    //                       topRight: Radius.circular(8.w),
    //                       topLeft: Radius.circular(8.w),
    //                     ),
    //                     color: Color(0xffE9E5FF)),
    //                 child: Padding(
    //                   padding: EdgeInsets.only(top: 2.h),
    //                   child: Center(
    //                     child: Padding(
    //                       padding: EdgeInsets.only(left: 6.w),
    //                       child: Image.asset(
    //                         AllImages.knowledgeImage,
    //                         width: 60.w,
    //                         fit: BoxFit.contain,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 width: 100.h,
    //                 height: 16.h,
    //               ),
    //               Container(
    //                 height: 38.h,
    //                 child: Padding(
    //                     padding: EdgeInsets.only(
    //                       left: 5.w,
    //                       right: 5.w,
    //                       top: 2.h,
    //                     ),
    //                     child: SingleChildScrollView(
    //                       child: Text(
    //                         description,
    //                         style: AllTextStyles.workSansSmallBlackBlack(
    //                             fontSize: 15.sp,
    //                             fontWeight: FontWeight.normal),
    //                         textAlign: TextAlign.justify,
    //                       ),
    //                     )),
    //               ),
    //             ],
    //           ),
    //         ),
    //         // child: Column(
    //         //   children: [
    //         //     // Spacer(),
    //         //     // GameScorePage(
    //         //     //   level: level,
    //         //     //   document: document,
    //         //     //   keyValue: one,
    //         //     // ),
    //         //     // SizedBox(
    //         //     //   height: 4.h,
    //         //     // ),
    //         //     // Padding(
    //         //     //   padding: EdgeInsets.only(top: 2.h),
    //         //     //   child: Container(
    //         //     //     height: 54.h,
    //         //     //     width: 80.w,
    //         //     //     decoration: BoxDecoration(
    //         //     //       borderRadius: BorderRadius.circular(8.w),
    //         //     //       color: Colors.white,
    //         //     //     ),
    //         //     //     child: Column(
    //         //     //       mainAxisAlignment: MainAxisAlignment.start,
    //         //     //       crossAxisAlignment: CrossAxisAlignment.start,
    //         //     //       children: [
    //         //     //         Container(
    //         //     //           decoration: BoxDecoration(
    //         //     //               borderRadius: BorderRadius.only(
    //         //     //                 topRight: Radius.circular(8.w),
    //         //     //                 topLeft: Radius.circular(8.w),
    //         //     //               ),
    //         //     //               color: Color(0xffE9E5FF)),
    //         //     //           child: Padding(
    //         //     //             padding: EdgeInsets.only(top: 2.h),
    //         //     //             child: Center(
    //         //     //               child: Padding(
    //         //     //                 padding: EdgeInsets.only(left: 6.w),
    //         //     //                 child: Image.asset(
    //         //     //                   AllImages.knowledgeImage,
    //         //     //                   width: 60.w,
    //         //     //                   fit: BoxFit.contain,
    //         //     //                 ),
    //         //     //               ),
    //         //     //             ),
    //         //     //           ),
    //         //     //           width: 100.h,
    //         //     //           height: 16.h,
    //         //     //         ),
    //         //     //         Container(
    //         //     //           height: 38.h,
    //         //     //           child: Padding(
    //         //     //               padding: EdgeInsets.only(
    //         //     //                 left: 5.w,
    //         //     //                 right: 5.w,
    //         //     //                 top: 2.h,
    //         //     //               ),
    //         //     //               child: SingleChildScrollView(
    //         //     //                 child: Text(
    //         //     //                   description,
    //         //     //                   style: AllTextStyles.workSansSmallBlackBlack(
    //         //     //                       fontSize: 15.sp,
    //         //     //                       fontWeight: FontWeight.normal),
    //         //     //                   textAlign: TextAlign.justify,
    //         //     //                 ),
    //         //     //               )),
    //         //     //         ),
    //         //     //       ],
    //         //     //     ),
    //         //     //   ),
    //         //     // ),
    //         //     // SizedBox(
    //         //     //   height: 6.h,
    //         //     // ),
    //         //     // GestureDetector(
    //         //     //     onTap: onTap,
    //         //     //     child: Container(
    //         //     //         height: 8.h,
    //         //     //         width: 75.w,
    //         //     //         decoration: BoxDecoration(
    //         //     //             color: colorForContainer,
    //         //     //             borderRadius: BorderRadius.circular(12.w)),
    //         //     //         child: Center(
    //         //     //           child: Text(
    //         //     //             'Continue',
    //         //     //             style: AllTextStyles.workSansLarge(
    //         //     //                 color: colorForText, size: 16.sp),
    //         //     //           ),
    //         //     //         ))),
    //         //     // Spacer(),
    //         //   ],
    //         // ),
    //       )),
    // );
  }
}

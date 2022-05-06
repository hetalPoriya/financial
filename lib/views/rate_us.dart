import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RateUs extends StatelessWidget {
  final Function onSubmit;

  RateUs({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var con = Get.put<UserInfoController>(UserInfoController());
    return SafeArea(
      top: false,
      child: Scaffold(
        body: GetBuilder<UserInfoController>(builder: (userInfo) {
          return SingleChildScrollView(
            child: Container(
              height: 100.h,
              width: 100.w,
              decoration: boxDecoration,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(AllStrings.rateText1,
                          style: AllTextStyles.signikaText1(),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      AllStrings.rateText2,
                      style: AllTextStyles.signikaText2(),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    SmoothStarRating(
                      allowHalfRating: false,
                      color: Colors.amber,
                      size: 15.w,
                      borderColor: Colors.amber.withAlpha(150),
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      onRated: (rating) {
                        userInfo.star = rating;
                        userInfo.update();
                        print('INFO ${userInfo.star}');
                      },
                    ),
                    // RatingBar.builder(
                    //   direction: Axis.horizontal,
                    //   allowHalfRating: true,
                    //   itemCount: 5,
                    //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    //   itemBuilder: (context, _) => Icon(
                    //     Icons.star,
                    //     color: Colors.amber,
                    //   ),
                    //   onRatingUpdate: (rating) {
                    //     userInfo.star = rating;
                    //   },
                    // ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      AllStrings.rateText3,
                      style: AllTextStyles.signikaText2(size: 14.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 25.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: TextField(
                          controller: userInfo.feedbackCon,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Type here....",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ElevatedButton(
                      onPressed: userInfo.star == 0
                          ? () {
                              print(userInfo.star);
                              Fluttertoast.showToast(
                                  msg: 'Please rate your experience ');
                            }
                          : () {
                        userInfo.submit = true;
                        userInfo.update();
                              onSubmit();
                            },
                      child: Text(
                        'Submit',
                        style: AllTextStyles.signikaText2(
                            size: 14.sp,
                            color: userInfo.submit == true
                                ? Colors.white
                                : AllColors.lightBlue2),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            userInfo.submit == true
                                ? AllColors.green
                                : Colors.white,
                          ),
                          minimumSize:
                              MaterialStateProperty.all(Size(80.w, 8.h)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ))),
                    ),
                    Spacer(),
                  ]),
            ),
          );
        }),
      ),
    );
  }
}

//     Get.dialog(
//         Scaffold(body:Center(
//           child: Container(
//             height: 60.h,
//             width: 90.w,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.w),
//                 border: Border.all(color: Color(0xff2F528F), width: 1.w)),
//             child:
//
//           ),
//         ),
// //         GetBuilder<UserInfoController>(
// //   builder: (userInfo) {
// //     return
// //   },
// // )
//         ));

// Widget _buildStar(int starCount, UserInfoController userInfo) {
//   return InkWell(
//     child: Icon(
//         (userInfo.star == 1
//                 ? userInfo.star >= starCount
//                 : userInfo.star > starCount)
//             ? Icons.star
//             : Icons.star_border_outlined,
//         size: 38,
//         color: Colors.yellow),
//     onTap: () {
//       userInfo.star = starCount;

//       userInfo.update();
//     },
//   );
// }

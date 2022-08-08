import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/controllers/user_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:store_redirect/store_redirect.dart';


import '../utils/utils.dart';

class RateUs extends StatelessWidget {
  final Function onSubmit;

  RateUs({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var con = Get.put<UserInfoController>(UserInfoController());
    con.submit = false;
    con.star = 0;
    con.update();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Feedback', style: AllTextStyles.settingsAppTitleInter()),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
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
                          style: AllTextStyles.signikaTextLarge(),
                          textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      AllStrings.rateText2,
                      style: AllTextStyles.signikaTextMedium(),
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
                      style: AllTextStyles.signikaTextMedium()
                          .copyWith(fontSize: 14.sp),
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
                          : () async {
                        userInfo.submit = true;
                        userInfo.update();
                        if (userInfo.star == 5) {
                          StoreRedirect.redirect(
                            androidAppId: "com.finshark",
                            //iOSAppId: "585027354"
                          );
                        }
                        var userId = Prefs.getString(PrefString.userId);
                        DocumentSnapshot snap = await firestore
                            .collection('User')
                            .doc(userId)
                            .get();
                        String level = snap.get('previous_session_info');
                        level = level.toString().substring(0, 7);
                        print('STATATA ${level}');
                        firestore
                            .collection('Feedback')
                            .doc(userId)
                            .set({
                          'user_id': userId,
                          if (level == 'Level_1')
                            'level_1_feedback': userInfo.feedbackCon.text,
                          if (level == 'Level_1')
                            'level_1_rating': userInfo.star,
                          if (level == 'Level_2')
                            'level_2_feedback': userInfo.feedbackCon.text,
                          if (level == 'Level_2')
                            'level_2_rating': userInfo.star,
                          if (level == 'Level_3')
                            'level_3_feedback': userInfo.feedbackCon.text,
                          if (level == 'Level_3')
                            'level_3_rating': userInfo.star,
                          if (level == 'Level_4')
                            'level_4_feedback': userInfo.feedbackCon.text,
                          if (level == 'Level_4')
                            'level_4_rating': userInfo.star,
                          if (level == 'Level_5')
                            'level_5_feedback': userInfo.feedbackCon.text,
                          if (level == 'Level_5')
                            'level_5_rating': userInfo.star,
                          if (level == 'Level_6')
                            'level_6_feedback': userInfo.feedbackCon.text,
                          if (level == 'Level_6')
                            'level_6_rating': userInfo.star,
                        }, SetOptions(merge: true)).then(
                              (v) => onSubmit(),
                        );

                        Get.back();
                      },
                      child: Text(
                        'Submit',
                        style: AllTextStyles.signikaTextMedium().copyWith(
                            fontSize: 14.sp,
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

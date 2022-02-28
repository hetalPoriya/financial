

import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/views/LevelFourAndFiveOptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class LevelFourSetUpPage extends StatefulWidget {
  const LevelFourSetUpPage({Key? key}) : super(key: key);

  @override
  _LevelFourSetUpPageState createState() => _LevelFourSetUpPageState();
}

class _LevelFourSetUpPageState extends State<LevelFourSetUpPage> {
  String text1 =
      'You\'ve just been promoted at your job and you\'ll now be earning \$2000 a month. ';
  String text2 =
      'Your goal in this level is to grow your savings by investing in Mutual Funds and Fixed Deposits. ';
  String text3 =
      'Your target is to get at least \$30k in your account so that you can use it as down payment to buy a new house!';

  @override
  Widget build(BuildContext context) {
    return SetUpPage(level: 'Level 4', levelText: 'Building Up', buttonText: 'Let’s Go', container:  Container(
      child: Padding(
        padding: EdgeInsets.only(right: 04.w, left: 04.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Congratulations!',
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                color: Color(0xff6448E8),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 17.sp,
              ),
            ),
            // SizedBox(
            //   height: 1.h,
            // ),
            Expanded(
                flex: 3,
                //fit: FlexFit.loose,
                child: Container(
                  alignment: Alignment.center,
                  //color: Colors.red,
                  child: Text(
                    text1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  //color: Colors.green,
                  child: Text(
                    text2,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                )),
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  //color: Colors.yellow,
                  child: Text(
                    text3,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(//color: Colors.red,
                )),
          ],
        ),
      ),
    ),
        onPressed: ()async{
          Get.off(
                () => LevelFourAndFiveOptions(),
            duration: Duration(milliseconds: 250),
            transition: Transition.downToUp,
          );
        },);

    //   SafeArea(
    //     child: Container(
    //   width: 100.w,
    //   height: 100.h,
    //   decoration: boxDecoration,
    //   child: Scaffold(
    //       backgroundColor: Colors.transparent,
    //       body: DoubleBackToCloseApp(
    //         snackBar: const SnackBar(
    //           content: Text('Tap back again to leave'),
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Spacer(),
    //             Center(
    //               child: Container(
    //                 height: 8.h,
    //                 width: 62.w,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(14.w),
    //                   color: Color(0xffEF645B),
    //                 ),
    //                 child: Center(
    //                     child: Text(
    //                   'Level 4',
    //                   style: GoogleFonts.workSans(
    //                       color: Colors.white,
    //                       fontSize: 20.sp,
    //                       fontWeight: FontWeight.w600),
    //                 )),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 4.h,
    //             ),
    //             Text(
    //               'Building Up',
    //               style: GoogleFonts.workSans(
    //                   fontSize: 28.sp,
    //                   fontWeight: FontWeight.w600,
    //                   color: Colors.white),
    //             ),
    //             SizedBox(
    //               height: 3.h,
    //             ),
    //             Container(
    //               alignment: Alignment.center,
    //               width: 80.w,
    //               height: 48.h,
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(9.w)),
    //               child: Stack(
    //                 children: [
    //                   Positioned(
    //                       bottom: 00,
    //                       right: 00,
    //                       child: Image.asset(
    //                         'assets/mastGroup.png',
    //                         width: 32.h,
    //                         alignment: Alignment.bottomRight,
    //                       )),
    //                   Container(
    //                     child: Padding(
    //                       padding: EdgeInsets.only(right: 04.w, left: 04.w),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           SizedBox(
    //                             height: 3.h,
    //                           ),
    //                           Text(
    //                             'Congratulations!',
    //                             textAlign: TextAlign.center,
    //                             style: GoogleFonts.workSans(
    //                               color: Color(0xff6448E8),
    //                               fontWeight: FontWeight.w600,
    //                               fontStyle: FontStyle.normal,
    //                               fontSize: 17.sp,
    //                             ),
    //                           ),
    //                           // SizedBox(
    //                           //   height: 1.h,
    //                           // ),
    //                           Expanded(
    //                               flex: 3,
    //                               //fit: FlexFit.loose,
    //                               child: Container(
    //                                 alignment: Alignment.center,
    //                                  //color: Colors.red,
    //                                 child: Text(
    //                                   text1,
    //                                   textAlign: TextAlign.center,
    //                                   style: GoogleFonts.workSans(
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 14.sp,
    //                                   ),
    //                                 ),
    //                               )),
    //                           Expanded(
    //                               flex: 2,
    //                               child: Container(
    //                                 alignment: Alignment.center,
    //                                //color: Colors.green,
    //                                 child: Text(
    //                                   text2,
    //                                   textAlign: TextAlign.center,
    //                                   style: GoogleFonts.workSans(
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.w400,
    //                                     fontSize: 12.sp,
    //                                   ),
    //                                 ),
    //                               )),
    //                           Expanded(
    //                               flex: 3,
    //                               child: Container(
    //                                 alignment: Alignment.center,
    //                                 //color: Colors.yellow,
    //                                 child: Text(
    //                                   text3,
    //                                   textAlign: TextAlign.center,
    //                                   style: GoogleFonts.workSans(
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 12.sp,
    //                                   ),
    //                                 ),
    //                               )),
    //                           Expanded(
    //                               flex: 2,
    //                               child: Container(//color: Colors.red,
    //                                   )),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Spacer(),
    //             Container(
    //               height: 8.h,
    //               width: 80.w,
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(12.w)),
    //               child: TextButton(
    //                 onPressed: () async {
    //                   Get.off(
    //                     () => LevelFourOptionsPage(),
    //                     duration: Duration(milliseconds: 250),
    //                     transition: Transition.downToUp,
    //                   );
    //                 },
    //                 child: GradientText(
    //                     text: 'Let’s Go',
    //                     style: GoogleFonts.workSans(
    //                         fontSize: 16.sp,
    //                         fontWeight: FontWeight.w500,
    //                         color: Colors.white),
    //                     gradient: const LinearGradient(
    //                         colors: [Colors.white, Color(0xff6D00C2)],
    //                         transform: GradientRotation(math.pi / 2))),
    //               ),
    //             ),
    //             Spacer(),
    //           ],
    //         ),
    //       )),
    // ));
  }
}

//ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:financial/views/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class GameScorePage extends StatefulWidget {
  var document;
  String level = '';

  GameScorePage({Key? key, this.document, required this.level})
      : super(key: key);

  @override
  _GameScorePageState createState() => _GameScorePageState();
}

class _GameScorePageState extends State<GameScorePage> {
  //to get user state value
  var userId;
  String? level;

  int? _gameSco;

  getUserValue() async {
    //  SharedPreferences pref = await SharedPreferences.getInstance();
    userId = GetStorage().read('uId');
    DocumentSnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();
    setState(() {
      //_gameSco = querySnapshot.get('game_score');
      level = querySnapshot.get('previous_session_info');
    });
  }

  @override
  void initState() {
    getUserValue();
    //  level = widget.level;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SizedBox(
        //   height: forPortrait * .08,
        // ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 17.w,
                width: 56.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 17.w,
                      width: 14.w,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Container(
                            child: Image.asset(
                          'assets/star.png',
                          width: 10.w,
                          height: 6.h,
                          fit: BoxFit.contain,
                        )),
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: 17.w,
                        width: 42.w,
                        //  color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 1.w,),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Text('GAME SCORE',
                                    style: GoogleFonts.workSans(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.sp,
                                      color: Color(0xff3D2F91),
                                    ),
                                    maxLines: 1),
                                alignment: Alignment.center,
                              ),
                            ),
                            _gameScore(),
                            SizedBox(height: 1.w,),
                          ],
                        )),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.w, right: 8.w),
                child: GestureDetector(
                    onTap: () async {
                      Get.to(() => ProfilePage());
                      // Get.off(() => ProfilePage(),
                      // duration:Duration(milliseconds: 500),
                      // transition: Transition.downToUp,
                      // );
                    },
                    child: Image.asset(
                      'assets/settings.png',
                      width: 8.w,
                      fit: BoxFit.contain,
                    )),
              ),
            ],
          ),
        ),
        if (level == 'Level_2_Pop_Quiz' && level == 'Level_3_Pop_Quiz')
          Padding(
              padding: EdgeInsets.only(
            top: 0.h,
          )),

        if ((level == "Level_1" || level == "") &&
            widget.document['card_type'] == 'GameQuestion')
          Padding(
              padding: EdgeInsets.only(
                top: 2.h,
              ),
              child: widget.document['day'] == 0
                  ? _text('DAY 1/7')
                  : _text('DAY ' + widget.document['day'].toString() + '/7')),

        if ((level == "Level_2" || level == 'Level_3') &&
            (widget.document.toString() == 'GameQuestion' ||
                widget.document['card_type'] == 'GameQuestion'))
          Padding(
              padding: EdgeInsets.only(
                top: 2.h,
              ),
              child: widget.document.toString() == 'GameQuestion' ||
                      widget.document['week'] == null
                  ? _text('WEEK 1/24')
                  : _text(
                      'WEEK ' + widget.document['week'].toString() + '/24')),

        if ((level == "Level_4" || level == "Level_5") &&
            widget.document['card_type'] == 'GameQuestion')
          Padding(
              padding: EdgeInsets.only(
                top: 2.h,
              ),
              child: widget.document['month'] == 0
                  ? _text('MONTH 1/30')
                  : _text(
                  'MONTH ' + widget.document['month'].toString() + '/30')),


      ],
    );
  }

  _gameScore() {
    return Expanded(
      flex: 2,
      child: Container(
        alignment: Alignment.center,
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore
              .collection('User')
              .doc(userId)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.hasError) {
              return Text('It\'s Error!');
            }
            if (!streamSnapshot.hasData ||
                !streamSnapshot.data!.exists)
              return Center(
                child: SizedBox(
                  height: 1.h,
                  width: 1.w,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white12,
                    color: Colors.white12,
                  ),
                ),
              );
            //  switch (streamSnapshot.connectionState) {
            //    case ConnectionState.waiting:
            // return Center(
            //   child: SizedBox(
            //     height: displayHeight(context) * .05,
            //     width: displayWidth(context) * .08,
            //     child: CircularProgressIndicator(
            //       backgroundColor: Colors.white12,
            //       color: Colors.white12,
            //     ),
            //   ),
            // );
            //default:
            return FittedBox(
              child: Padding(
                padding: EdgeInsets.only(right: 5.w,left: 2.w),
                child: GradientText(
                    text:
                    '${'${streamSnapshot.data!['game_score'].toString()}'}'
                        .toString(),
                    style:
                    GoogleFonts.robotoCondensed(
                        fontSize: 26.sp,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white),
                    gradient: const LinearGradient(
                        colors: [
                          Color(0xff4D5DDD),
                          Color(0xff6D00C2)
                        ],
                        transform: GradientRotation(
                            math.pi / 2))),
              ),
            );
            // }
          },
        ),
      ),
    );
  }

  Widget _text(String text) => Text(
        text,
        style: GoogleFonts.workSans(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      );
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:financial/ReusableScreen/GlobleVariable.dart';
// import 'package:financial/ReusableScreen/GradientText.dart';
// import 'package:financial/views/ProfilePage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'dart:math'as math;
//
// class GameScorePage extends StatefulWidget {
//   var document;
//   String level = '';
//
//   GameScorePage({Key? key, this.document, required this.level})
//       : super(key: key);
//
//   @override
//   _GameScorePageState createState() => _GameScorePageState();
// }
//
// class _GameScorePageState extends State<GameScorePage> {
//   //to get user state value
//   var userId;
//   String? level;
//
//   int? _gameSco;
//
//   getUserValue() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     userId = pref.getString('uId');
//     DocumentSnapshot querySnapshot =
//     await FirebaseFirestore.instance.collection("User").doc(userId).get();
//     setState(() {
//       _gameSco = querySnapshot.get('game_score');
//       level = querySnapshot.get('previous_session_info');
//     });
//   }
//
//   @override
//   void initState() {
//     getUserValue();
//     //  level = widget.level;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // SizedBox(
//         //   height: forPortrait * .08,
//         // ),
//         Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: 17.w,
//                 width: 56.w,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.w),
//                     color: Colors.white),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 4.w),
//                       child: Container(
//                           child: Image.asset(
//                             'assets/star.png',
//                             width: 10.w,
//                             fit: BoxFit.contain,
//                           )),
//                     ),
//                     Spacer(),
//                     Padding(
//                       padding: EdgeInsets.only(right: 1.w),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Spacer(),
//                           Text('GAME SCORE',
//                               style: GoogleFonts.workSans(
//                                   fontWeight: FontWeight.w500,
//                                   fontStyle: FontStyle.normal,
//                                   fontSize: 12.sp,
//                                   color: Color(0xff3D2F91))),
//                           Spacer(),
//                           _gameScore(),
//                           Spacer(),
//                         ],
//                       ),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left:6.w, right: 8.w),
//                 child: GestureDetector(
//                     onTap: () async {
//                       Get.to(() => ProfilePage());
//                       // Get.off(() => ProfilePage(),
//                       // duration:Duration(milliseconds: 500),
//                       // transition: Transition.downToUp,
//                       // );
//                     },
//                     child: Image.asset(
//                       'assets/settings.png',
//                       width: 8.w,
//                       fit: BoxFit.contain,
//                     )),
//               ),
//             ],
//           ),
//         ),
//         if (level == 'Level_2_Pop_Quiz' && level == 'Level_3_Pop_Quiz')
//           Padding(
//               padding: EdgeInsets.only(
//                 top: 0.h,
//               )),
//         if ((level == "Level_1" || level == "") &&
//             widget.document.card_type == 'GameQuestion')
//           Padding(
//               padding: EdgeInsets.only(
//                 top: 2.h,
//               ),
//               child: widget.document.day == 0
//                   ? Text(
//                 'DAY 1/7',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               )
//                   : Text(
//                 'DAY ' + widget.document.day.toString() + '/7',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )),
//
//         if ((level == "Level_2" || level == 'Level_3' || level == 'Level_4') &&
//             (widget.document.toString() == 'GameQuestion' ||
//                 widget.document.card_type == 'GameQuestion'))
//           Padding(
//               padding: EdgeInsets.only(
//                 top: 2.h,
//               ),
//               child: widget.document.toString() == 'GameQuestion'
//                   ? level == 'Level_4'
//                   ? Text(
//                 'MONTH 1/60',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )
//                   : Text(
//                 'WEEK 1/24',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )
//                   : level == 'Level_4'
//                   ? widget.document.month == null
//                   ? Text(
//                 'MONTH 1/60',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )
//                   : Text(
//                 'MONTH ' + widget.document.month.toString() + '/60',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )
//                   : widget.document.week == null
//                   ? Text(
//                 'WEEK 1/24',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )
//                   : Text(
//                 'WEEK ' +
//                     widget.document.week.toString() + '/24',
//                 style: GoogleFonts.workSans(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               )),
//       ],
//     );
//   }
//
//   _gameScore() {
//     return _gameSco.toString().isEmpty
//         ? Center(
//       child: SizedBox(
//         height: 5.h,
//         width: 8.w,
//         child: CircularProgressIndicator(
//           backgroundColor: Colors.white12,
//           color: Color(0xff5978f3),
//         ),
//       ),
//     )
//         : Padding(
//       padding: EdgeInsets.only(right: 2.w),
//       child: Container(
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: firestore.collection('User').doc(userId).snapshots(),
//           builder: (context, streamSnapshot) {
//             if (streamSnapshot.hasError) {
//               return Text('It\'s Error!');
//             }
//             if (!streamSnapshot.hasData || !streamSnapshot.data!.exists)
//               return Center(
//                 child: SizedBox(
//                   height: 5.h,
//                   width: 8.w,
//                   child: CircularProgressIndicator(
//                     backgroundColor: Colors.white12,
//                     color: Colors.white12,
//                   ),
//                 ),
//               );
//             //  switch (streamSnapshot.connectionState) {
//             //    case ConnectionState.waiting:
//             // return Center(
//             //   child: SizedBox(
//             //     height: displayHeight(context) * .05,
//             //     width: displayWidth(context) * .08,
//             //     child: CircularProgressIndicator(
//             //       backgroundColor: Colors.white12,
//             //       color: Colors.white12,
//             //     ),
//             //   ),
//             // );
//             //default:
//             return Container(
//               child: GradientText(
//                   text: '${'${streamSnapshot.data!['game_score']}'}'
//                       .toString(),
//                   style: GoogleFonts.robotoCondensed(
//                       fontSize: 26.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white),
//                   gradient: const LinearGradient(
//                       colors: [Color(0xff4D5DDD), Color(0xff6D00C2)],
//                       transform: GradientRotation(math.pi / 2))),
//             );
//             // }
//           },
//         ),
//       ),
//     );
//   }
// }

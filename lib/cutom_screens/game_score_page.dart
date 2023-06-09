//ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/views/profile/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../utils/utils.dart';
import 'custom_screens.dart';

class GameScorePage extends StatefulWidget {
  var document;
  final String level;
  final bool? pointValue;
  GlobalKey? keyValue = GlobalKey();

  GameScorePage(
      {Key? key,
      this.document,
      required this.level,
      this.keyValue,
      this.pointValue})
      : super(key: key);

  @override
  _GameScorePageState createState() => _GameScorePageState();
}

class _GameScorePageState extends State<GameScorePage> {
  //to get user state value
  var userId;
  String? level;
  int? levelId;
  bool? showCase;
  int? showCaseId;

  getUserValue() async {
    userId =Prefs.getString(PrefString.userId);
    DocumentSnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();
    setState(() {
      //_gameSco = querySnapshot.get('game_score');
      level = querySnapshot.get('previous_session_info');
      levelId = querySnapshot.get('level_id');
    });
  }

  @override
  void initState() {
    getUserValue();
    showCaseId = Prefs.getInt(PrefString.showCaseId);
    showCase = Prefs.getBool(PrefString.showCase);
    (showCase == false && showCaseId == 0 && level == 'Level_1')
        ? WidgetsBinding.instance.addPostFrameCallback((_) async {
            ShowCaseWidget.of(context).startShowCase([widget.keyValue!]);
            await Prefs.setInt(PrefString.showCaseId,1);

          })
        : null;
    super.initState();
  }

  bool? popQuiz;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: forPortrait * .08,
          // ),

          StreamBuilder<DocumentSnapshot>(
            stream: firestore.collection('User').doc(userId).snapshots(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Text('It\'s Error!');
              }
              if (!streamSnapshot.hasData || !streamSnapshot.data!.exists)
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
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 8.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.w),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 8.h,
                            width: 14.w,
                            // color: AllColors.red,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: ((streamSnapshot.data
                                                    ?.data()
                                                    .toString()
                                                    .contains(
                                                        'pop_quiz_point_changed') ==
                                                true) &&
                                            streamSnapshot.data![
                                                    'pop_quiz_point_changed'] ==
                                                true)
                                        ? 1.w
                                        : 3.w),
                                child: Container(
                                  child: Image.asset(
                                    ((streamSnapshot.data
                                                    ?.data()
                                                    .toString()
                                                    .contains(
                                                        'pop_quiz_point_changed') ==
                                                true) &&
                                            streamSnapshot.data![
                                                    'pop_quiz_point_changed'] ==
                                                true)
                                        ? AllImages.gifForPopQuiz
                                        : AllImages.star,
                                    width:
                                        //14.w,
                                        10.w,
                                    height:
                                        //17.w,
                                        6.h,
                                    fit: BoxFit.contain,
                                    //color: Colors.white,
                                  ),
                                  // child: StreamBuilder<DocumentSnapshot>(
                                  //   stream: firestore
                                  //       .collection('User')
                                  //       .doc(userId)
                                  //       .snapshots(),
                                  //   builder: (context, streamSnapshot) {
                                  //     if (streamSnapshot.hasError) {
                                  //       return Text('It\'s Error!');
                                  //     }
                                  //     if (!streamSnapshot.hasData ||
                                  //         !streamSnapshot.data!.exists)
                                  //       return Center(
                                  //         child: SizedBox(
                                  //           height: 1.h,
                                  //           width: 1.w,
                                  //           child: CircularProgressIndicator(
                                  //             backgroundColor: Colors.white12,
                                  //             color: Colors.white12,
                                  //           ),
                                  //         ),
                                  //       );
                                  //
                                  //     return FittedBox(
                                  //       child: Image.asset(
                                  //         streamSnapshot.data!['pop_quiz_point_changed'] == true
                                  //             ? AllImages.starGif
                                  //             : AllImages.star,
                                  //         // width:   (popQuizPointChanges == true) ? 14.w :10.w,
                                  //         // height: (popQuizPointChanges == true) ? 17.w : 6.h,
                                  //         fit: BoxFit.fitWidth,
                                  //       ),
                                  //     );
                                  //     // }
                                  //   },
                                  // ),
                                )),
                          ),
                          Spacer(),
                          Container(
                              height: 8.h,
                              width: 42.w,
                              //  color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 1.w,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: FittedBox(
                                        child: Text('GAME SCORE',
                                            style: AllTextStyles
                                                    .workSansExtraSmall()
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AllColors
                                                        .extraDarkPurple),
                                            maxLines: 1),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5.w, left: 2.w),
                                        child: GradientText(
                                            text:
                                                '${'${streamSnapshot.data!['game_score'].toString()}'}'
                                                    .toString(),
                                            style:
                                                AllTextStyles.robotoCondensed(),
                                            gradient: LinearGradient(
                                                colors: [
                                                  AllColors.darkBlue,
                                                  AllColors.darkPink
                                                ],
                                                transform: GradientRotation(
                                                    math.pi / 2))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.w,
                                  ),
                                ],
                              )),
                          Spacer(),
                        ],
                      ),
                    ),
                    (level == 'Level_1' && levelId == 0)
                        ? Showcase(
                            description: AllStrings.showCaseProfilePageText,
                            descTextStyle: AllTextStyles.workSansSmallBlack()
                                .copyWith(fontSize: 12.sp),
                            animationDuration: Duration(milliseconds: 500),
                            key: widget.keyValue!,
                            child: Padding(
                              padding: EdgeInsets.only(left: 6.w, right: 8.w),
                              child: GestureDetector(
                                  onTap: () async {
                                    DocumentSnapshot doc =
                                        await FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(userId)
                                            .get();
                                    Object? map = doc.data();
                                    if (map.toString().contains('user_name')) {
                                      Get.to(
                                        () => SettingsPage(),
                                        duration: Duration(milliseconds: 500),
                                        transition: Transition.downToUp,
                                      );
                                    } else {
                                      firestore
                                          .collection('User')
                                          .doc(userId)
                                          .set({
                                        'user_name': ''
                                      }, SetOptions(merge: true)).then(
                                              (value) => Get.to(
                                                    () => SettingsPage(),
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    transition:
                                                        Transition.downToUp,
                                                  ));
                                    }
                                  },
                                  child: Image.asset(
                                    AllImages.profileThreeLine,
                                    width: 6.w,
                                    height: 15.w,
                                    fit: BoxFit.contain,
                                  )),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 6.w, right: 8.w),
                            child: GestureDetector(
                                onTap: () async {
                                  Get.to(() => SettingsPage());
                                },
                                child: Image.asset(
                                  AllImages.profileThreeLine,
                                  width: 6.w,
                                  height: 15.w,
                                  fit: BoxFit.contain,
                                )),
                          ),
                  ],
                ),
              );
              // popQuiz= streamSnapshot.data!['pop_quiz_point_changed'];
              // return FittedBox(
              //   child: Padding(
              //     padding: EdgeInsets.only(right: 5.w, left: 2.w),
              //     child: GradientText(
              //         text:
              //             '${'${streamSnapshot.data!['game_score'].toString()}'}'
              //                 .toString(),
              //         style: AllTextStyles.gameScore(),
              //         gradient: LinearGradient(
              //             colors: [AllColors.darkBlue, AllColors.darkPink],
              //             transform: GradientRotation(math.pi / 2))),
              //   ),
              // );
              // }
            },
          ),
          // if (level == 'Level_2_Pop_Quiz' && level == 'Level_3_Pop_Quiz')
          //   Padding(
          //       padding: EdgeInsets.only(
          //         top: 0.h,
          //       )),
          //
          // if ((level == "Level_1" || level == "") &&
          //     document['card_type'] == 'GameQuestion')
          //   document['day'] == 0
          //       ? _text('DAY 1/7')
          //       : _text('DAY ' + document['day'].toString() + '/7'),
          //
          // if ((level == "Level_2" || level == 'Level_3') &&
          //     (document.toString() == 'GameQuestion' ||
          //         document['card_type'] == 'GameQuestion'))
          //   document.toString() == 'GameQuestion' ||
          //       document['week'] == null
          //       ? _text('WEEK 1/24')
          //       : _text(
          //       'WEEK ' + document['week'].toString() + '/24'),
          //
          // if ((level == "Level_4" || level == "Level_5") &&
          //     document['card_type'] == 'GameQuestion')
          //   document['month'] == 0
          //       ? _text('MONTH 1/30')
          //       : _text('MONTH ' +
          //       document['month'].toString() +
          //       '/30'),
        ],
      ),
    );
  }

  // Widget _text(String text) => Text(
  //       text,
  //       style: AllTextStyles.workSansLarge(),
  //       textAlign: TextAlign.center,
  //     );
// gameScore() {
//   return Expanded(
//     flex: 2,
//     child: Container(
//       alignment: Alignment.center,
//       child: StreamBuilder<DocumentSnapshot>(
//         stream: firestore.collection('User').doc(userId).snapshots(),
//         builder: (context, streamSnapshot) {
//           if (streamSnapshot.hasError) {
//             return Text('It\'s Error!');
//           }
//           if (!streamSnapshot.hasData || !streamSnapshot.data!.exists)
//             return Center(
//               child: SizedBox(
//                 height: 1.h,
//                 width: 1.w,
//                 child: CircularProgressIndicator(
//                   backgroundColor: Colors.white12,
//                   color: Colors.white12,
//                 ),
//               ),
//             );
//           // popQuiz= streamSnapshot.data!['pop_quiz_point_changed'];
//           // return FittedBox(
//           //   child: Padding(
//           //     padding: EdgeInsets.only(right: 5.w, left: 2.w),
//           //     child: GradientText(
//           //         text:
//           //             '${'${streamSnapshot.data!['game_score'].toString()}'}'
//           //                 .toString(),
//           //         style: AllTextStyles.gameScore(),
//           //         gradient: LinearGradient(
//           //             colors: [AllColors.darkBlue, AllColors.darkPink],
//           //             transform: GradientRotation(math.pi / 2))),
//           //   ),
//           // );
//           // }
//         },
//       ),
//     ),
//   );
// }

}

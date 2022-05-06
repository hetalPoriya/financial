//ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class GameScorePage extends StatefulWidget {
  var document;
  final String level;
  GlobalKey? keyValue = GlobalKey();

  GameScorePage({Key? key, this.document, required this.level, this.keyValue})
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
    userId = GetStorage().read('uId');
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
    showCaseId = GetStorage().read('showCaseId');
    showCase = GetStorage().read('showCase');
    (showCase == false && showCaseId == 0 && level == 'Level_1')
        ? WidgetsBinding.instance?.addPostFrameCallback((_) async {
            ShowCaseWidget.of(context)!.startShowCase([widget.keyValue!]);
            GetStorage().write('showCaseId', 1);
          })
        : null;
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
                          AllImages.star,
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
                            SizedBox(
                              height: 1.w,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Text('GAME SCORE',
                                    style:AllTextStyles.dialogStyleSmall(fontWeight: FontWeight.w500,color:AllColors.extraDarkPurple ),
                                    maxLines: 1),
                                alignment: Alignment.center,
                              ),
                            ),
                            gameScore(),
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
                      descTextStyle: AllTextStyles.workSansSmall(fontSize: 12.sp),
                      animationDuration: Duration(milliseconds: 500),
                      key: widget.keyValue!,
                      child: Padding(
                        padding: EdgeInsets.only(left: 6.w, right: 8.w),
                        child: GestureDetector(
                            onTap: () async {
                              DocumentSnapshot doc = await FirebaseFirestore
                                  .instance
                                  .collection('User')
                                  .doc(userId)
                                  .get();
                              Object? map = doc.data();
                              if (map.toString().contains('user_name')) {
                                Get.to(
                                  () => ProfilePage(),
                                  duration: Duration(milliseconds: 500),
                                  transition: Transition.downToUp,
                                );
                              } else {
                                firestore.collection('User').doc(userId).set(
                                    {'user_name': ''},
                                    SetOptions(
                                        merge: true)).then((value) => Get.to(
                                      () => ProfilePage(),
                                      duration: Duration(milliseconds: 500),
                                      transition: Transition.downToUp,
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
                            Get.to(() => ProfilePage());
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

  gameScore() {
    return Expanded(
      flex: 2,
      child: Container(
        alignment: Alignment.center,
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('User').doc(userId).snapshots(),
          builder: (context, streamSnapshot) {
            // firestore.collection('Game_score').doc(userId).set(
            //     {'game_score': streamSnapshot.data?['game_score']},
            //     SetOptions(merge: true));
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
                padding: EdgeInsets.only(right: 5.w, left: 2.w),
                child: GradientText(
                    text:
                        '${'${streamSnapshot.data!['game_score'].toString()}'}'
                            .toString(),
                    style: AllTextStyles.gameScore(),
                    gradient:  LinearGradient(
                        colors: [AllColors.darkBlue, AllColors.darkPink],
                        transform: GradientRotation(math.pi / 2))),
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
        style: AllTextStyles.dialogStyleLarge(),
        textAlign: TextAlign.center,
      );
}

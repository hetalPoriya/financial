import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/game_score_page.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/models/que_model.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/coming_soon.dart';
import 'package:financial/views/level_four_setUp_page.dart';
import 'package:financial/views/level_three_setUp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import 'local_notify_manager.dart';

class PopQuiz extends StatefulWidget {
  PopQuiz({
    Key? key,
  }) : super(key: key);

  @override
  _PopQuizState createState() => _PopQuizState();
}

class _PopQuizState extends State<PopQuiz> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  var document;
  final getCredential = GetStorage();
  int gameScore = 0;
  String level = '';
  int levelId = 0;
  var userId;
  Color color1 = Colors.white;
  Color color2 = Colors.white;
  Color color3 = Colors.white;
  Color color4 = Colors.white;

  //for model
  QueModel? queModel;
  List<QueModel> list = [];
  String? popQuiz;

  //page controller
  PageController controller = PageController();

  Future<QueModel?> getLevelId() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // userId = pref.getString('uId');
    userId = getCredential.read('uId');
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    popQuiz = snap.get('previous_session_info');
    levelId = snap.get('level_id');
    controller = PageController(initialPage: levelId);

    QuerySnapshot querySnapshot;
    if (popQuiz == 'Level_2_Pop_Quiz') {
      querySnapshot = await firestore.collection("Level_2_Pop_Quiz").get();
    } else if (popQuiz == 'Level_3_Pop_Quiz') {
      querySnapshot = await firestore.collection("Level_3_Pop_Quiz").get();
    } else {
      querySnapshot = await firestore.collection("Level_4_Pop_Quiz").get();
    }
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      queModel = QueModel();
      queModel?.id = a['id'];
      setState(() {
        list.add(queModel!);
      });
    }

    return null;
  }

  static Future<int> totalUsers() async {
    var userId = GetStorage().read('uId');
    final collection =
        FirebaseFirestore.instance.collection('User').snapshots();
    print('Collection ${collection.length}');
    DocumentSnapshot documentSnapshot = await firestore
        .collection('Pop_Quiz_Calculation')
        .doc('Level2Question1')
        .get();
    var arr = documentSnapshot['ans_a_all_user'];
    arr.toString().contains('${userId.toString()}');
    print('aaa ${arr.toString().contains('${userId.toString()}')}');
    return collection.length;
  }

  @override
  void initState() {
    super.initState();
    totalUsers();
    getLevelId();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: boxDecoration,
        child: list.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator(backgroundColor: AllColors.blue))
            : StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection(popQuiz == 'Level_2_Pop_Quiz'
                        ? 'Level_2_Pop_Quiz'
                        : popQuiz == 'Level_3_Pop_Quiz'
                            ? 'Level_3_Pop_Quiz'
                            : 'Level_4_Pop_Quiz')
                    .orderBy('id')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('It\'s Error!');
                  }
                  if (!snapshot.hasData)
                    return Container(
                      decoration: boxDecoration,
                      child: Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                              backgroundColor: AllColors.blue),
                        ),
                      ),
                    );
                  // switch (snapshot.connectionState) {
                  //   case ConnectionState.waiting:
                  //   // return Container(
                  //   //   decoration: boxDecoration,
                  //   //   child: Center(
                  //   //     child: SizedBox(
                  //   //       child: CircularProgressIndicator(
                  //   //         color: Colors.black,
                  //   //       ),
                  //   //     ),
                  //   //   ),
                  //   // );
                  //   default:
                  return PageView.builder(
                      itemCount: snapshot.data?.docs.length,
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (value) {},
                      itemBuilder: (context, index) {
                        document = snapshot.data?.docs[index];
                        return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: DoubleBackToCloseApp(
                              snackBar: SnackBar(
                                content: Text(AllStrings.tapBack),
                              ),
                              child: Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: boxDecoration,
                                child: Column(
                                  children: [
                                    Spacer(),
                                    GameScorePage(level: level),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Transform(
                                      alignment: FractionalOffset.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(pi * _animation.value),
                                      child: _animation.value <= 0.5
                                          ? Container(
                                              alignment: Alignment.center,
                                              width: 80.w,
                                              height: 62.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    6.w,
                                                  ),
                                                  color: Colors.white),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 1.h,
                                                        left: 5.w,
                                                        right: 5.w,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          document[
                                                              'description'],
                                                          style: AllTextStyles
                                                              .workSansMediumBlack(),
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                      ),
                                                    ),
                                                    StatefulBuilder(builder:
                                                        (context, _setState) {
                                                      String ans = document[
                                                          'correct_ans'];
                                                      return Column(
                                                        children: [
                                                          options(
                                                            onPressed: () {
                                                              _checkCorrectAnswer(
                                                                  ans,
                                                                  _setState,
                                                                  document,
                                                                  index,
                                                                  1);
                                                            },
                                                            index: index,
                                                            document: document,
                                                            color: color1,
                                                            i: 1,
                                                            text: document[
                                                                'option_1'],
                                                          ),
                                                          options(
                                                            onPressed: () {
                                                              _checkCorrectAnswer(
                                                                  ans,
                                                                  _setState,
                                                                  document,
                                                                  index,
                                                                  2);
                                                            },
                                                            index: index,
                                                            document: document,
                                                            color: color2,
                                                            i: 2,
                                                            text: document[
                                                                'option_2'],
                                                          ),
                                                          if (popQuiz ==
                                                                  'Level_2_Pop_Quiz' ||
                                                              popQuiz ==
                                                                  'Level_3_Pop_Quiz')
                                                            options(
                                                              onPressed: () {
                                                                _checkCorrectAnswer(
                                                                    ans,
                                                                    _setState,
                                                                    document,
                                                                    index,
                                                                    3);
                                                              },
                                                              index: index,
                                                              document:
                                                                  document,
                                                              color: color3,
                                                              i: 3,
                                                              text: document[
                                                                  'option_3'],
                                                            ),
                                                          if (popQuiz ==
                                                                  'Level_2_Pop_Quiz' ||
                                                              popQuiz ==
                                                                  'Level_3_Pop_Quiz')
                                                            options(
                                                              onPressed: () {
                                                                _checkCorrectAnswer(
                                                                    ans,
                                                                    _setState,
                                                                    document,
                                                                    index,
                                                                    4);
                                                              },
                                                              index: index,
                                                              document:
                                                                  document,
                                                              color: color4,
                                                              i: 4,
                                                              text: document[
                                                                  'option_4'],
                                                            ),
                                                          // Padding(
                                                          //     padding: EdgeInsets
                                                          //         .only(
                                                          //         top: 3.h),
                                                          //     child:
                                                          //     GestureDetector(
                                                          //       onTap: () {
                                                          //         // list[index].isSelected1 == true ||
                                                          //         //         list[index].isSelected2 ==
                                                          //         //             true ||
                                                          //         //         list[index].isSelected3 ==
                                                          //         //             true ||
                                                          //         //         list[index].isSelected4 ==
                                                          //         //             true
                                                          //         //     ?
                                                          //         //_flipCard();// :
                                                          //         _checkCorrectAnswer(
                                                          //             ans,
                                                          //             _setState,
                                                          //             document,
                                                          //             index,
                                                          //             1);
                                                          //       },
                                                          //       child:
                                                          //       Container(
                                                          //         alignment:
                                                          //         Alignment
                                                          //             .centerLeft,
                                                          //         width: 70.w,
                                                          //         height: 7.h,
                                                          //         decoration: BoxDecoration(
                                                          //             color: list[index]
                                                          //                 .isSelected1 ==
                                                          //                 true
                                                          //                 ? color1
                                                          //                 : Color(
                                                          //                 AllColors.whiteLight2),
                                                          //             borderRadius:
                                                          //             BorderRadius
                                                          //                 .circular(
                                                          //                 3.w)),
                                                          //         child:
                                                          //         SingleChildScrollView(
                                                          //           child:
                                                          //           Padding(
                                                          //             padding: EdgeInsets
                                                          //                 .symmetric(
                                                          //                 horizontal: 4
                                                          //                     .w,
                                                          //                 vertical:
                                                          //                 1.w),
                                                          //             child:
                                                          //             Text(
                                                          //               document[
                                                          //               'option_1'],
                                                          //               style: GoogleFonts
                                                          //                   .workSans(
                                                          //                   color: list[index]
                                                          //                       .isSelected1 ==
                                                          //                       true
                                                          //                       ? Colors
                                                          //                       .white
                                                          //                       : Color(
                                                          //                       AllColors.extraDarkPurple),
                                                          //                   fontWeight: FontWeight
                                                          //                       .w500,
                                                          //                   fontSize: 14
                                                          //                       .sp),
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //     )),
                                                          // Padding(
                                                          //     padding: EdgeInsets
                                                          //         .only(
                                                          //         top: 1.h),
                                                          //     child:
                                                          //     GestureDetector(
                                                          //       onTap: () {
                                                          //         _checkCorrectAnswer(
                                                          //             ans,
                                                          //             _setState,
                                                          //             document,
                                                          //             index,
                                                          //             2);
                                                          //       },
                                                          //       child:
                                                          //       Container(
                                                          //         alignment:
                                                          //         Alignment
                                                          //             .centerLeft,
                                                          //         width: 70.w,
                                                          //         height: 7.h,
                                                          //         decoration: BoxDecoration(
                                                          //             color: list[index]
                                                          //                 .isSelected2 ==
                                                          //                 true
                                                          //                 ? color2
                                                          //                 : Color(
                                                          //                 AllColors.whiteLight2),
                                                          //             borderRadius:
                                                          //             BorderRadius
                                                          //                 .circular(
                                                          //                 3.w)),
                                                          //         child:
                                                          //         SingleChildScrollView(
                                                          //           child:
                                                          //           Padding(
                                                          //             padding: EdgeInsets
                                                          //                 .symmetric(
                                                          //                 horizontal: 4
                                                          //                     .w,
                                                          //                 vertical:
                                                          //                 1.w),
                                                          //             child:
                                                          //             Text(
                                                          //               document[
                                                          //               'option_2'],
                                                          //               style: GoogleFonts
                                                          //                   .workSans(
                                                          //                   color: list[index]
                                                          //                       .isSelected2 ==
                                                          //                       true
                                                          //                       ? Colors
                                                          //                       .white
                                                          //                       : Color(
                                                          //                       AllColors.extraDarkPurple),
                                                          //                   fontWeight: FontWeight
                                                          //                       .w500,
                                                          //                   fontSize: 14
                                                          //                       .sp),
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //     )),
                                                          // Padding(
                                                          //     padding: EdgeInsets
                                                          //         .only(
                                                          //         top: 1.h),
                                                          //     child:
                                                          //     GestureDetector(
                                                          //       onTap: () {
                                                          //         _checkCorrectAnswer(
                                                          //             ans,
                                                          //             _setState,
                                                          //             document,
                                                          //             index,
                                                          //             3);
                                                          //       },
                                                          //       child:
                                                          //       Container(
                                                          //         alignment:
                                                          //         Alignment
                                                          //             .centerLeft,
                                                          //         width: 70.w,
                                                          //         height: 7.h,
                                                          //         decoration: BoxDecoration(
                                                          //             color: list[index]
                                                          //                 .isSelected3 ==
                                                          //                 true
                                                          //                 ? color3
                                                          //                 : Color(
                                                          //                 AllColors.whiteLight2),
                                                          //             borderRadius:
                                                          //             BorderRadius
                                                          //                 .circular(
                                                          //                 3.w)),
                                                          //         child:
                                                          //         SingleChildScrollView(
                                                          //           child:
                                                          //           Padding(
                                                          //             padding: EdgeInsets
                                                          //                 .symmetric(
                                                          //                 horizontal: 4
                                                          //                     .w,
                                                          //                 vertical:
                                                          //                 1.w),
                                                          //             child:
                                                          //             Text(
                                                          //               document[
                                                          //               'option_3'],
                                                          //               style: GoogleFonts
                                                          //                   .workSans(
                                                          //                   color: list[index]
                                                          //                       .isSelected3 ==
                                                          //                       true
                                                          //                       ? Colors
                                                          //                       .white
                                                          //                       : Color(
                                                          //                       AllColors.extraDarkPurple),
                                                          //                   fontWeight: FontWeight
                                                          //                       .w500,
                                                          //                   fontSize: 14
                                                          //                       .sp),
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //     )),
                                                          // Padding(
                                                          //     padding: EdgeInsets
                                                          //         .only(
                                                          //         top: 1.h),
                                                          //     child:
                                                          //     GestureDetector(
                                                          //       onTap: () {
                                                          //         _checkCorrectAnswer(
                                                          //             ans,
                                                          //             _setState,
                                                          //             document,
                                                          //             index,
                                                          //             4);
                                                          //       },
                                                          //       child:
                                                          //       Container(
                                                          //         alignment:
                                                          //         Alignment
                                                          //             .centerLeft,
                                                          //         width: 70.w,
                                                          //         height: 7.h,
                                                          //         decoration: BoxDecoration(
                                                          //             color: list[index]
                                                          //                 .isSelected4 ==
                                                          //                 true
                                                          //                 ? color4
                                                          //                 : Color(
                                                          //                 AllColors.whiteLight2),
                                                          //             borderRadius:
                                                          //             BorderRadius
                                                          //                 .circular(
                                                          //                 3.w)),
                                                          //         child:
                                                          //         SingleChildScrollView(
                                                          //           child:
                                                          //           Padding(
                                                          //             padding: EdgeInsets
                                                          //                 .symmetric(
                                                          //                 horizontal: 4
                                                          //                     .w,
                                                          //                 vertical:
                                                          //                 1.h),
                                                          //             child:
                                                          //             Text(
                                                          //               document[
                                                          //               'option_4'],
                                                          //               style: GoogleFonts
                                                          //                   .workSans(
                                                          //                   color: list[index]
                                                          //                       .isSelected4 ==
                                                          //                       true
                                                          //                       ? Colors
                                                          //                       .white
                                                          //                       : Color(
                                                          //                       AllColors.extraDarkPurple),
                                                          //                   fontWeight: FontWeight
                                                          //                       .w500,
                                                          //                   fontSize: 14
                                                          //                       .sp),
                                                          //             ),
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //     )),
                                                        ],
                                                      );
                                                    }),
                                                    SizedBox(
                                                      height: 1.h,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 80.w,
                                              height: 62.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    6.w,
                                                  ),
                                                  color: Colors.white),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Transform(
                                                        alignment:
                                                            FractionalOffset
                                                                .center,
                                                        transform:
                                                            Matrix4.identity()
                                                              ..setEntry(
                                                                  3, 2, 0.001)
                                                              ..rotateY(pi *
                                                                  _animation
                                                                      .value),
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  'Explanation',
                                                                  style: AllTextStyles.workSansMediumBlack(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18.sp)),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            6.w,
                                                                        right:
                                                                            6.w,
                                                                        top:
                                                                            8.w,
                                                                        bottom:
                                                                            3.w),
                                                                child: Text(
                                                                    document[
                                                                        'answer_exp'],
                                                                    style: AllTextStyles
                                                                        .workSansSmall()),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                        width: 76.w,
                                        height: 7.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                        ),
                                        child: _animation.value >= 0.5
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  index = index;
                                                  _flipCard();
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            Colors.white),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color: AllColors
                                                                  .blue,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    4.w)))),
                                                child: Text(
                                                    'Tap To See Question',
                                                    style:
                                                        AllTextStyles.workSansSmall(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12.sp)))
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  userId =
                                                      getCredential.read('uId');
                                                  if (index ==
                                                      snapshot.data!.docs
                                                              .length -
                                                          1) {
                                                    if (list[index].isSelected1 == true ||
                                                        list[index]
                                                                .isSelected2 ==
                                                            true ||
                                                        list[index]
                                                                .isSelected3 ==
                                                            true ||
                                                        list[index]
                                                                .isSelected4 ==
                                                            true) {
                                                      _whenLevelComplete(
                                                          index: index + 1,
                                                          userId: userId,
                                                          popQuiz: popQuiz);
                                                    }
                                                  } else {
                                                    if (list[index].isSelected1 == true ||
                                                        list[index]
                                                                .isSelected2 ==
                                                            true ||
                                                        list[index]
                                                                .isSelected3 ==
                                                            true ||
                                                        list[index]
                                                                .isSelected4 ==
                                                            true) {
                                                      _whenLevelNotComplete(
                                                          index: index + 1,
                                                          userId: userId,
                                                          popQuiz: popQuiz);
                                                    }
                                                  }
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: AllColors.blue,
                                                        ),
                                                        borderRadius: BorderRadius.circular(4.w)))),
                                                child: Text('Tap To Move Next Question',
                                                    style: AllTextStyles.workSansSmall(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AllColors
                                                          .extraDarkPurple,
                                                    )))),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ));
                      });
                }
                //},
                ),
      ),
    );
  }

  _checkCorrectAnswer(
      String ans, StateSetter _setState, var document, int index, int i) {
    _setState(() {
      if ((ans == 'a' && i == 1) ||
          (ans == 'b' && i == 2) ||
          (ans == 'c' && i == 3) ||
          (ans == 'd' && i == 4)) {
        firestore.collection('User').doc(userId).update(
          {
            'game_score': FieldValue.increment(5),
            'pop_quiz_point_changed': true
          },
        );
      }

      String myLevelQueId1 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question1'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question1'
              : 'Level4Question1';

      String myLevelQueId2 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question2'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question2'
              : 'Level4Question2';

      String myLevelQueId3 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question3'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question3'
              : 'Level4Question3';

      String myLevelQueId4 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question4'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question4'
              : 'Level4Question4';

      String myLevelQueId5 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question5'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question5'
              : 'Level4Question5';

      String myLevelQueId6 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question6'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question6'
              : 'Level4Question6';

      String myLevelQueId7 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question7'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question7'
              : 'Level4Question7';

      String myLevelQueId8 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question8'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question8'
              : 'Level4Question8';

      String myLevelQueId9 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question9'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question9'
              : 'Level4Question9';

      String myLevelQueId10 = popQuiz == 'Level_2_Pop_Quiz'
          ? 'Level2Question10'
          : popQuiz == 'Level_3_Pop_Quiz'
              ? 'Level3Question10'
              : 'Level4Question10';

      if (document['id'] == 1) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId1).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 2) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId2).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 3) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId3).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 4) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId4).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 5) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId5).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 6) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId6).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 7) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId7).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 8) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId8).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 9) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId9).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
      if (document['id'] == 10) {
        firestore.collection('Pop_Quiz_Calculation').doc(myLevelQueId10).set({
          if (i == 1) 'ans_a_all_user': FieldValue.arrayUnion([userId]),
          if (i == 1) 'ans_a_total_users': FieldValue.increment(1),
          if (i == 2) 'ans_b_all_user': FieldValue.arrayUnion([userId]),
          if (i == 2) 'ans_b_total_users': FieldValue.increment(1),
          if (i == 3) 'ans_c_all_user': FieldValue.arrayUnion([userId]),
          if (i == 3) 'ans_c_total_users': FieldValue.increment(1),
          if (i == 4) 'ans_d_all_user': FieldValue.arrayUnion([userId]),
          if (i == 4) 'ans_d_total_users': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }

      Color one = AllColors.green;
      Color two = AllColors.red;
      Color three = AllColors.lightGrey;

      if (ans == 'a') {
        list[index].isSelected1 = true;
        color1 = one;
      } else {
        list[index].isSelected1 = true;
        if (popQuiz == 'Level_2_Pop_Quiz' || popQuiz == 'Level_3_Pop_Quiz') {
          if (i == 1)
            color1 = two;
          else
            color1 = three;
        } else {
          color1 = two;
        }
      }
      if (ans == 'b') {
        list[index].isSelected2 = true;
        color2 = one;
      } else {
        list[index].isSelected2 = true;
        if (popQuiz == 'Level_2_Pop_Quiz' || popQuiz == 'Level_3_Pop_Quiz') {
          if (i == 2)
            color2 = two;
          else
            color2 = three;
        } else {
          color2 = two;
        }
      }
      if (ans == 'c') {
        list[index].isSelected3 = true;
        color3 = one;
      } else {
        list[index].isSelected3 = true;
        if (i == 3)
          color3 = two;
        else
          color3 = three;
      }
      if (ans == 'd') {
        list[index].isSelected4 = true;
        color4 = one;
      } else {
        list[index].isSelected4 = true;
        if (i == 4)
          color4 = two;
        else
          color4 = three;
      }
    });
    _flipCard();
  }

  _flipCard() {
    if (_status == AnimationStatus.dismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget options(
      {GestureTapCallback? onPressed,
      int? index,
      var document,
      Color? color,
      int? i,
      String? text}) {
    var questionId;
    if (popQuiz == 'Level_2_Pop_Quiz') {
      questionId = document['id'] == 1
          ? 'Level2Question1'
          : document['id'] == 2
              ? 'Level2Question2'
              : document['id'] == 3
                  ? 'Level2Question3'
                  : document['id'] == 4
                      ? 'Level2Question4'
                      : document['id'] == 5
                          ? 'Level2Question5'
                          : document['id'] == 6
                              ? 'Level2Question6'
                              : document['id'] == 7
                                  ? 'Level2Question7'
                                  : document['id'] == 8
                                      ? 'Level2Question8'
                                      : document['id'] == 9
                                          ? 'Level2Question9'
                                          : 'Level2Question10';
    }
    if (popQuiz == 'Level_3_Pop_Quiz') {
      questionId = document['id'] == 1
          ? 'Level3Question1'
          : document['id'] == 2
              ? 'Level3Question2'
              : document['id'] == 3
                  ? 'Level3Question3'
                  : document['id'] == 4
                      ? 'Level3Question4'
                      : document['id'] == 5
                          ? 'Level3Question5'
                          : document['id'] == 6
                              ? 'Level3Question6'
                              : document['id'] == 7
                                  ? 'Level3Question7'
                                  : document['id'] == 8
                                      ? 'Level3Question8'
                                      : document['id'] == 9
                                          ? 'Level3Question9'
                                          : 'Level3Question10';
    }
    if (popQuiz == 'Level_4_Pop_Quiz') {
      questionId = document['id'] == 1
          ? 'Level4Question1'
          : document['id'] == 2
              ? 'Level4Question2'
              : document['id'] == 3
                  ? 'Level4Question3'
                  : document['id'] == 4
                      ? 'Level4Question4'
                      : document['id'] == 5
                          ? 'Level4Question5'
                          : document['id'] == 6
                              ? 'Level4Question6'
                              : document['id'] == 7
                                  ? 'Level4Question7'
                                  : document['id'] == 8
                                      ? 'Level4Question8'
                                      : document['id'] == 9
                                          ? 'Level4Question9'
                                          : 'Level4Question10';
    }

    return Padding(
        padding: EdgeInsets.only(top: i == 1 ? 3.h : 1.h, bottom: 1.h),
        child: Container(
          height: 7.h,
          width: 70.w,
          child: SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('Pop_Quiz_Calculation')
                    .doc(questionId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('It\'s Error!');
                  }
                  if (!snapshot.hasData)
                    return Container(
                      // decoration: boxDecoration,
                      child: Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.white),
                        ),
                      ),
                    );

                  int value;
                  if (popQuiz == 'Level_2_Pop_Quiz' ||
                      popQuiz == 'Level_3_Pop_Quiz') {
                    value = snapshot.data!['ans_a_total_users'] +
                        snapshot.data!['ans_b_total_users'] +
                        snapshot.data!['ans_c_total_users'] +
                        snapshot.data!['ans_d_total_users'];
                  } else {
                    value = snapshot.data!['ans_a_total_users'] +
                        snapshot.data!['ans_b_total_users'];
                  }

                  return GestureDetector(
                    onTap: onPressed,
                    child: Align(
                      alignment: Alignment.center,
                      child: LinearPercentIndicator(
                        // animation: true,
                        lineHeight: 7.h,
                        width: 70.w,
                        // animationDuration: 1000,
                        percent: (popQuiz == 'Level_2_Pop_Quiz' ||
                                popQuiz == 'Level_3_Pop_Quiz')
                            ? (snapshot.data![i == 1
                                    ? 'ans_a_total_users'
                                    : i == 2
                                        ? 'ans_b_total_users'
                                        : i == 3
                                            ? 'ans_c_total_users'
                                            : 'ans_d_total_users'] /
                                value)
                            : (snapshot.data![i == 1
                                    ? 'ans_a_total_users'
                                    : 'ans_b_total_users'] /
                                value),
                        barRadius: Radius.circular(3.w),
                        center: Padding(
                          padding: EdgeInsets.only(
                              right: 2.w, top: 1.w, bottom: 1.w, left: 2.w),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              child: Text(
                                text.toString(),
                                style: AllTextStyles.workSansSmall(
                                    // color: optionSelect != 0
                                    //     ? Colors.white
                                    //     : AllColors.extraDarkPurple,
                                    color: AllColors.extraDarkPurple,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),

                        //linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: list[index!].isSelected1 == true
                            ? color
                            : AllColors.whiteLight2,
                        backgroundColor: AllColors.whiteLight2,
                        // backgroundColor:
                        //     optionSelect == 0 ? AllColors.whiteLight2 : color,
                      ),
                    ),
                  );
                }),
          ),
        ));
  }

  Future _whenLevelComplete({String? popQuiz, var userId, int? index}) async {
    // if (popQuiz == 'Level_2_Pop_Quiz') {
    //   // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(22);
    //   // await localNotifyManager.repeatNotificationLevel3();
    //   // await localNotifyManager
    //   //     .flutterLocalNotificationsPlugin
    //   //     .cancel(2);
    //   // await localNotifyManager
    //   //     .flutterLocalNotificationsPlugin
    //   //     .cancel(8);
    //   // await localNotifyManager
    //   //     .scheduleNotificationForLevelThreeSaturdayElevenAm();
    //   // await localNotifyManager
    //   //     .scheduleNotificationForLevelThreeWednesdaySevenPm();
    // }
    // if (popQuiz == 'Level_3_Pop_Quiz') {
    //   // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(23);
    //   // await localNotifyManager.repeatNotificationLevel4();
    //   // await localNotifyManager
    //   //     .flutterLocalNotificationsPlugin
    //   //     .cancel(3);
    //   // await localNotifyManager
    //   //     .flutterLocalNotificationsPlugin
    //   //     .cancel(9);
    //   // await localNotifyManager
    //   //     .scheduleNotificationForLevelFourSaturdayElevenAm();
    //   // await localNotifyManager
    //   //     .scheduleNotificationForLevelFourWednesdaySevenPm();
    // }
    // if (popQuiz == 'Level_4_Pop_Quiz') {
    //   //await localNotifyManager.flutterLocalNotificationsPlugin.cancel(24);
    //   // await localNotifyManager
    //   //     .flutterLocalNotificationsPlugin
    //   //     .cancel(4);
    //   // await localNotifyManager
    //   //     .flutterLocalNotificationsPlugin
    //   //     .cancel(10);
    // }
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    bool value = documentSnapshot.get('replay_level');

    if (popQuiz == 'Level_2_Pop_Quiz') {
      firestore.collection('User').doc(userId).update({
        'previous_session_info': 'Level_3_setUp_page',
        'level_id': 0,
        'bill_payment': 0,
        'account_balance': 0,
        'need': 0,
        'want': 0,
        'quality_of_life': 0,
        'level_2_popQuiz_id': index,
        'pop_quiz_point_changed': false,
        if (value != true) 'last_level': 'Level_3_setUp_page',
      }).then((value) => Future.delayed(
          Duration(seconds: 1),
          () => Get.offAll(
                () => LevelThreeSetUpPage(),
              )));
    }

    if (popQuiz == 'Level_3_Pop_Quiz') {
      firestore.collection('User').doc(userId).update({
        'bill_payment': 0,
        'credit_card_bill': 0,
        'previous_session_info': 'Level_4_setUp_page',
        'credit_card_balance': 0,
        'account_balance': 0,
        'level_id': 0,
        'credit_score': 0,
        'quality_of_life': 0,
        'payable_bill': 0,
        'score': 0,
        'need': 0,
        'want': 0,
        'level_3_popQuiz_id': index,
        'pop_quiz_point_changed': false,
        if (value != true) 'last_level': 'Level_4_setUp_page',
      }).then((value) => Future.delayed(
          Duration(seconds: 1),
          () => Get.offAll(
                () => LevelFourSetUpPage(),
              )));
    }

    if (popQuiz == 'Level_4_Pop_Quiz') {
      firestore.collection('User').doc(userId).update({
        'previous_session_info': 'Coming_soon',
        'account_balance': 0,
        'bill_payment': 0,
        'level_id': 0,
        'quality_of_life': 0,
        'need': 0,
        'want': 0,
        'mutual_fund': 0,
        'home_loan': 0,
        'transport_loan': 0,
        'investment': 0,
        'level_4_popQuiz_id': index,
        'pop_quiz_point_changed': false,
        if (value != true) 'last_level': 'Level_4',
      }).then((value) {
        inviteDialog().then((value) => Future.delayed(
            Duration(seconds: 1),
            () => Get.offAll(
                  () => ComingSoon(),
                )));
      });
    }
  }

  Future _whenLevelNotComplete(
      {int? index, var userId, String? popQuiz}) async {
    firestore.collection('User').doc(userId).update({
      'level_id': index,
      if (popQuiz == 'Level_2_Pop_Quiz') 'level_2_popQuiz_id': index,
      if (popQuiz == 'Level_3_Pop_Quiz') 'level_3_popQuiz_id': index,
      if (popQuiz == 'Level_4_Pop_Quiz') 'level_4_popQuiz_id': index,
      'pop_quiz_point_changed': false,
    }).then((value) {
      controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
    });
  }

// Padding(
//     padding: EdgeInsets.only(top: i == 1 ? 3.h : 1.h),
//     child: GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         alignment: Alignment.centerLeft,
//         width: 70.w,
//         height: 7.h,
//         decoration: BoxDecoration(
//             color: list[index].isSelected1 == true
//                 ? color
//                 : AllColors.whiteLight2,
//             borderRadius: BorderRadius.circular(3.w)),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
//             child: Text(document,
//                 style: AllTextStyles.workSansSmall(
//                   fontWeight: FontWeight.w500,
//                   color: list[index].isSelected1 == true
//                       ? Colors.white
//                       : AllColors.extraDarkPurple,
//                 )),
//           ),
//         ),
//       ),
//     ));
}

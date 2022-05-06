// import 'package:double_back_to_close_app/double_back_to_close_app.dart';
// import 'package:financial/ReusableScreen/ExpandedBottomDrawer.dart';
// import 'package:financial/ReusableScreen/GameScorePage.dart';
// import 'package:financial/ReusableScreen/GlobleVariable.dart';
// import 'package:financial/ReusableScreen/PreviewOfBottomDrawer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
//
// //ignore: must_be_immutable
// class PopQuiz extends StatefulWidget {
//   PopQuiz({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _PopQuizState createState() => _PopQuizState();
// }
//
// class _PopQuizState extends State<PopQuiz> {
//   var level;
//   var document;
//
//   @override
//   Widget build(BuildContext context) {
//     //var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     var portrait = displayHeight(context);
//     var bottomHeightPotrait = displayHeight(context) * .14;
//     var forPortrait = portrait - bottomHeightPotrait;
//
//     return SafeArea(
//         child: Container(
//             width: displayWidth(context),
//             height: displayHeight(context),
//             decoration: boxDecoration,
//             child: Scaffold(
//                 backgroundColor: Colors.transparent,
//                 body: DoubleBackToCloseApp(
//                   snackBar: const SnackBar(
//                     content: Text(tapBack),
//                   ),
//                   child: DraggableBottomSheet(
//                     backgroundWidget: Container(
//                       width: displayWidth(context),
//                       height: forPortrait,
//                       decoration: boxDecoration,
//                       child: Column(
//                         children: [
//                           GameScorePage(level: level, document: document),
//                           SizedBox(
//                             height: forPortrait * .04,
//                           ),
//                           Flexible(
//                               child: Stack(
//                             children: [
//
//                               Container(
//                                 alignment: Alignment.center,
//                                 height: forPortrait * .86 - bottomHeightPotrait,
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   width: displayWidth(context) * .80,
//                                   height:
//                                       forPortrait * .81 - bottomHeightPotrait,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(
//                                         displayWidth(context) * .08,
//                                       ),
//                                       color: Colors.white),
//                                   child: SingleChildScrollView(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                             top: displayHeight(context) * .04,
//                                             left: displayWidth(context) * .05,
//                                             right: displayWidth(context) * .05,
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               'Suppose you had \$100 in a savings account and the interest rate was 2 percent per year. After five years, how much do you think you would have in the account if you left the money to grow? ',
//                                               style: GoogleFonts.workSans(
//                                                 fontSize: 16.sp,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.black,
//                                               ),
//                                               textAlign: TextAlign.justify,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: displayHeight(context) *
//                                                     .03),
//                                             child: Container(
//                                               alignment: Alignment.topRight,
//                                               width:
//                                                   displayWidth(context) * .70,
//                                               height:
//                                                   displayHeight(context) * .07,
//                                               decoration: BoxDecoration(
//                                                   color: Color(AllColors.whiteLight2),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           displayWidth(
//                                                                   context) *
//                                                               .02)),
//                                               child: TextButton(
//                                                   onPressed: () {},
//                                                   child: Center(
//                                                     child: FittedBox(
//                                                       child: RichText(
//                                                         overflow:
//                                                             TextOverflow.clip,
//                                                         text: TextSpan(
//                                                           text:
//                                                               'A. more than \$102',
//                                                           style: GoogleFonts
//                                                               .workSans(
//                                                                   color: Color(
//                                                                       AllColors.extraDarkPurple),
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize:
//                                                                       15.sp),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )),
//                                             )),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: displayHeight(context) *
//                                                     .01),
//                                             child: Container(
//                                               alignment: Alignment.topRight,
//                                               width:
//                                                   displayWidth(context) * .70,
//                                               height:
//                                                   displayHeight(context) * .07,
//                                               decoration: BoxDecoration(
//                                                   color: Color(AllColors.whiteLight2),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           displayWidth(
//                                                                   context) *
//                                                               .02)),
//                                               child: TextButton(
//                                                   onPressed: () {},
//                                                   child: Center(
//                                                     child: FittedBox(
//                                                       child: RichText(
//                                                         overflow:
//                                                             TextOverflow.clip,
//                                                         text: TextSpan(
//                                                           text:
//                                                               'A. more than \$102',
//                                                           style: GoogleFonts
//                                                               .workSans(
//                                                                   color: Color(
//                                                                       AllColors.extraDarkPurple),
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize:
//                                                                       15.sp),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )),
//                                             )),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: displayHeight(context) *
//                                                     .01),
//                                             child: Container(
//                                               alignment: Alignment.topRight,
//                                               width:
//                                                   displayWidth(context) * .70,
//                                               height:
//                                                   displayHeight(context) * .07,
//                                               decoration: BoxDecoration(
//                                                   color: Color(AllColors.whiteLight2),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           displayWidth(
//                                                                   context) *
//                                                               .02)),
//                                               child: TextButton(
//                                                   onPressed: () {},
//                                                   child: Center(
//                                                     child: FittedBox(
//                                                       child: RichText(
//                                                         overflow:
//                                                             TextOverflow.clip,
//                                                         text: TextSpan(
//                                                           text:
//                                                               'A. more than \$102',
//                                                           style: GoogleFonts
//                                                               .workSans(
//                                                                   color: Color(
//                                                                       AllColors.extraDarkPurple),
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize:
//                                                                       15.sp),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )),
//                                             )),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: displayHeight(context) *
//                                                     .01),
//                                             child: Container(
//                                               alignment: Alignment.topRight,
//                                               width:
//                                                   displayWidth(context) * .70,
//                                               height:
//                                                   displayHeight(context) * .07,
//                                               decoration: BoxDecoration(
//                                                   color: Color(AllColors.whiteLight2),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           displayWidth(
//                                                                   context) *
//                                                               .02)),
//                                               child: TextButton(
//                                                   onPressed: () {},
//                                                   child: Center(
//                                                     child: FittedBox(
//                                                       child: RichText(
//                                                         overflow:
//                                                             TextOverflow.clip,
//                                                         text: TextSpan(
//                                                           text:
//                                                               'A. more than \$102',
//                                                           style: GoogleFonts
//                                                               .workSans(
//                                                                   color: Color(
//                                                                       AllColors.extraDarkPurple),
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize:
//                                                                       15.sp),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )),
//                                             )),
//                                         SizedBox(
//                                           height: displayHeight(context) * .01,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                   bottom: displayHeight(context) * .55,
//                                   left: displayWidth(context) * .16 ,
//                                   child: Container(
//                                       height: displayHeight(context) * .05,
//                                       width: displayWidth(context) * .30,
//                                       decoration: BoxDecoration(
//                                           color: Color(AllColors.darkOrange),
//                                           borderRadius: BorderRadius.circular(
//                                               displayWidth(context) * .08)),
//                                       child: Center(
//                                           child: Text(
//                                         'POP QUIZ',
//                                         style: GoogleFonts.robotoCondensed(
//                                             color: Colors.white,fontWeight: FontWeight.w700,fontSize: 14.sp),
//                                       )))),
//                             ],
//                           ))
//                         ],
//                       ),
//                     ),
//                     previewChild: PreviewOfBottomDrawer(),
//                     expandedChild: ExpandedBottomDrawer(),
//                     minExtent: displayHeight(context) * .14,
//                     maxExtent: level == 'Level_3'
//                         ? displayHeight(context) * .33
//                         : displayHeight(context) * .26,
//                     expansionExtent: level == 'Level_3' ? 90 : 50,
//                   ),
//                 ))));
//   }
// }
// main.dart
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GameScorePage.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/LevelFourSetUpPage.dart';
import 'package:financial/views/LevelThreeSetUpPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'LocalNotifyManager.dart';

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

  @override
  void initState() {
    super.initState();
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
                child: CircularProgressIndicator(
                    backgroundColor: AllColors.blue))
            : StreamBuilder<QuerySnapshot>(
                stream: popQuiz == 'Level_2_Pop_Quiz'
                    ? firestore
                        .collection('Level_2_Pop_Quiz')
                        .orderBy('id')
                        .snapshots()
                    : popQuiz == 'Level_3_Pop_Quiz'
                        ? firestore
                            .collection('Level_3_Pop_Quiz')
                            .orderBy('id')
                            .snapshots()
                        : firestore
                            .collection('Level_4_Pop_Quiz')
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
                              snackBar:  SnackBar(
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
                                                          options(() {
                                                            _checkCorrectAnswer(
                                                                ans,
                                                                _setState,
                                                                document,
                                                                index,
                                                                1);
                                                          },
                                                              index,
                                                              document[
                                                                  'option_1'],
                                                              color1,
                                                              1),
                                                          options(() {
                                                            _checkCorrectAnswer(
                                                                ans,
                                                                _setState,
                                                                document,
                                                                index,
                                                                2);
                                                          },
                                                              index,
                                                              document[
                                                                  'option_2'],
                                                              color2,
                                                              2),
                                                          if (popQuiz ==
                                                                  'Level_2_Pop_Quiz' ||
                                                              popQuiz ==
                                                                  'Level_3_Pop_Quiz')
                                                            options(() {
                                                              _checkCorrectAnswer(
                                                                  ans,
                                                                  _setState,
                                                                  document,
                                                                  index,
                                                                  3);
                                                            },
                                                                index,
                                                                document[
                                                                    'option_3'],
                                                                color3,
                                                                3),
                                                          if (popQuiz ==
                                                                  'Level_2_Pop_Quiz' ||
                                                              popQuiz ==
                                                                  'Level_3_Pop_Quiz')
                                                            options(() {
                                                              _checkCorrectAnswer(
                                                                  ans,
                                                                  _setState,
                                                                  document,
                                                                  index,
                                                                  4);
                                                            },
                                                                index,
                                                                document[
                                                                    'option_4'],
                                                                color4,
                                                                4),
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
                                                              color:
                                                                  AllColors.blue,
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
                                                  // SharedPreferences pref =
                                                  //     await SharedPreferences
                                                  //         .getInstance();
                                                  // userId = pref.get('uId');
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

                                                      if(popQuiz == 'Level_2_Pop_Quiz'){
                                                        // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(22);
                                                        // await localNotifyManager.repeatNotificationLevel3();
                                                        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(2);
                                                        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(8);
                                                        await localNotifyManager.scheduleNotificationForLevelThreeSaturdayElevenAm();
                                                        await localNotifyManager.scheduleNotificationForLevelThreeWednesdaySevenPm();
                                                      }
                                                      if(popQuiz == 'Level_3_Pop_Quiz'){
                                                        // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(23);
                                                        // await localNotifyManager.repeatNotificationLevel4();
                                                        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(3);
                                                        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(9);
                                                        await localNotifyManager.scheduleNotificationForLevelFourSaturdayElevenAm();
                                                        await localNotifyManager.scheduleNotificationForLevelFourWednesdaySevenPm();
                                                      }
                                                      if(popQuiz == 'Level_4_Pop_Quiz'){
                                                        //await localNotifyManager.flutterLocalNotificationsPlugin.cancel(24);
                                                        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(4);
                                                        await localNotifyManager.flutterLocalNotificationsPlugin.cancel(10);
                                                      }

                                                      DocumentSnapshot
                                                          documentSnapshot =
                                                          await firestore
                                                              .collection(
                                                                  'User')
                                                              .doc(userId)
                                                              .get();
                                                      bool value =
                                                          documentSnapshot.get(
                                                              'replay_level');
                                                      // level = documentSnapshot
                                                      //     .get('last_level');
                                                      // int myBal = documentSnapshot
                                                      //     .get('account_balance');
                                                      // level = level
                                                      //     .toString()
                                                      //     .substring(6, 7);
                                                      // int lev = int.parse(level);
                                                      // if (value == true) {
                                                      //   Future.delayed(
                                                      //       Duration(seconds: 1),
                                                      //       () => showDialogForReplay(lev, userId));
                                                      // } else {
                                                      firestore
                                                          .collection('User')
                                                          .doc(userId)
                                                          .update({
                                                        'previous_session_info': popQuiz ==
                                                                'Level_2_Pop_Quiz'
                                                            ? 'Level_3_setUp_page'
                                                            : popQuiz ==
                                                                    'Level_3_Pop_Quiz'
                                                                ? 'Level_4_setUp_page'
                                                                //: 'Level_5_setUp_page',
                                                                : 'Coming_soon',
                                                        'level_id': 0,
                                                        'bill_payment': 0,
                                                        'credit_card_balance':
                                                            0,
                                                        'credit_card_bill': 0,
                                                        'credit_score': 0,
                                                        'payable_bill': 0,
                                                        'score': 0,
                                                        if (value != true)
                                                          'last_level': popQuiz ==
                                                                  'Level_2_Pop_Quiz'
                                                              ? 'Level_3_setUp_page'
                                                              // : 'Coming_soon',
                                                              // 'last_level'
                                                              : popQuiz ==
                                                                      'Level_3_Pop_Quiz'
                                                                  ? 'Level_4_setUp_page'
                                                                  : 'Level_4_setUp_page',
                                                        //: 'Level_5_setUp_page',
                                                        'need': 0,
                                                        'want': 0,
                                                      });
                                                      popQuiz ==
                                                              'Level_2_Pop_Quiz'
                                                          ? firestore
                                                              .collection(
                                                                  'User')
                                                              .doc(userId)
                                                              .update({
                                                              'level_id':
                                                                  index + 1,
                                                              'level_2_popQuiz_id':
                                                                  index + 1,
                                                            }).then((value) {
                                                              Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                                  () => Get.off(
                                                                        () =>
                                                                            LevelThreeSetUpPage(),
                                                                        duration:
                                                                            Duration(milliseconds: 500),
                                                                        transition:
                                                                            Transition.downToUp,
                                                                      ));
                                                            })
                                                          : popQuiz ==
                                                                  'Level_3_Pop_Quiz'
                                                              ? firestore
                                                                  .collection(
                                                                      'User')
                                                                  .doc(userId)
                                                                  .update({
                                                                  'level_id':
                                                                      index + 1,
                                                                  'level_3_popQuiz_id':
                                                                      index + 1,
                                                                }).then(
                                                                      (value) {
                                                                  Future.delayed(
                                                                      Duration(seconds: 2),
                                                                      () =>
                                                                          // Get.off(() => ComingSoon(),
                                                                          Get.off(
                                                                            () =>
                                                                                LevelFourSetUpPage(),
                                                                            duration:
                                                                                Duration(milliseconds: 500),
                                                                            transition:
                                                                                Transition.downToUp,
                                                                          ));
                                                                })
                                                              : firestore
                                                                  .collection(
                                                                      'User')
                                                                  .doc(userId)
                                                                  .update({
                                                                  'level_id':
                                                                      index + 1,
                                                                  'level_4_popQuiz_id':
                                                                      index + 1,
                                                                }).then(
                                                                      (value) {
                                                                  inviteDialog();
                                                                  // Future.delayed(
                                                                  //     Duration(
                                                                  //         seconds:
                                                                  //         2),
                                                                  //         () =>
                                                                  //     Get.offAll(() => ComingSoon(),
                                                                  //     // Get.off(
                                                                  //     //       () =>
                                                                  //     //       LevelFiveSetUpPage(),
                                                                  //       duration:
                                                                  //       Duration(milliseconds: 500),
                                                                  //       transition:
                                                                  //       Transition.downToUp,
                                                                  //     ));
                                                                });
                                                      //}
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
                                                      firestore
                                                          .collection('User')
                                                          .doc(userId)
                                                          .update({
                                                        'level_id': index + 1,
                                                        if (popQuiz ==
                                                            'Level_2_Pop_Quiz')
                                                          'level_2_popQuiz_id':
                                                              index + 1,
                                                        if (popQuiz ==
                                                            'Level_3_Pop_Quiz')
                                                          'level_3_popQuiz_id':
                                                              index + 1,
                                                        if (popQuiz ==
                                                            'Level_4_Pop_Quiz')
                                                          'level_4_popQuiz_id':
                                                              index + 1,
                                                      }).then((value) {
                                                        controller.nextPage(
                                                            duration: Duration(
                                                                seconds: 1),
                                                            curve:
                                                                Curves.easeIn);
                                                      });
                                                    }
                                                  }
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color:
                                                              AllColors.blue,
                                                        ),
                                                        borderRadius: BorderRadius.circular(4.w)))),
                                                child: Text('Tap To Move Next Question',
                                                    style: AllTextStyles.workSansSmall(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:AllColors.extraDarkPurple,
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
      if (ans == 'a') {
        list[index].isSelected1 = true;
        color1 = Color(0xff04AA6D);
      } else {
        list[index].isSelected1 = true;
        if (popQuiz == 'Level_2_Pop_Quiz' || popQuiz == 'Level_3_Pop_Quiz') {
          if (i == 1)
            color1 = Color(0xffff3333);
          else
            color1 = Color(0xffbfbfbf);
        } else {
          color1 = Color(0xffff3333);
        }
      }
      if (ans == 'b') {
        list[index].isSelected2 = true;
        color2 = Color(0xff04AA6D);
      } else {
        list[index].isSelected2 = true;
        if (popQuiz == 'Level_2_Pop_Quiz' || popQuiz == 'Level_3_Pop_Quiz') {
          if (i == 2)
            color2 = Color(0xffff3333);
          else
            color2 = Color(0xffbfbfbf);
        } else {
          color2 = Color(0xffff3333);
        }
      }
      if (ans == 'c') {
        list[index].isSelected3 = true;
        color3 = Color(0xff04AA6D);
      } else {
        list[index].isSelected3 = true;
        if (i == 3)
          color3 = Color(0xffff3333);
        else
          color3 = Color(0xffbfbfbf);
      }
      if (ans == 'd') {
        list[index].isSelected4 = true;
        color4 = Color(0xff04AA6D);
      } else {
        list[index].isSelected4 = true;
        if (i == 4)
          color4 = Color(0xffff3333);
        else
          color4 = Color(0xffbfbfbf);
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

  Widget options(GestureTapCallback onPressed, int index, var document,
          Color color, int i) =>
      Padding(
          padding: EdgeInsets.only(top: i == 1 ? 3.h : 1.h),
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 70.w,
              height: 7.h,
              decoration: BoxDecoration(
                  color: list[index].isSelected1 == true
                      ? color
                      : AllColors.whiteLight2,
                  borderRadius: BorderRadius.circular(3.w)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                  child: Text(document,
                      style: AllTextStyles.workSansSmall(
                        fontWeight: FontWeight.w500,
                        color: list[index].isSelected1 == true
                            ? Colors.white
                            : AllColors.extraDarkPurple,
                      )),
                ),
              ),
            ),
          ));
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/views/LevelThreeSetUpPage.dart';
import 'package:financial/views/LevelTwoSetUpPage.dart';
import 'package:financial/views/PopQuiz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AllQueLevelTwo extends StatefulWidget {
  const AllQueLevelTwo({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelTwoState createState() => _AllQueLevelTwoState();
}

class _AllQueLevelTwoState extends State<AllQueLevelTwo> {
  int levelId = 0;
  String level = '';
  int gameScore = 0;
  int balance = 0;
  int qualityOfLife = 0;
  var document;
  var userId;

  //get bill data
  int billPayment = 0;
  int forPlan1 = 0;
  int forPlan2 = 0;
  int forPlan3 = 0;
  int forPlan4 = 0;

  //page controller
  PageController controller = PageController();

  //for indexing
  int currentIndex = 0;

  //for option selection
  bool flag1 = false;
  bool flag2 = false;
  bool flagForKnow = false;
  bool scroll = true;
  List<int> payArray = [];
  Color color = Colors.white;
  final storeValue = GetStorage();

  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  int updateValue = 0;

  Future<QueModel?> getLevelId() async {
    userId = storeValue.read('uId');
    updateValue = storeValue.read('update');
    forPlan1 = storeValue.read('plan1')!;
    forPlan2 = storeValue.read('plan2')!;
    forPlan3 = storeValue.read('plan3')!;
    forPlan4 = storeValue.read('plan4')!;

    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    levelId = snapshot.get('level_id');
    gameScore = snapshot.get('game_score');
    balance = snapshot.get('account_balance');
    qualityOfLife = snapshot.get('quality_of_life');
    billPayment = snapshot.get('bill_payment');
    controller = PageController(initialPage: levelId);

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Level_2").get();
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
    getLevelId().then((value) {
      if (levelId == 0)
        Future.delayed(Duration(milliseconds: 10), () => _salaryCredited());
    });
  }

  @override
  Widget build(BuildContext context) {
    color = Colors.white;
    return SafeArea(
        child: Container(
      width: 100.w,
      height: 100.h,
      decoration: boxDecoration,
      child: list.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator(backgroundColor: Color(0xff4D6EF2)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Level_2')
                  .orderBy('id')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('It\'s Error!');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Color(0xff4D6EF2)),
                    );
                  default:
                    return PageView.builder(
                        itemCount: snapshot.data!.docs.length,
                        controller: controller,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: (value) async {
                          flag1 = false;
                          flag2 = false;
                          flagForKnow = false;
                          color = Colors.white;

                          DocumentSnapshot snapshot = await firestore.collection('User').doc(userId).get();
                          if((snapshot.data() as Map<String, dynamic>).containsKey("level_1_balance")){
                            if (document['card_type'] == 'GameQuestion') {
                              updateValue = updateValue + 1;
                              storeValue.write('update', updateValue);
                              if (updateValue == 8) {
                                updateValue = 0;
                                storeValue.write('update', 0);
                                calculationForProgress( () {
                                  Get.back();
                                });
                              }
                            }
                          }

                          if(document['card_type'] == 'GameQuestion'){
                            if ((document['week'] == 3 ||
                                document['week'] % 4 == 3) &&
                                document['week'] != 0) _billPayment();

                            if ((document['week'] % 4 == 1) &&
                                document['week'] != 0) _salaryCredited();
                          }

                        },
                        itemBuilder: (context, index) {
                          currentIndex = index;
                          document = snapshot.data!.docs[index];
                          levelId = index;
                          return document['card_type'] == 'GameQuestion'
                              ? BackgroundWidget(
                                  level: level,
                                  document: document,
                                  container: StatefulBuilder(
                                    builder: (context, _setState) {
                                      return GameQuestionContainer(
                                        level: level,
                                        document: document,
                                        description: document['description'],
                                        option1: document['option_1'],
                                        option2: document['option_2'],
                                        color1: list[index].isSelected1 == true
                                            ? Color(0xff00C673)
                                            : Colors.white,
                                        color2: list[index].isSelected2 == true
                                            ? Color(0xff00C673)
                                            : Colors.white,
                                        textStyle1: GoogleFonts.workSans(
                                            color:
                                                list[index].isSelected1 == true
                                                    ? Colors.white
                                                    : Color(0xffFFA500),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp),
                                        textStyle2: GoogleFonts.workSans(
                                            color:
                                                list[index].isSelected2 == true
                                                    ? Colors.white
                                                    : Color(0xffFFA500),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp),
                                        onPressed1: list[index].isSelected2 ==
                                                    true ||
                                                list[index].isSelected1 == true
                                            ? () {}
                                            : () async {
                                                _setState(() {
                                                  flag1 = true;
                                                });
                                                if (flag2 == false) {
                                                  list[index].isSelected1 =
                                                      true;
                                                  int qol1 = document[
                                                      'quality_of_life_1'];
                                                  balance = ((balance -
                                                          document[
                                                              'option_1_price'])
                                                      as int?)!;
                                                  qualityOfLife =
                                                      qualityOfLife + qol1;
                                                  var category =
                                                      document['category'];
                                                  int price = document[
                                                      'option_1_price'];
                                                  _optionSelect(
                                                      balance,
                                                      gameScore,
                                                      qualityOfLife,
                                                      qol1,
                                                      index,
                                                      snapshot,
                                                      category,
                                                      price);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Sorry, you already selected option');
                                                }
                                              },
                                        onPressed2: list[index].isSelected2 ==
                                                    true ||
                                                list[index].isSelected1 == true
                                            ? () {}
                                            : () async {
                                                _setState(() {
                                                  flag2 = true;
                                                });
                                                if (flag1 == false) {
                                                  list[index].isSelected2 =
                                                      true;
                                                  int qol2 = document[
                                                      'quality_of_life_2'];
                                                  balance = ((balance -
                                                          document[
                                                              'option_2_price'])
                                                      as int?)!;
                                                  qualityOfLife =
                                                      qualityOfLife + qol2;
                                                  var category =
                                                      document['category'];
                                                  int price = document[
                                                      'option_2_price'];
                                                  _optionSelect(
                                                      balance,
                                                      gameScore,
                                                      qualityOfLife,
                                                      qol2,
                                                      index,
                                                      snapshot,
                                                      category,
                                                      price);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Sorry, you already selected option');
                                                }
                                              },
                                      );
                                    },
                                  ),
                                )
                              // ? Scaffold(
                              //     backgroundColor: Colors.transparent,
                              //     body: DoubleBackToCloseApp(
                              //       snackBar: const SnackBar(
                              //         content: Text('Tap back again to leave'),
                              //       ),
                              //       child: DraggableBottomSheet(
                              //         backgroundWidget: Container(
                              //           width: 100.w,
                              //           height: 100.h,
                              //           decoration: boxDecoration,
                              //           child: Column(
                              //             children: [
                              //               Spacer(),
                              //               GameScorePage(
                              //                 level: level,
                              //                 document: document,
                              //               ),
                              //               Padding(
                              //                 padding:
                              //                     EdgeInsets.only(top: 2.h),
                              //                 child: Container(
                              //                   alignment: Alignment.center,
                              //                   height: 54.h,
                              //                   width: 80.w,
                              //                   decoration: BoxDecoration(
                              //                       borderRadius:
                              //                           BorderRadius.circular(
                              //                               8.w),
                              //                       color: Color(0xff6A81F4)),
                              //                   child: SingleChildScrollView(
                              //                     child: Column(
                              //                       mainAxisAlignment:
                              //                           MainAxisAlignment.start,
                              //                       crossAxisAlignment:
                              //                           CrossAxisAlignment
                              //                               .center,
                              //                       children: [
                              //                         Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                                   top: 3.h,
                              //                                   left: 3.w,
                              //                                   right: 3.w),
                              //                           child: Text(
                              //                             document[
                              //                                 'description'],
                              //                             style: GoogleFonts
                              //                                 .workSans(
                              //                               fontSize: 16.sp,
                              //                               fontWeight:
                              //                                   FontWeight.w500,
                              //                               color: Colors.white,
                              //                             ),
                              //                             textAlign:
                              //                                 TextAlign.center,
                              //                           ),
                              //                         ),
                              //                         //option1(index,document),
                              //                         Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                                   top: 3.h),
                              //                           child: StatefulBuilder(
                              //                               builder: (context,
                              //                                   _setState1) {
                              //                             return Container(
                              //                               alignment: Alignment
                              //                                   .centerLeft,
                              //                               width: 62.w,
                              //                               height: 7.h,
                              //                               decoration: BoxDecoration(
                              //                                   color: list[index]
                              //                                               .isSelected1 ==
                              //                                           true
                              //                                       ? Color(
                              //                                           0xff00C673)
                              //                                       : Colors
                              //                                           .white,
                              //                                   borderRadius:
                              //                                       BorderRadius
                              //                                           .circular(
                              //                                               12.w)),
                              //                               child: SizedBox(
                              //                                 height: 7.h,
                              //                                 width: 62.w,
                              //                                 child:
                              //                                 list[index]
                              //                                                 .isSelected2 ==
                              //                                             true ||
                              //                                         list[index]
                              //                                                 .isSelected1 ==
                              //                                             true
                              //                                     ? TextButton(
                              //                                         style: ButtonStyle(
                              //                                             alignment: Alignment
                              //                                                 .centerLeft),
                              //                                         onPressed:
                              //                                             () {},
                              //                                         child:
                              //                                             Center(
                              //                                           child:
                              //                                               FittedBox(
                              //                                             child:
                              //                                                 Text(
                              //                                               document['option_1'],
                              //                                               style: GoogleFonts.workSans(
                              //                                                   color: list[index].isSelected1 == true ? Colors.white : Color(0xffFFA500),
                              //                                                   fontWeight: FontWeight.w500,
                              //                                                   fontSize: 15.sp),
                              //                                               textAlign:
                              //                                                   TextAlign.left,
                              //                                               overflow:
                              //                                                   TextOverflow.clip,
                              //                                             ),
                              //                                           ),
                              //                                         ))
                              //                                     : TextButton(
                              //                                         style: ButtonStyle(
                              //                                             alignment: Alignment
                              //                                                 .centerLeft),
                              //                                         onPressed:
                              //                                             () async {
                              //                                           _setState1(
                              //                                               () {
                              //                                             flag1 =
                              //                                                 true;
                              //                                           });
                              //                                           if (flag2 ==
                              //                                               false) {
                              //                                             list[index].isSelected1 =
                              //                                                 true;
                              //
                              //                                             int qol1 =
                              //                                                 document['quality_of_life_1'];
                              //                                             balance =
                              //                                                 ((balance - document['option_1_price']) as int?)!;
                              //                                             qualityOfLife =
                              //                                                 qualityOfLife + qol1;
                              //                                             var category =
                              //                                                 document['category'];
                              //                                             int price =
                              //                                                 document['option_1_price'];
                              //                                             _optionSelect(
                              //                                                 balance,
                              //                                                 gameScore,
                              //                                                 qualityOfLife,
                              //                                                 qol1,
                              //                                                 index,
                              //                                                 snapshot,
                              //                                                 category,
                              //                                                 price);
                              //                                           } else {
                              //                                             Fluttertoast.showToast(
                              //                                                 msg: 'Sorry, you already selected option');
                              //                                           }
                              //                                         },
                              //                                         child:
                              //                                             Center(
                              //                                           child:
                              //                                               FittedBox(
                              //                                             child:
                              //                                                 Text(
                              //                                               document['option_1'],
                              //                                               style: GoogleFonts.workSans(
                              //                                                   color: list[index].isSelected1 == true ? Colors.white : Color(0xffFFA500),
                              //                                                   fontWeight: FontWeight.w500,
                              //                                                   fontSize: 15.sp),
                              //                                               textAlign:
                              //                                                   TextAlign.left,
                              //                                               overflow:
                              //                                                   TextOverflow.clip,
                              //                                             ),
                              //                                           ),
                              //                                         )),
                              //                               ),
                              //                             );
                              //                           }),
                              //                         ),
                              //                         Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                                   top: 2.h),
                              //                           child: StatefulBuilder(
                              //                               builder: (context,
                              //                                   _setState2) {
                              //                             return Container(
                              //                               alignment: Alignment
                              //                                   .centerLeft,
                              //                               width: 62.w,
                              //                               height: 7.h,
                              //                               decoration: BoxDecoration(
                              //                                   color: list[index]
                              //                                               .isSelected2 ==
                              //                                           true
                              //                                       ? Color(
                              //                                           0xff00C673)
                              //                                       : Colors
                              //                                           .white,
                              //                                   borderRadius:
                              //                                       BorderRadius
                              //                                           .circular(
                              //                                               12.w)),
                              //                               child: SizedBox(
                              //                                 height: 7.h,
                              //                                 width: 62.h,
                              //                                 child: list[index]
                              //                                                 .isSelected2 ==
                              //                                             true ||
                              //                                         list[index]
                              //                                                 .isSelected1 ==
                              //                                             true
                              //                                     ? TextButton(
                              //                                         style: ButtonStyle(
                              //                                             alignment: Alignment
                              //                                                 .centerLeft),
                              //                                         onPressed:
                              //                                             () {},
                              //                                         child:
                              //                                             Center(
                              //                                           child:
                              //                                               FittedBox(
                              //                                             child:
                              //                                                 Text(
                              //                                               document['option_2'],
                              //                                               style: GoogleFonts.workSans(
                              //                                                   color: list[index].isSelected2 == true ? Colors.white : Color(0xffFFA500),
                              //                                                   fontWeight: FontWeight.w500,
                              //                                                   fontSize: 15.sp),
                              //                                               overflow:
                              //                                                   TextOverflow.clip,
                              //                                               textAlign:
                              //                                                   TextAlign.left,
                              //                                             ),
                              //                                           ),
                              //                                         ))
                              //                                     : TextButton(
                              //                                         style: ButtonStyle(
                              //                                             alignment: Alignment
                              //                                                 .centerLeft),
                              //                                         onPressed:
                              //                                             () async {
                              //                                           _setState2(
                              //                                               () {
                              //                                             flag2 =
                              //                                                 true;
                              //                                           });
                              //                                           if (flag1 ==
                              //                                               false) {
                              //                                             list[index].isSelected2 =
                              //                                                 true;
                              //
                              //                                             int qol2 =
                              //                                                 document['quality_of_life_2'];
                              //                                             balance =
                              //                                                 ((balance - document['option_2_price']) as int?)!;
                              //                                             qualityOfLife =
                              //                                                 qualityOfLife + qol2;
                              //                                             var category =
                              //                                                 document['category'];
                              //                                             int price =
                              //                                                 document['option_2_price'];
                              //
                              //                                             _optionSelect(
                              //                                                 balance,
                              //                                                 gameScore,
                              //                                                 qualityOfLife,
                              //                                                 qol2,
                              //                                                 index,
                              //                                                 snapshot,
                              //                                                 category,
                              //                                                 price);
                              //                                           } else {
                              //                                             Fluttertoast.showToast(
                              //                                                 msg: 'Sorry, you already selected option');
                              //                                           }
                              //                                         },
                              //                                         child:
                              //                                             Center(
                              //                                           child:
                              //                                               FittedBox(
                              //                                             child:
                              //                                                 Text(
                              //                                               document['option_2'],
                              //                                               style: GoogleFonts.workSans(
                              //                                                   color: list[index].isSelected2 == true ? Colors.white : Color(0xffFFA500),
                              //                                                   fontWeight: FontWeight.w500,
                              //                                                   fontSize: 15.sp),
                              //                                               overflow:
                              //                                                   TextOverflow.clip,
                              //                                               textAlign:
                              //                                                   TextAlign.left,
                              //                                             ),
                              //                                           ),
                              //                                         )),
                              //                               ),
                              //                             );
                              //                           }),
                              //                         ),
                              //                         SizedBox(
                              //                           height: 2.h,
                              //                         )
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               Spacer(),
                              //               Spacer(),
                              //               Spacer(),
                              //             ],
                              //           ),
                              //         ),
                              //         previewChild: PreviewOfBottomDrawer(),
                              //         expandedChild: ExpandedBottomDrawer(),
                              //         minExtent: 14.h,
                              //         maxExtent: 55.h,
                              //       ),
                              //     ),
                              //   )
                              : StatefulBuilder(builder: (context, _setState) {
                                  return InsightWidget(
                                    level: level,
                                    document: document,
                                    description: document['description'],
                                    colorForContainer: flagForKnow
                                        ? Color(0xff00C673)
                                        : Colors.white,
                                    colorForText: flagForKnow
                                        ? Colors.white
                                        : Color(0xff6D00C2),
                                    onTap: () async {
                                      _setState(() {
                                        flagForKnow = true;
                                        color = Color(0xff00C673);
                                      });
                                      if (index ==
                                          snapshot.data!.docs.length - 1) {
                                        firestore
                                            .collection('User')
                                            .doc(userId)
                                            .update({
                                          'level_id': index + 1,
                                          'level_2_id': index + 1,
                                        }).then((value) => Future.delayed(
                                                Duration(seconds: 1),
                                                () => calculationForProgress((){
                                                  Get.back();
                                                  _levelCompleteSummary(
                                                      context,
                                                      gameScore,
                                                      balance,
                                                      qualityOfLife);
                                                })));
                                      } else {
                                        firestore
                                            .collection('User')
                                            .doc(userId)
                                            .update({
                                          'level_id': index + 1,
                                          'level_2_id': index + 1,
                                        });
                                        controller.nextPage(
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeIn);
                                      }
                                    },
                                  );
                                });
                        });
                }
              },
            ),
    ));
  }

  // _billPayment() {
  //   return showDialog(
  //       context: context, // <<----
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //           onWillPop: () {
  //             return Future.value(false);
  //           },
  //           child: Scaffold(
  //               backgroundColor: Colors.transparent,
  //               body: DraggableBottomSheet(
  //                 backgroundWidget: Container(
  //                   width: 100.w,
  //                   height: 100.h,
  //                   decoration: boxDecoration,
  //                   child: Column(
  //                     children: [
  //                       Spacer(),
  //                       GameScorePage(
  //                         level: level,
  //                         document: document,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(top: 2.h),
  //                         child: Container(
  //                           alignment: Alignment.center,
  //                           height: 54.h,
  //                           width: 80.w,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(
  //                                 8.w,
  //                               ),
  //                               color: Color(0xff6A81F4)),
  //                           child: SingleChildScrollView(
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                       top: 3.h, left: 3.w, right: 3.w),
  //                                   child: Text(
  //                                     'BILLS DUE!',
  //                                     style: GoogleFonts.workSans(
  //                                       fontSize: 22.sp,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Colors.white,
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                       top: 3.h, left: 4.w, right: 4.w),
  //                                   child: Text(
  //                                     'Your monthly bills have been generated.',
  //                                     style: GoogleFonts.workSans(
  //                                       fontSize: 16.sp,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.white,
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                     top: 2.h,
  //                                   ),
  //                                   child: Center(
  //                                     child: RichText(
  //                                       textAlign: TextAlign.left,
  //                                       overflow: TextOverflow.clip,
  //                                       text: TextSpan(
  //                                           text: 'Rent ',
  //                                           style: GoogleFonts.workSans(
  //                                               color: Colors.white,
  //                                               fontWeight: FontWeight.w500,
  //                                               fontSize: 16.sp),
  //                                           children: [
  //                                             TextSpan(
  //                                               text:
  //                                                   '\$' + forPlan1.toString(),
  //                                               style: GoogleFonts.workSans(
  //                                                   color: Color(0xffFEBE16),
  //                                                   fontWeight: FontWeight.w500,
  //                                                   fontSize: 16.sp),
  //                                             ),
  //                                           ]),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                     top: 1.h,
  //                                   ),
  //                                   child: Center(
  //                                     child: RichText(
  //                                       textAlign: TextAlign.left,
  //                                       overflow: TextOverflow.clip,
  //                                       text: TextSpan(
  //                                           text: 'TV & Internet ',
  //                                           style: GoogleFonts.workSans(
  //                                               color: Colors.white,
  //                                               fontWeight: FontWeight.w500,
  //                                               fontSize: 16.sp),
  //                                           children: [
  //                                             TextSpan(
  //                                               text:
  //                                                   '\$' + forPlan2.toString(),
  //                                               style: GoogleFonts.workSans(
  //                                                   color: Color(0xffFEBE16),
  //                                                   fontWeight: FontWeight.w500,
  //                                                   fontSize: 16.sp),
  //                                             ),
  //                                           ]),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                     top: 1.h,
  //                                   ),
  //                                   child: Center(
  //                                     child: RichText(
  //                                       textAlign: TextAlign.left,
  //                                       overflow: TextOverflow.clip,
  //                                       text: TextSpan(
  //                                           text: 'Groceries ',
  //                                           style: GoogleFonts.workSans(
  //                                               color: Colors.white,
  //                                               fontWeight: FontWeight.w500,
  //                                               fontSize: 16.sp),
  //                                           children: [
  //                                             TextSpan(
  //                                               text:
  //                                                   '\$' + forPlan3.toString(),
  //                                               style: GoogleFonts.workSans(
  //                                                   color: Color(0xffFEBE16),
  //                                                   fontWeight: FontWeight.w500,
  //                                                   fontSize: 16.sp),
  //                                             ),
  //                                           ]),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                     top: 1.h,
  //                                   ),
  //                                   child: Center(
  //                                     child: RichText(
  //                                       textAlign: TextAlign.left,
  //                                       overflow: TextOverflow.clip,
  //                                       text: TextSpan(
  //                                           text: 'Cellphone ',
  //                                           style: GoogleFonts.workSans(
  //                                               color: Colors.white,
  //                                               fontWeight: FontWeight.w500,
  //                                               fontSize: 16.sp),
  //                                           children: [
  //                                             TextSpan(
  //                                               text:
  //                                                   '\$' + forPlan4.toString(),
  //                                               style: GoogleFonts.workSans(
  //                                                   color: Color(0xffFEBE16),
  //                                                   fontWeight: FontWeight.w500,
  //                                                   fontSize: 16.sp),
  //                                             ),
  //                                           ]),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                     padding: EdgeInsets.only(top: 4.h),
  //                                     child: StatefulBuilder(
  //                                         builder: (context, setState) {
  //                                       return Container(
  //                                         alignment: Alignment.centerLeft,
  //                                         width: 62.w,
  //                                         height: 7.h,
  //                                         decoration: BoxDecoration(
  //                                             color: color,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(12.w)),
  //                                         child: TextButton(
  //                                                 onPressed: color == Color(0xff00C673) ? (){} : () {
  //                                                   setState(() {
  //                                                     color = Color(0xff00C673);
  //                                                   });
  //                                                   payArray.add(currentIndex);
  //                                                   balance =
  //                                                       balance - billPayment;
  //                                                   if (balance < 0) {
  //                                                     Future.delayed(
  //                                                       Duration(
  //                                                           milliseconds: 500),
  //                                                       () =>
  //                                                           _showDialogForRestartLevel(),
  //                                                     );
  //                                                   } else {
  //                                                     firestore
  //                                                         .collection('User')
  //                                                         .doc(userId)
  //                                                         .update({
  //                                                       'account_balance':
  //                                                           balance,
  //                                                       'game_score':
  //                                                           gameScore +
  //                                                               balance +
  //                                                               qualityOfLife,
  //                                                     });
  //                                                     Future.delayed(
  //                                                         Duration(seconds: 1),
  //                                                         () => Get.back());
  //                                                   }
  //                                                 },
  //                                                 child: Padding(
  //                                                   padding: EdgeInsets.only(
  //                                                       left: 6.0),
  //                                                   child: Center(
  //                                                     child: FittedBox(
  //                                                       child: RichText(
  //                                                         textAlign:
  //                                                             TextAlign.left,
  //                                                         overflow:
  //                                                             TextOverflow.clip,
  //                                                         text: TextSpan(
  //                                                             text: 'Pay now ',
  //                                                             style: GoogleFonts.workSans(
  //                                                                 color: color ==
  //                                                                         Color(
  //                                                                             0xff00C673)
  //                                                                     ? Colors
  //                                                                         .white
  //                                                                     : Color(
  //                                                                         0xff4D5DDD),
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w500,
  //                                                                 fontSize:
  //                                                                     15.sp),
  //                                                             children: [
  //                                                               TextSpan(
  //                                                                 text: '\$' +
  //                                                                     billPayment
  //                                                                         .toString(),
  //                                                                 style: GoogleFonts.workSans(
  //                                                                     color: color ==
  //                                                                             Color(
  //                                                                                 0xff00C673)
  //                                                                         ? Colors
  //                                                                             .white
  //                                                                         : Color(
  //                                                                             0xffFEBE16),
  //                                                                     fontWeight:
  //                                                                         FontWeight
  //                                                                             .w500,
  //                                                                     fontSize:
  //                                                                         15.sp),
  //                                                               ),
  //                                                             ]),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 )),
  //                                       );
  //                                     })),
  //                                 SizedBox(
  //                                   height: 1.h,
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Spacer(),
  //                       Spacer(),
  //                       Spacer(),
  //                     ],
  //                   ),
  //                 ),
  //                 previewChild: PreviewOfBottomDrawer(),
  //                 expandedChild: ExpandedBottomDrawer(),
  //                 minExtent: 14.h,
  //                 maxExtent: 55.h,
  //               )),
  //         );
  //       });
  // }

  _billPayment() {
    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: BackgroundWidget(
                level: level,
                document: document,
                container: StatefulBuilder(
                  builder: (context, _setState) {
                    return BillPaymentWidget(
                      billPayment: billPayment.toString(),
                      forPlan1: forPlan1.toString(),
                      forPlan2: forPlan2.toString(),
                      forPlan3: forPlan3.toString(),
                      forPlan4: forPlan4.toString(),
                      text1: 'Rent ',
                      text2: 'TV & Internet ',
                      text3: 'Groceries ',
                      text4: 'Cellphone ',
                      color: color,
                      onPressed: color == Color(0xff00C673)
                          ? () {}
                          : () {
                              _setState(() {
                                color = Color(0xff00C673);
                              });
                              payArray.add(currentIndex);
                              balance = balance - billPayment;
                              if (balance < 0) {
                                Future.delayed(
                                  Duration(milliseconds: 500),
                                  () => _showDialogForRestartLevel(),
                                );
                              } else {
                                firestore
                                    .collection('User')
                                    .doc(userId)
                                    .update({
                                  'account_balance': balance,
                                  'game_score':
                                      gameScore + balance + qualityOfLife,
                                });
                                Future.delayed(
                                    Duration(seconds: 1), () => Get.back());
                              }
                            },
                    );
                  },
                )),
          );
        });
  }

  _salaryCredited() {
    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: BackgroundWidget(
                level: level,
                document: levelId == 0 ? 'GameQuestion' : document,
                container: StatefulBuilder(
                  builder: (context, _setState) {
                    return SalaryCreditedWidget(
                      color: color,
                      onPressed: color == Color(0xff00C673)
                          ? () {}
                          : () {
                              _setState(() {
                                color = Color(0xff00C673);
                              });
                              balance = balance + 1000;
                              firestore.collection('User').doc(userId).update({
                                'account_balance': balance,
                                'game_score':
                                    gameScore + balance + qualityOfLife,
                              });
                              Future.delayed(
                                  Duration(seconds: 1), () => Get.back());
                            },
                    );
                  },
                )),

            // child: Container(
            //   width: 100.w,
            //   height: 100.h,
            //   decoration: boxDecoration,
            //   child: Scaffold(
            //       backgroundColor: Colors.transparent,
            //       body: DraggableBottomSheet(
            //         backgroundWidget: Container(
            //           width: 100.w,
            //           height: 100.h,
            //           decoration: boxDecoration,
            //           child: Column(
            //             children: [
            //               Spacer(),
            //               levelId == 0
            //                   ? GameScorePage(
            //                 level: level,
            //                 document: 'GameQuestion',
            //               )
            //                   : GameScorePage(
            //                 level: level,
            //                 document: document,
            //               ),
            //               Padding(
            //                 padding: EdgeInsets.only(top: 2.h),
            //                 child: Container(
            //                   alignment: Alignment.center,
            //                   height: 54.h,
            //                   width: 80.w,
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(
            //                         8.w,
            //                       ),
            //                       color: Color(0xff6A81F4)),
            //                   child: SingleChildScrollView(
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       children: [
            //                         Padding(
            //                           padding: EdgeInsets.only(
            //                               top: 3.h, left: 3.w, right: 3.w),
            //                           child: Text(
            //                             'Salary Credited',
            //                             style: GoogleFonts.workSans(
            //                               fontSize: 20.sp,
            //                               fontWeight: FontWeight.w600,
            //                               color: Colors.white,
            //                             ),
            //                             textAlign: TextAlign.center,
            //                           ),
            //                         ),
            //                         Padding(
            //                           padding: EdgeInsets.only(
            //                               top: 3.h, left: 6.w, right: 6.w),
            //                           child: Text(
            //                             'Monthly salary of \$1000 has been credited to your account.',
            //                             style: GoogleFonts.workSans(
            //                               fontSize: 16.sp,
            //                               fontWeight: FontWeight.w500,
            //                               color: Colors.white,
            //                             ),
            //                             textAlign: TextAlign.center,
            //                           ),
            //                         ),
            //                         Padding(
            //                             padding: EdgeInsets.only(top: 4.h),
            //                             child: StatefulBuilder(
            //                                 builder: (context, setState) {
            //                                   return Container(
            //                                     alignment: Alignment.centerLeft,
            //                                     width: 62.w,
            //                                     height: 7.h,
            //                                     decoration: BoxDecoration(
            //                                         color: color,
            //                                         borderRadius:
            //                                         BorderRadius.circular(
            //                                             12.w)),
            //                                     child: color == Color(0xff00C673)
            //                                         ? TextButton(
            //                                         onPressed: () {},
            //                                         child: Padding(
            //                                           padding: EdgeInsets.only(
            //                                               left: 3.w),
            //                                           child: Center(
            //                                             child: FittedBox(
            //                                               child: Text(
            //                                                 'Okay ',
            //                                                 style: GoogleFonts.workSans(
            //                                                     color: color ==
            //                                                         Color(
            //                                                             0xff00C673)
            //                                                         ? Colors
            //                                                         .white
            //                                                         : Color(
            //                                                         0xff4D5DDD),
            //                                                     fontWeight:
            //                                                     FontWeight
            //                                                         .w500,
            //                                                     fontSize:
            //                                                     15.sp),
            //                                                 textAlign:
            //                                                 TextAlign.left,
            //                                                 overflow:
            //                                                 TextOverflow
            //                                                     .clip,
            //                                               ),
            //                                             ),
            //                                           ),
            //                                         ))
            //                                         : TextButton(
            //                                         onPressed: () {
            //                                           setState(() {
            //                                             color =
            //                                                 Color(0xff00C673);
            //                                           });
            //                                           balance = balance + 1000;
            //                                           firestore
            //                                               .collection('User')
            //                                               .doc(userId)
            //                                               .update({
            //                                             'account_balance':
            //                                             balance,
            //                                             'game_score':
            //                                             gameScore +
            //                                                 balance +
            //                                                 qualityOfLife,
            //                                           });
            //                                           Future.delayed(
            //                                               Duration(seconds: 1),
            //                                                   () => Get.back());
            //                                         },
            //                                         child: Padding(
            //                                           padding: EdgeInsets.only(
            //                                               left: 3.w),
            //                                           child: Center(
            //                                             child: FittedBox(
            //                                               child: Text(
            //                                                 'Okay ',
            //                                                 style: GoogleFonts.workSans(
            //                                                     color: color ==
            //                                                         Color(
            //                                                             0xff00C673)
            //                                                         ? Colors
            //                                                         .white
            //                                                         : Color(
            //                                                         0xff4D5DDD),
            //                                                     fontWeight:
            //                                                     FontWeight
            //                                                         .w500,
            //                                                     fontSize:
            //                                                     15.sp),
            //                                                 textAlign:
            //                                                 TextAlign.left,
            //                                                 overflow:
            //                                                 TextOverflow
            //                                                     .clip,
            //                                               ),
            //                                             ),
            //                                           ),
            //                                         )),
            //                                   );
            //                                 })),
            //                         SizedBox(
            //                           height: 2.h,
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Spacer(),
            //               Spacer(),
            //               Spacer(),
            //             ],
            //           ),
            //         ),
            //         previewChild: PreviewOfBottomDrawer(),
            //         expandedChild: ExpandedBottomDrawer(),
            //         minExtent: 14.h,
            //         maxExtent: 55.h,
            //       )),
            // ),
          );
        });
  }

  _showDialogForRestartLevel() {
    restartLevelDialog(
      () {
        firestore.collection('User').doc(userId).update({
          'previous_session_info': 'Level_2_setUp_page',
          'bill_payment': 0,
          'level_id': 0,
          'credit_card_balance': 0,
          'credit_card_bill': 0,
          'credit_score': 0,
          'payable_bill': 0,
          'quality_of_life': 0,
          'score': 0
        });
        Get.off(
          () => LevelTwoSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      },
    );
  }

  _optionSelect(
      int balance,
      int gameScore,
      int qualityOfLife,
      int qol2,
      int index,
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      category,
      int price) async {
    if (index == snapshot.data!.docs.length - 1) {
      firestore.collection('User').doc(userId).update({
        'level_id': index + 1,
        'level_2_id': index + 1,
      }).then((value) => Future.delayed(
          Duration(seconds: 1),
          () => calculationForProgress((){
            Get.back();
            _levelCompleteSummary(
                context, gameScore, balance, qualityOfLife);
          })));
    }
    if (balance >= 0) {
      firestore.collection('User').doc(userId).update({
        'account_balance': balance,
        'quality_of_life': FieldValue.increment(qol2),
        'game_score': gameScore + balance + qualityOfLife,
        'level_id': index + 1,
        'level_2_id': index + 1,
        'need': category == 'Need'
            ? FieldValue.increment(price)
            : FieldValue.increment(0),
        'want': category == 'Want'
            ? FieldValue.increment(price)
            : FieldValue.increment(0),
      });
      controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
    } else {
      setState(() {
        scroll = false;
      });
      _showDialogForRestartLevel();
    }
  }

  _levelCompleteSummary(BuildContext context, int gameScore, int balance,
      int qualityOfLife) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    int need = documentSnapshot['need'];
    int want = documentSnapshot['want'];
    int bill = documentSnapshot['bill_payment'];
    int accountBalance = documentSnapshot['account_balance'];
    int qol = documentSnapshot['quality_of_life'];
    Color color = Colors.white;

    return Get.generalDialog(
        barrierDismissible: false,
        pageBuilder: (context, animation, sAnimation) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: StatefulBuilder(
              builder: (context, _setState) {
                return BackgroundWidget(
                    level: level,
                    document: document,
                    container: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        StatefulBuilder(builder: (context, _setState) {
                          return LevelSummary(
                            need: need,
                            want: want,
                            bill: bill,
                            accountBalance: accountBalance,
                            color: color,
                            onPressed1: color == Color(0xff00C673)
                                ? () {}
                                : () {
                                    _setState(() {
                                      color = Color(0xff00C673);
                                    });
                                    // int myBal =
                                    //     documentSnapshot.get('account_balance');

                                    // if (myBal < 1200) {
                                    //   Future.delayed(
                                    //       Duration(seconds: 1),
                                    //       () =>
                                    //           _showDialogWhenAmountLessSavingGoal());
                                    // } else {
                                    Future.delayed(
                                      Duration(seconds: 2),
                                      () => inviteDialog(_playLevelOrPopQuiz()),
                                      // showDialog(
                                      // barrierDismissible: false,
                                      // context: context,
                                      // builder: (context) {
                                      //   return WillPopScope(
                                      //     onWillPop: () {
                                      //       return Future.value(false);
                                      //     },
                                      //     child: AlertDialog(
                                      //       elevation: 3.0,
                                      //       shape:
                                      //           RoundedRectangleBorder(
                                      //               borderRadius:
                                      //                   BorderRadius
                                      //                       .circular(
                                      //                           4.w)),
                                      //       actionsPadding:
                                      //           EdgeInsets.all(8.0),
                                      //       backgroundColor:
                                      //           Color(0xff6646E6),
                                      //       content: Text(
                                      //         'Woohoo! Invites unlocked!  \n\n Invite your friends to play the game and challenge them to beat your score!',
                                      //         style:
                                      //             GoogleFonts.workSans(
                                      //                 color:
                                      //                     Colors.white,
                                      //                 fontSize: 14.sp,
                                      //                 fontWeight:
                                      //                     FontWeight
                                      //                         .w600),
                                      //         textAlign:
                                      //             TextAlign.center,
                                      //       ),
                                      //       actions: [
                                      //         Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment
                                      //                   .spaceEvenly,
                                      //           children: [
                                      //             Container(
                                      //               child: ElevatedButton(
                                      //                   onPressed:
                                      //                       () async {
                                      //                     //bool value = documentSnapshot.get('replay_level');
                                      //                     // level = documentSnapshot.get('last_level');
                                      //                     // int myBal = documentSnapshot.get('account_balance');
                                      //
                                      //                     // level = level.toString().substring(6, 7);
                                      //                     // int lev = int.parse(level);
                                      //                     // if (value == true) {
                                      //                     //   Future.delayed(
                                      //                     //       Duration(seconds: 1),
                                      //                     //       () => showDialogForReplay(lev, userId),);
                                      //                     // } else {
                                      //                     FlutterShare.share(
                                      //                             title:
                                      //                                 'https://finshark.page.link/finshark',
                                      //                             text:
                                      //                                 'Hey! Have you tried out the Finshark app? It\'s a fun game that helps you build smart financial habits. You can learn to budget, invest and more. I think you\'ll like it!',
                                      //                             linkUrl:
                                      //                                 'https://finshark.page.link/finshark',
                                      //                             chooserTitle:
                                      //                                 'https://finshark.page.link/finshark')
                                      //                         .then(
                                      //                             (value) {
                                      //                       // Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelThreeSetUpPage(controller: PageController()))));
                                      //                     }).then((value) {
                                      //                       Get.back();
                                      //                       Future.delayed(
                                      //                           Duration(
                                      //                               seconds:
                                      //                                   1),
                                      //                           () =>
                                      //                               _playLevelOrPopQuiz());
                                      //                     });
                                      //                     // }
                                      //                   },
                                      //                   style: ButtonStyle(
                                      //                       backgroundColor:
                                      //                           MaterialStateProperty.all(
                                      //                               Colors
                                      //                                   .white)),
                                      //                   child: Text(
                                      //                     'Click here to invite ',
                                      //                     style: GoogleFonts
                                      //                         .workSans(
                                      //                       fontSize: 13.sp,
                                      //                       color: Color(
                                      //                           0xff6646E6),
                                      //                     ),
                                      //                   )),
                                      //               width: 51.w,
                                      //               height: 5.h,
                                      //             ),
                                      //             GestureDetector(
                                      //               child: Text(
                                      //                 'Skip',
                                      //                 style: GoogleFonts
                                      //                     .workSans(
                                      //                   color: Colors
                                      //                       .white,
                                      //                   fontSize: 13.sp,
                                      //                   fontWeight:
                                      //                       FontWeight
                                      //                           .w600,
                                      //                   decoration:
                                      //                       TextDecoration
                                      //                           .underline,
                                      //                 ),
                                      //               ),
                                      //               onTap: () {
                                      //                 Get.back();
                                      //                 Future.delayed(
                                      //                     Duration(
                                      //                         seconds:
                                      //                             1),
                                      //                     () =>
                                      //                         _playLevelOrPopQuiz());
                                      //               },
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   );
                                      // })
                                    );
                                    //}
                                  },
                            onPressed2: () {
                              _setState(() {
                                color = Color(0xff00C673);
                              });
                              bool value = documentSnapshot.get('replay_level');
                              documentSnapshot.get('account_balance');
                              Future.delayed(Duration(seconds: 1), () {
                                firestore
                                    .collection('User')
                                    .doc(userId)
                                    .update({
                                  'previous_session_info': 'Level_2_setUp_page',
                                  if (value != true)
                                    'last_level': 'Level_2_setUp_page',
                                }).then((value) {
                                  Get.offNamed('/Level2SetUp');
                                });
                              });
                            },
                          );
                        })
                      ],
                    ));
              },
            ),
          );
        });
  }

  _playLevelOrPopQuiz() async {
    DocumentSnapshot snap = await firestore.collection('User').doc(userId).get();
    int  bal = snap.get('account_balance');
    int qol = snap.get('quality_of_life');
    return popQuizDialog(
      () async {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        var userId = storeValue.read('uId');
        DocumentSnapshot snap =
            await firestore.collection('User').doc(userId).get();
        bool value = snap.get('replay_level');
        level = snap.get('last_level');
        level = level.toString().substring(6, 7);
        int lev = int.parse(level);
        if (lev == 2 && value == true) {
          firestore
              .collection('User')
              .doc(userId)
              .update({'replay_level': false});
        }
        Future.delayed(Duration(seconds: 2), () {
          FirebaseFirestore.instance.collection('User').doc(userId).update({
            'previous_session_info': 'Level_2_Pop_Quiz',
            'level_id': 0,
            if (value != true) 'last_level': 'Level_2_Pop_Quiz',
          });
          Get.off(
            () => PopQuiz(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          );
        });
      },
      () async {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        var userId = storeValue.read('uId');
        DocumentSnapshot snap =
            await firestore.collection('User').doc(userId).get();
        bool value = snap.get('replay_level');
        level = snap.get('last_level');
        level = level.toString().substring(6, 7);
        int lev = int.parse(level);
        if (lev == 2 && value == true) {
          firestore
              .collection('User')
              .doc(userId)
              .update({'replay_level': false});
        }
        Future.delayed(Duration(seconds: 2), () {
          FirebaseFirestore.instance.collection('User').doc(userId).update({
            'previous_session_info': 'Level_3_setUp_page',
            if (value != true) 'last_level': 'Level_3_setUp_page',
          'level_2_balance': bal,
          'level_2_qol': qol
          });
          Get.off(
            () => LevelThreeSetUpPage(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          );
        });
      },
    );
    // return showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) {
    //       return WillPopScope(
    //         onWillPop: () {
    //           return Future.value(false);
    //         },
    //         child: AlertDialog(
    //           elevation: 3.0,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(4.w)),
    //           titlePadding: EdgeInsets.zero,
    //           title: Container(
    //             width: 100.w,
    //             child: Padding(
    //               padding: EdgeInsets.all(8.0),
    //               child: Text(
    //                 'Congrats! You’ve managed to achieve your savings goal! Mission accomplished!',
    //                 textAlign: TextAlign.center,
    //                 style: GoogleFonts.workSans(
    //                     fontSize: 14.sp,
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.w500),
    //               ),
    //             ),
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.only(
    //                   topRight: Radius.circular(4.w),
    //                   topLeft: Radius.circular(4.w),
    //                 ),
    //                 color: Color(0xffE9E5FF)),
    //           ),
    //           content: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               ElevatedButton(
    //                   onPressed: () async {
    //                     SharedPreferences pref =
    //                         await SharedPreferences.getInstance();
    //                     var userId = pref.getString('uId');
    //                     DocumentSnapshot snap = await firestore
    //                         .collection('User')
    //                         .doc(userId)
    //                         .get();
    //                     bool value = snap.get('replay_level');
    //                     level = snap.get('last_level');
    //                     level = level.toString().substring(6, 7);
    //                     int lev = int.parse(level);
    //                     if (lev == 2 && value == true) {
    //                       firestore
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({'replay_level': false});
    //                     }
    //                     Future.delayed(Duration(seconds: 2), () {
    //                       FirebaseFirestore.instance
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({
    // 'previous_session_info': 'Level_2_Pop_Quiz',
    // 'level_id' : 0,
    // if (value != true) 'last_level': 'Level_2_Pop_Quiz',
    //                       });
    //                       Get.off(
    //                         () => LevelThreeSetUpPage(),
    //                         duration: Duration(milliseconds: 500),
    //                         transition: Transition.downToUp,
    //                       );
    //                     });
    //                   },
    //                   child: Text('Play Pop Quiz')),
    //               ElevatedButton(
    //                   onPressed: () async {
    //                     SharedPreferences pref =
    //                         await SharedPreferences.getInstance();
    //                     var userId = pref.getString('uId');
    //                     DocumentSnapshot snap = await firestore
    //                         .collection('User')
    //                         .doc(userId)
    //                         .get();
    //                     bool value = snap.get('replay_level');
    //                     level = snap.get('last_level');
    //                     level = level.toString().substring(6, 7);
    //                     int lev = int.parse(level);
    //                     if (lev == 2 && value == true) {
    //                       firestore
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({'replay_level': false});
    //                     }
    //                     Future.delayed(Duration(seconds: 2), () {
    //                       FirebaseFirestore.instance
    //                           .collection('User')
    //                           .doc(userId)
    //                           .update({
    //                         'previous_session_info': 'Level_3_setUp_page',
    //                         if (value != true)
    //                           'last_level': 'Level_3_setUp_page',
    //                       });
    //                       Get.off(
    //                         () => LevelThreeSetUpPage(),
    //                         duration: Duration(milliseconds: 500),
    //                         transition: Transition.downToUp,
    //                       );
    //                     });
    //                   },
    //                   child: Text('Play Next Level'))
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  _showDialogWhenAmountLessSavingGoal() {
    Get.defaultDialog(
      title: '',
      middleText:
          'Oops! You haven\’t managed to achieve your savings goal of \$1200.\n Please try again!',
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      onWillPop: () {
        return Future.value(false);
      },
      backgroundColor: Color(0xff6646E6),
      middleTextStyle: GoogleFonts.workSans(
        fontSize: 14.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      confirm: restartOrOkButton(
        'Restart level',
        () {
          firestore.collection('User').doc(userId).update({
            'previous_session_info': 'Level_2_setUp_page',
            'bill_payment': 0,
            'level_id': 0,
            'credit_card_balance': 0,
            'credit_card_bill': 0,
            'credit_score': 0,
            'payable_bill': 0,
            'quality_of_life': 0,
            'score': 0,
            'account_balance': 0,
            'need': 0,
            'want': 0,
          });
          Get.off(
            () => LevelTwoSetUpPage(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
          );
        },
      ),
    );
  }
}

class LevelSummary extends StatelessWidget {
  final int need;
  final int want;
  final int bill;
  final int accountBalance;
  final Color color;
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;

  const LevelSummary(
      {Key? key,
      required this.need,
      required this.want,
      required this.bill,
      required this.accountBalance,
      required this.color,
      required this.onPressed1,
      required this.onPressed2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 56.h,
      width: 80.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.w,
          ),
          color: Color(0xff6A81F4)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            accountBalance >= 1200
                ? normalText(
                    'Congratulations! You have completed this level successfully ',
                  )
                : normalText(
                    'Oops! You haven\’t managed to achieve your savings goal of 20%. Please try again! ',
                  ),
            richText(
                'Salary Earned : ', '\$' + 6000.toString(), 2.h),
            richText('Bills Paid : ',
                '${(((bill * 6) / 6000) * 100).floor()}' + '%', 1.h),
            richText('Spend on Needs : ',
                '${((need / 6000) * 100).floor()}' + '%', 1.h),
            richText('Spend on Wants : ',
                '${((want / 6000) * 100).floor()}' + '%', 1.h),
            richText('Money Saved : ',
                '${((accountBalance / 6000) * 100).floor()}' + '%', 1.h),
            accountBalance >= 1200
                ? buttonStyle(color, 'Play Next Level', onPressed1)
                : buttonStyle(color, 'Try Again', onPressed2),
            SizedBox(
              height: 2.h,
            )
          ],
        ),
      ),
    );
  }
}



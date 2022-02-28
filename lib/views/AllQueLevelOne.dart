import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/controllers/UserInfoController.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/views/LevelOnePopQuiz.dart';
import 'package:financial/views/LevelOneSetUpPage.dart';
import 'package:financial/views/LevelTwoSetUpPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AllQueLevelOne extends StatefulWidget {
  const AllQueLevelOne({
    Key? key,
  }) : super(key: key);

  @override
  _AllQueLevelOneState createState() => _AllQueLevelOneState();
}

class _AllQueLevelOneState extends State<AllQueLevelOne> {
  String level = '';
  int levelId = 0;
  int gameScore = 0;
  int balance = 0;
  int qualityOfLife = 0;
  var userId;
  int updateValue = 0;

  // page controller
  PageController controller = PageController();

  //store streambuilder value
  var document;

  // for option selection
  bool flag1 = false;
  bool flag2 = false;
  bool scroll = true;
  bool flagForKnow = false;
  final storeValue = GetStorage();
  final _controller = Get.put<UserInfoController>(UserInfoController());

  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  Future<QueModel?> getLevelId() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    userId = storeValue.read('uId');
    updateValue = storeValue.read('update');
    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    levelId = snapshot.get('level_id');
    gameScore = snapshot.get('game_score');
    balance = snapshot.get('account_balance');
    qualityOfLife = snapshot.get('quality_of_life');
    controller = PageController(initialPage: levelId);

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Level_1").get();
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
  }

  @override
  Widget build(BuildContext context) {
    //var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
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
              stream: firestore.collection('Level_1').orderBy('id').snapshots(),
              // stream: _userInfoController.querySnapshot,
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
                      // physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (b) async {
                        flag1 = false;
                        flag2 = false;
                        flagForKnow = false;
                        DocumentSnapshot snapshot = await firestore
                            .collection('User')
                            .doc(userId)
                            .get();
                        if ((snapshot.data() as Map<String, dynamic>)
                                .containsKey("level_1_balance") ==
                            true) {
                          print('aa');
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
                      },
                      itemBuilder: (context, index) {
                        document = snapshot.data!.docs[index];
                        return document['card_type'] == 'GameQuestion'
                            ? BackgroundWidget(
                                level: level,
                                document: document,
                                container: StatefulBuilder(
                                    builder: (context, _setState) {
                                  return
                                      //GetBuilder<UserInfoController>(builder: (C)=>
                                      GameQuestionContainer(
                                    level: level,
                                    document: document,
                                    onPressed1: list[index].isSelected2 ==
                                                true ||
                                            list[index].isSelected1 == true
                                        ? () {}
                                        : () async {
                                            // _controller.animation = CurvedAnimation(parent: _controller.controller, curve: Curves.easeIn);
                                            // _controller.update();
                                            // if(index == 0 || index == 1 || index == 2 ){
                                            //   _controller.key = UniqueKey();
                                            //   _controller.update();
                                            // }
                                            _setState(() {
                                              flag1 = true;
                                            });
                                            if (flag2 == false) {
                                              list[index].isSelected1 = true;
                                              int qol1 =
                                                  document['quality_of_life_1'];
                                              int price =
                                                  document['option_1_price'];
                                              // balance = balance - price;
                                              qualityOfLife =
                                                  qualityOfLife + qol1;
                                              var category =
                                                  document['category'];
                                              _optionSelect(
                                                  index,
                                                  qol1,
                                                  balance,
                                                  qualityOfLife,
                                                  snapshot,
                                                  document,
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
                                            // if(index == 0 || index == 1 || index == 2 ){
                                            //   _controller.key = UniqueKey();
                                            //   _controller.update();
                                            // }
                                            _setState(() {
                                              flag2 = true;
                                            });

                                            if (flag1 == false) {
                                              list[index].isSelected2 = true;
                                              int price =
                                                  document['option_2_price'];
                                              int qol2 =
                                                  document['quality_of_life_2'];
                                              // balance = balance - price;
                                              qualityOfLife =
                                                  qualityOfLife + qol2;
                                              var category =
                                                  document['category'];
                                              _optionSelect(
                                                  index,
                                                  qol2,
                                                  balance,
                                                  qualityOfLife,
                                                  snapshot,
                                                  document,
                                                  category,
                                                  price);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Sorry, you already selected option');
                                            }
                                          },
                                    option1: document['option_1'],
                                    description: document['description'],
                                    option2: document['option_2'],
                                    textStyle1: GoogleFonts.workSans(
                                        color: list[index].isSelected1 == true
                                            ? Colors.white
                                            : Color(0xffFFA500),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp),
                                    textStyle2: GoogleFonts.workSans(
                                        color: list[index].isSelected2 == true
                                            ? Colors.white
                                            : Color(0xffFFA500),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp),
                                    color1: list[index].isSelected1 == true
                                        ? Color(0xff00C673)
                                        : Colors.white,
                                    color2: list[index].isSelected2 == true
                                        ? Color(0xff00C673)
                                        : Colors.white,
                                  );
                                  //);
                                }))
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
                                    });
                                    if (index ==
                                        snapshot.data!.docs.length - 1) {
                                      firestore
                                          .collection('User')
                                          .doc(userId)
                                          .update({
                                        'level_id': index + 1,
                                        'level_1_id': index + 1,
                                      });
                                      Future.delayed(
                                          Duration(seconds: 1),
                                          () => calculationForProgress( () {
                                                Get.back();
                                                _levelCompleteSummary();
                                              }));
                                    } else {
                                      firestore
                                          .collection('User')
                                          .doc(userId)
                                          .update({
                                        'level_id': index + 1,
                                        'level_1_id': index + 1,
                                      });
                                      controller.nextPage(
                                          duration: Duration(seconds: 1),
                                          curve: Curves.easeIn);
                                    }
                                  },
                                );
                              });
                      },
                    );
                }
              },
            ),
    ));
  }

  _optionSelect(int index, int qol2, int balance, int qualityOfLife, snapshot,
      document, category, int price) async {
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    balance = snap.get('account_balance');
    balance = balance - price;
    if (index == snapshot.data!.docs.length - 1) {
      firestore.collection('User').doc(userId).update({
        'level_id': index + 1,
        'level_1_id': index + 1,
      });
      Future.delayed(
          Duration(milliseconds: 500), () => calculationForProgress( () {
        Get.back();
        _levelCompleteSummary();
      }));
    }
    if (balance >= 0 || balance == 0) {
      firestore.collection('User').doc(userId).update({
        'account_balance': balance,
        'quality_of_life': FieldValue.increment(qol2),
        'game_score': gameScore + balance + qualityOfLife,
        'level_id': index + 1,
        'level_1_id': index + 1,
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

      //_showDialogForRestartLevel(context);
      _showDialogForRestartLevel();
    }
  }

  _showDialogForRestartLevel() {
    Get.defaultDialog(
      title:
          'Oops! You’ve run out of money\!. \n You seem to have fallen prey to mental accounting. Mental accounting is when we value the same amount of money differently because of certain mental associations.',
      content: Text(
        'For example, when we receive a \$200 gift, we are more prone to spend it on '
        'discretionary wants, because in our mind, that money is \'free money\'. '
        'We might be more careful with spending the same amount, had we earned it.',
        style: GoogleFonts.workSans(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
        textAlign: TextAlign.center,
      ),
      titlePadding: EdgeInsets.all(4.w),
      contentPadding: EdgeInsets.all(4.w),
      barrierDismissible: false,
      onWillPop: () {
        return Future.value(false);
      },
      backgroundColor: Color(0xff6646E6),
      titleStyle: GoogleFonts.workSans(
        fontSize: 14.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      confirm: restartOrOkButton(
        'Restart level',
        () {
          firestore.collection('User').doc(userId).update({
            'account_balance': 200,
            'level_id': 0,
            'need': 0,
            'quality_of_life': 0,
            'want': 0,
            'previous_session_info': 'Level_1_setUp_page'
          }).then((value) {
            Get.off(
              () => LevelOneSetUpPage(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
            );
          });
        },
      ),
    );
  }

  _levelCompleteSummary() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    int need = documentSnapshot['need'];
    int want = documentSnapshot['want'];
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
                            accountBalance: accountBalance,
                            color: color,
                            onPressed: color == Color(0xff00C673)
                                ? () {}
                                : () async {
                                    _setState(() {
                                      color = Color(0xff00C673);
                                    });
                                    bool value =
                                        documentSnapshot.get('replay_level');
                                    level = documentSnapshot.get('last_level');
                                    level = level.toString().substring(6, 7);
                                    int lev = int.parse(level);
                                    if (lev == 1 && value == true) {
                                      firestore
                                          .collection('User')
                                          .doc(userId)
                                          .update({'replay_level': false});
                                    }
                                    // firestore
                                    //     .collection('User')
                                    //     .doc(userId)
                                    //     .update({
                                    //   if (value != true)'last_level': 'Level_2_setUp_page',
                                    //   'previous_session_info': 'Level_2_setUp_page',
                                    // });
                                    Future.delayed(
                                        Duration(milliseconds: 500),
                                        () => popQuizDialog(() {
                                              firestore
                                                  .collection('User')
                                                  .doc(userId)
                                                  .update({
                                                'previous_session_info':
                                                    'Level_1_Pop_Quiz',
                                                'level_id': 0,
                                                if (value != true)
                                                  'last_level':
                                                      'Level_1_Pop_Quiz',
                                              });
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () => Get.off(
                                                        () => LevelOnePopQuiz(),
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        transition:
                                                            Transition.downToUp,
                                                      ));
                                            }, () {
                                              firestore
                                                  .collection('User')
                                                  .doc(userId)
                                                  .update({
                                                'previous_session_info':
                                                    'Level_2_setUp_page',
                                                'level_id': 0,
                                                if (value != true)
                                                  'last_level':
                                                      'Level_2_setUp_page',
                                                'level_1_balance':
                                                    accountBalance,
                                                'level_1_qol': qol
                                              });
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () => Get.off(
                                                        () =>
                                                            LevelTwoSetUpPage(),
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        transition:
                                                            Transition.downToUp,
                                                      ));
                                            }));

                                    // gameScore = documentSnapshot
                                    //     .get('game_score');

                                    // if (lev != 1 &&
                                    //     value == true) {
                                    //   Future.delayed(
                                    //       Duration(seconds: 1),
                                    //       () => showDialogForReplay(lev, userId),
                                    //   );
                                    // } else {

                                    // }
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
}

class LevelSummary extends StatelessWidget {
  final int need;
  final int want;
  final int accountBalance;
  final Color color;
  final VoidCallback onPressed;

  const LevelSummary(
      {Key? key,
      required this.need,
      required this.want,
      required this.accountBalance,
      required this.color,
      required this.onPressed})
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
            normalText(
              'Congratulations! You have completed this level successfully ',
            ),
            richText('Total Cash : ', '\$' + (200.toString()), 4.h),
            richText('Spend on Needs : ',
                '${((need / 200) * 100).floor()}' + '%', 1.h),
            richText('Spend on Wants :  ',
                '${((want / 200) * 100).floor()}' + '%', 1.h),
            richText('Money Saved : ',
                '${((accountBalance / 200) * 100).floor()}' + '%', 1.h),
            buttonStyle(color, 'Play Next Level', onPressed),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 4.h,
            //   ),
            //   child: Center(
            //     child: RichText(
            //       textAlign: TextAlign.left,
            //       overflow: TextOverflow.clip,
            //       text: TextSpan(
            //           text: 'Total Cash : ',
            //           style: GoogleFonts.workSans(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 16.sp),
            //           children: [
            //             TextSpan(
            //               text: '\$' + (200.toString()),
            //               style: GoogleFonts.workSans(
            //                   color: Color(0xffFEBE16),
            //                   fontWeight: FontWeight.w500,
            //                   fontSize: 16.sp),
            //             ),
            //           ]),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 1.h,
            //   ),
            //   child: Center(
            //     child: RichText(
            //       textAlign: TextAlign.left,
            //       overflow: TextOverflow.clip,
            //       text: TextSpan(
            //           text: 'Spend on Needs : ',
            //           style: GoogleFonts.workSans(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 16.sp),
            //           children: [
            //             TextSpan(
            //               text: '${((need / 200) * 100).floor()}' + '%',
            //               style: GoogleFonts.workSans(
            //                   color: Color(0xffFEBE16),
            //                   fontWeight: FontWeight.w500,
            //                   fontSize: 16.sp),
            //             ),
            //           ]),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 1.h,
            //   ),
            //   child: Center(
            //     child: RichText(
            //       textAlign: TextAlign.left,
            //       overflow: TextOverflow.clip,
            //       text: TextSpan(
            //           text: 'Spend on Wants : ',
            //           style: GoogleFonts.workSans(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 16.sp),
            //           children: [
            //             TextSpan(
            //               text: '${((want / 200) * 100).floor()}' + '%',
            //               style: GoogleFonts.workSans(
            //                   color: Color(0xffFEBE16),
            //                   fontWeight: FontWeight.w500,
            //                   fontSize: 16.sp),
            //             ),
            //           ]),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 1.h,
            //   ),
            //   child: Center(
            //     child: RichText(
            //       textAlign: TextAlign.left,
            //       overflow: TextOverflow.clip,
            //       text: TextSpan(
            //           text: 'Money Saved : ',
            //           style: GoogleFonts.workSans(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 16.sp),
            //           children: [
            //             TextSpan(
            //               text:
            //                   '${((accountBalance / 200) * 100).floor()}' + '%',
            //               style: GoogleFonts.workSans(
            //                   color: Color(0xffFEBE16),
            //                   fontWeight: FontWeight.w500,
            //                   fontSize: 16.sp),
            //             ),
            //           ]),
            //     ),
            //   ),
            // ),
            // Padding(
            //     padding: EdgeInsets.only(top: 4.h),
            //     child: Container(
            //       alignment: Alignment.centerLeft,
            //       width: 62.w,
            //       height: 7.h,
            //       decoration: BoxDecoration(
            //           color: color, borderRadius: BorderRadius.circular(12.w)),
            //       child: TextButton(
            //           onPressed: onPressed,
            //           // color == Color(0xff00C673) ? (){} : () async {
            //           //   setState(() {
            //           //     color = Color(0xff00C673);
            //           //   });
            //           //   bool value = documentSnapshot.get('replay_level');
            //           //   level = documentSnapshot.get('last_level');
            //           //   level = level.toString().substring(6, 7);
            //           //   int lev = int.parse(level);
            //           //   if(lev == 1 && value == true){
            //           //     firestore.collection('User').doc(userId).update({
            //           //       'replay_level' : false
            //           //     });
            //           //   }
            //           //   firestore
            //           //       .collection('User')
            //           //       .doc(userId)
            //           //       .update({
            //           //     if (value != true)'last_level': 'Level_2_setUp_page',
            //           //     'previous_session_info': 'Level_2_setUp_page',
            //           //   });
            //           //   Future.delayed(
            //           //       Duration(seconds: 3),
            //           //           () =>  Get.off(() => LevelTwoSetUpPage(),
            //           //         duration:Duration(milliseconds: 500),
            //           //         transition: Transition.downToUp,));
            //           //   // gameScore = documentSnapshot
            //           //   //     .get('game_score');
            //           //   // if (lev != 1 &&
            //           //   //     value == true) {
            //           //   //   Future.delayed(
            //           //   //       Duration(seconds: 1),
            //           //   //       () => showDialogForReplay(lev, userId),
            //           //   //   );
            //           //   // } else {
            //           //
            //           //   // }
            //           // },
            //           child: Padding(
            //             padding: EdgeInsets.only(left: 3.w),
            //             child: Center(
            //               child: FittedBox(
            //                 child: Text(
            //                   'Play Next Level',
            //                   style: GoogleFonts.workSans(
            //                       color: color == Color(0xff00C673)
            //                           ? Colors.white
            //                           : Color(0xff4D5DDD),
            //                       fontWeight: FontWeight.w500,
            //                       fontSize: 15.sp),
            //                   textAlign: TextAlign.left,
            //                   overflow: TextOverflow.clip,
            //                 ),
            //               ),
            //             ),
            //           )),
            //     )),
            SizedBox(
              height: 2.h,
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:financial/ReusableScreen/CommanClass.dart';
// import 'package:financial/ReusableScreen/GlobleVariable.dart';
// import 'package:financial/controllers/UserInfoController.dart';
// import 'package:financial/views/LevelOnePopQuiz.dart';
// import 'package:financial/views/LevelOneSetUpPage.dart';
// import 'package:financial/views/LevelTwoSetUpPage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
//
// class AllQueLevelOne extends GetView<UserInfoController> {
//   // String level = '';
//   // int levelId = 0;
//   // int gameScore = 0;
//   // int balance = 0;
//   // int qualityOfLife = 0;
//   // var userId;
//   //
//   // // page controller
//   // PageController controller = PageController();
//   //
//   // //store streambuilder value
//   // var document;
//   //
//   // // for option selection
//   // bool flag1 = false;
//   // bool flag2 = false;
//   // bool scroll = true;
//   // bool flagForKnow = false;
//   // final storeValue = GetStorage();
//   //
//   // //for model
//   // QueModel? queModel;
//   // List<QueModel> list = [];
//   //
//   // Future<QueModel?> getLevelId() async {
//   //   //SharedPreferences pref = await SharedPreferences.getInstance();
//   //   userId = storeValue.read('uId');
//   //
//   //   DocumentSnapshot snapshot =
//   //   await firestore.collection('User').doc(userId).get();
//   //   level = snapshot.get('previous_session_info');
//   //   levelId = snapshot.get('level_id');
//   //   gameScore = snapshot.get('game_score');
//   //   balance = snapshot.get('account_balance');
//   //   qualityOfLife = snapshot.get('quality_of_life');
//   //   controller = PageController(initialPage: levelId);
//   //
//   //   QuerySnapshot querySnapshot =
//   //   await FirebaseFirestore.instance.collection("Level_1").get();
//   //   for (int i = 0; i < querySnapshot.docs.length; i++) {
//   //     var a = querySnapshot.docs[i];
//   //     queModel = QueModel();
//   //     queModel?.id = a['id'];
//   //     setState(() {
//   //       list.add(queModel!);
//   //     });
//   //   }
//   //   return null;
//   // }
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   getLevelId();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(UserInfoController());
//     print('CAlled');
//     //var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     return SafeArea(
//         child: Container(
//           width: 100.w,
//           height: 100.h,
//           decoration: boxDecoration,
//           child: Get.put<UserInfoController>(UserInfoController()).list.isEmpty
//               ? Center(
//               child:
//               CircularProgressIndicator(backgroundColor: Color(0xff4D6EF2)))
//               : GetX<UserInfoController>(
//             init: Get.put<UserInfoController>(UserInfoController()),
//             //init: controller,
//             // stream: _userInfoController.querySnapshot,
//             builder: (UserInfoController todoController) {
//                   return PageView.builder(
//                     itemCount:todoController.todos.length,
//                     controller: todoController.controller,
//                     scrollDirection: Axis.vertical,
//                     physics: NeverScrollableScrollPhysics(),
//                     onPageChanged: (b) {
//                       todoController.flag1 = false;
//                       todoController.flag2 = false;
//                       todoController.flagForKnow = false;
//                     },
//                     itemBuilder: (context, index) {
//                       //document = snapshot.data!.docs[index];
//                       todoController.document = todoController.todos[index];
//
//                       return todoController.todos[index].cardType == 'GameQuestion'
//                           ? BackgroundWidget(
//                           level: todoController.level,
//                           document: todoController.document,
//                           container: StatefulBuilder(
//                               builder: (context, _setState) {
//                                 return GameQuestionContainer(
//                                   level: todoController.level,
//                                   document: todoController.document,
//                                   onPressed1: todoController.list[index].isSelected2 ==
//                                       true ||
//                                       todoController.list[index].isSelected1 == true
//                                       ? () {}
//                                       : () async {
//                                     _setState(() {
//                                       todoController.flag1 = true;
//                                     });
//                                     if (todoController.flag2 == false) {
//                                       todoController.list[index].isSelected1 = true;
//                                       int qol1 = todoController.document.quality_of_life_1;
//                                       int price = todoController.document.option_1_price;
//                                       // balance = balance - price;
//                                       todoController.qualityOfLife = todoController.qualityOfLife + qol1;
//                                       var category =todoController.document.category;
//                                       _optionSelect(
//                                           index,
//                                           qol1,
//                                           todoController.balance,
//                                           todoController.qualityOfLife,
//                                           todoController.todos,
//                                           todoController.document,
//                                           category,
//                                           price,todoController);
//                                     } else {
//                                       Fluttertoast.showToast(
//                                           msg:
//                                           'Sorry, you already selected option');
//                                     }
//                                   },
//                                   onPressed2: todoController.list[index].isSelected2 ==
//                                       true ||
//                                       todoController.list[index].isSelected1 == true
//                                       ? () {}
//                                       : () async {
//                                     _setState(() {
//                                       todoController.flag2 = true;
//                                     });
//
//                                     if (todoController.flag1 == false) {
//                                       todoController.list[index].isSelected2 = true;
//                                       int price = todoController.document.option_2_price;
//                                       int qol2 = todoController.document.quality_of_life_2;
//                                       // balance = balance - price;
//                                       todoController.qualityOfLife = todoController.qualityOfLife + qol2;
//                                       var category = todoController.document.category;
//                                       _optionSelect(
//                                           index,
//                                           qol2,
//                                           todoController.balance,
//                                           todoController.qualityOfLife,
//                                           todoController.todos,
//                                           todoController.document,
//                                           category,
//                                           price,todoController);
//                                     } else {
//                                       Fluttertoast.showToast(
//                                           msg:
//                                           'Sorry, you already selected option');
//                                     }
//                                   },
//                                   option1: todoController.document.option_1,
//                                   description: todoController.document.description,
//                                   option2: todoController.document.option_2,
//                                   textStyle1: GoogleFonts.workSans(
//                                       color: todoController.list[index].isSelected1 == true
//                                           ? Colors.white
//                                           : Color(0xffFFA500),
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 15.sp),
//                                   textStyle2: GoogleFonts.workSans(
//                                       color: todoController.list[index].isSelected2 == true
//                                           ? Colors.white
//                                           : Color(0xffFFA500),
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 15.sp),
//                                   color1: todoController.list[index].isSelected1 == true
//                                       ? Color(0xff00C673)
//                                       : Colors.white,
//                                   color2: todoController.list[index].isSelected2 == true
//                                       ? Color(0xff00C673)
//                                       : Colors.white,
//                                 );
//                               }))
//                           : StatefulBuilder(builder: (context, _setState) {
//                         return InsightWidget(
//                           level: todoController.level,
//                           document: todoController.document,
//                           description: todoController.document.description,
//                           colorForContainer: todoController.flagForKnow
//                               ? Color(0xff00C673)
//                               : Colors.white,
//                           colorForText: todoController.flagForKnow
//                               ? Colors.white
//                               : Color(0xff6D00C2),
//                           onTap: () async {
//                             _setState(() {
//                               todoController.flagForKnow = true;
//                             });
//                             if (index ==
//                                 todoController.todos.length - 1) {
//                               firestore
//                                   .collection('User')
//                                   .doc(todoController.userId)
//                                   .update({
//                                 'level_id': index + 1,
//                                 'level_1_id': index + 1,
//                               });
//                               Future.delayed(Duration(seconds: 1),
//                                       () => _levelCompleteSummary(todoController));
//                             } else {
//                               todoController.controller.nextPage(
//                                   duration: Duration(seconds: 1),
//                                   curve: Curves.easeIn);
//                             }
//                           },
//                         );
//                       });
//                     },
//                   );
//
//             },
//           ),
//           //     : StreamBuilder<QuerySnapshot>(
//           //   stream: firestore.collection('Level_1').orderBy('id').snapshots(),
//           //   // stream: _userInfoController.querySnapshot,
//           //   builder: (context, snapshot) {
//           //     if (snapshot.hasError) {
//           //       return Text('It\'s Error!');
//           //     }
//           //     switch (snapshot.connectionState) {
//           //       case ConnectionState.waiting:
//           //         return Center(
//           //           child: CircularProgressIndicator(
//           //               backgroundColor: Color(0xff4D6EF2)),
//           //         );
//           //       default:
//           //         return PageView.builder(
//           //           itemCount: snapshot.data!.docs.length,
//           //           controller: userController.controller,
//           //           scrollDirection: Axis.vertical,
//           //           // physics: NeverScrollableScrollPhysics(),
//           //           onPageChanged: (b) {
//           //             userController.flag1 = false;
//           //             userController.flag2 = false;
//           //             userController.flagForKnow = false;
//           //           },
//           //           itemBuilder: (context, index) {
//           //             userController.document = snapshot.data!.docs[index];
//           //
//           //             return userController.document['card_type'] == 'GameQuestion'
//           //                 ? BackgroundWidget(
//           //                 level: userController.level,
//           //                 document: userController.document,
//           //                 container:
//           //                 //StatefulBuilder(
//           //                     // builder: (context, _setState) {
//           //                       //return
//           //                        // GetBuilder<UserInfoController>(builder: (C)=>
//           //                         GameQuestionContainer(
//           //                           level: userController.level,
//           //                           document: userController.document,
//           //                           onPressed1: userController.list[index].isSelected2 ==
//           //                               true ||
//           //                               userController.list[index].isSelected1 == true
//           //                               ? () {}
//           //                               : () async {
//           //                             // _controller.animation = CurvedAnimation(parent: _controller.controller, curve: Curves.easeIn);
//           //                             // _controller.update();
//           //                             // if(index == 0 || index == 1 || index == 2 ){
//           //                             //   _controller.key = UniqueKey();
//           //                             //   _controller.update();
//           //                             // }
//           //                             //_setState(() {
//           //                               userController.flag1 = true;
//           //                               userController.update();
//           //                            // });
//           //                             if (userController.flag2 == false) {
//           //                               userController.list[index].isSelected1 = true;
//           //                               int qol1 =
//           //                               userController.document['quality_of_life_1'];
//           //                               int price =
//           //                               userController.document['option_1_price'];
//           //                               // balance = balance - price;
//           //                               userController.qualityOfLife =
//           //                                   userController.qualityOfLife + qol1;
//           //                               var category =
//           //                               userController.document['category'];
//           //                               _optionSelect(
//           //                                   index,
//           //                                   qol1,
//           //                                   userController.balance,
//           //                                   userController.qualityOfLife,
//           //                                   snapshot,
//           //                                   userController.document,
//           //                                   category,
//           //                                   price);
//           //                             } else {
//           //                               Fluttertoast.showToast(
//           //                                   msg:
//           //                                   'Sorry, you already selected option');
//           //                             }
//           //                           },
//           //                           onPressed2: userController.list[index].isSelected2 ==
//           //                               true ||
//           //                               userController. list[index].isSelected1 == true
//           //                               ? () {}
//           //                               : () async {
//           //                             // if(index == 0 || index == 1 || index == 2 ){
//           //                             //   _controller.key = UniqueKey();
//           //                             //   _controller.update();
//           //                             // }
//           //                             //_setState(() {
//           //                               userController.flag2 = true;
//           //                               userController.update();
//           //                            // });
//           //
//           //                             if (userController.flag1 == false) {
//           //                               userController.list[index].isSelected2 = true;
//           //                               int price =
//           //                               userController.document['option_2_price'];
//           //                               int qol2 =
//           //                               userController.document['quality_of_life_2'];
//           //                               // balance = balance - price;
//           //                               userController.qualityOfLife =
//           //                                   userController.qualityOfLife + qol2;
//           //                               var category =
//           //                               userController.document['category'];
//           //                               _optionSelect(
//           //                                   index,
//           //                                   qol2,
//           //                                   userController.balance,
//           //                                   userController.qualityOfLife,
//           //                                   snapshot,
//           //                                   userController.document,
//           //                                   category,
//           //                                   price);
//           //                             } else {
//           //                               Fluttertoast.showToast(
//           //                                   msg:
//           //                                   'Sorry, you already selected option');
//           //                             }
//           //                           },
//           //                           option1: userController.document['option_1'],
//           //                           description: userController.document['description'],
//           //                           option2: userController.document['option_2'],
//           //                           textStyle1: GoogleFonts.workSans(
//           //                               color: userController.list[index].isSelected1 == true
//           //                                   ? Colors.white
//           //                                   : Color(0xffFFA500),
//           //                               fontWeight: FontWeight.w500,
//           //                               fontSize: 15.sp),
//           //                           textStyle2: GoogleFonts.workSans(
//           //                               color: userController.list[index].isSelected2 == true
//           //                                   ? Colors.white
//           //                                   : Color(0xffFFA500),
//           //                               fontWeight: FontWeight.w500,
//           //                               fontSize: 15.sp),
//           //                           color1: userController.list[index].isSelected1 == true
//           //                               ? Color(0xff00C673)
//           //                               : Colors.white,
//           //                           color2: userController.list[index].isSelected2 == true
//           //                               ? Color(0xff00C673)
//           //                               : Colors.white,
//           //                         ),
//           //                      // ),
//           //                     //})
//           //             )
//           //                 : StatefulBuilder(builder: (context, _setState) {
//           //               return InsightWidget(
//           //                 level: userController.level,
//           //                 document: userController.document,
//           //                 description: userController.document['description'],
//           //                 colorForContainer: userController.flagForKnow
//           //                     ? Color(0xff00C673)
//           //                     : Colors.white,
//           //                 colorForText: userController.flagForKnow
//           //                     ? Colors.white
//           //                     : Color(0xff6D00C2),
//           //                 onTap: () async {
//           //                   _setState(() {
//           //                     userController.flagForKnow = true;
//           //                   });
//           //                   if (index ==
//           //                       snapshot.data!.docs.length - 1) {
//           //                     firestore
//           //                         .collection('User')
//           //                         .doc(userController.userId)
//           //                         .update({
//           //                       'level_id': index + 1,
//           //                       'level_1_id': index + 1,
//           //                     });
//           //                     Future.delayed(Duration(seconds: 1),
//           //                             () => _levelCompleteSummary());
//           //                   } else {
//           //                     firestore
//           //                         .collection('User')
//           //                         .doc(userController.userId)
//           //                         .update({
//           //                       'level_id': index + 1,
//           //                       'level_1_id': index + 1,
//           //                     });
//           //                     userController.controller.nextPage(
//           //                         duration: Duration(seconds: 1),
//           //                         curve: Curves.easeIn);
//           //                   }
//           //                 },
//           //               );
//           //             });
//           //           },
//           //         );
//           //     }
//           //   },
//           // ),
//         ));
//   }
//
//   _optionSelect(int index, int qol2, int balance, int qualityOfLife, snapshot,
//       document, category, int price, UserInfoController todoController) async {
//     DocumentSnapshot snap =
//     await firestore.collection('User').doc(todoController.userId).get();
//     todoController..balance = snap.get('account_balance');
//     todoController..balance = todoController.balance - price;
//     if (index == snapshot.data!.docs.length - 1) {
//       firestore.collection('User').doc(todoController.userId).update({
//         'level_id': index + 1,
//         'level_1_id': index + 1,
//       });
//       Future.delayed(
//           Duration(milliseconds: 500), () => _levelCompleteSummary(todoController));
//     }
//     if (balance >= 0 || balance == 0) {
//       firestore.collection('User').doc(todoController.userId).update({
//         'account_balance': balance,
//         'quality_of_life': FieldValue.increment(qol2),
//         'game_score': todoController.gameScore + todoController.balance + todoController.qualityOfLife,
//         'level_id': index + 1,
//         'level_1_id': index + 1,
//         'need': category == 'Need'
//             ? FieldValue.increment(price)
//             : FieldValue.increment(0),
//         'want': category == 'Want'
//             ? FieldValue.increment(price)
//             : FieldValue.increment(0),
//       });
//       todoController.update();
//       todoController.controller..nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
//     } else {
//       todoController.scroll = false;
//       todoController.update();
//
//       //_showDialogForRestartLevel(context);
//       _showDialogForRestartLevel(todoController);
//     }
//   }
//
//   _showDialogForRestartLevel(UserInfoController todoController) {
//     Get.defaultDialog(
//       title:
//       'Oops! You’ve run out of money\!. \n You seem to have fallen prey to mental accounting. Mental accounting is when we value the same amount of money differently because of certain mental associations.',
//       content: Text(
//         'For example, when we receive a \$200 gift, we are more prone to spend it on '
//             'discretionary wants, because in our mind, that money is \'free money\'. '
//             'We might be more careful with spending the same amount, had we earned it.',
//         style: GoogleFonts.workSans(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//           fontSize: 12.sp,
//         ),
//         textAlign: TextAlign.center,
//       ),
//       titlePadding: EdgeInsets.all(4.w),
//       contentPadding: EdgeInsets.all(4.w),
//       barrierDismissible: false,
//       onWillPop: () {
//         return Future.value(false);
//       },
//       backgroundColor: Color(0xff6646E6),
//       titleStyle: GoogleFonts.workSans(
//         fontSize: 14.sp,
//         color: Colors.white,
//         fontWeight: FontWeight.w600,
//       ),
//       confirm: restartOrOkButton(
//         'Restart level',
//             () {
//           firestore.collection('User').doc(todoController.userId).update({
//             'account_balance': 200,
//             'level_id': 0,
//             'need': 0,
//             'quality_of_life': 0,
//             'want': 0,
//             'previous_session_info': 'Level_1_setUp_page'
//           }).then((value) {
//             Get.off(
//                   () => LevelOneSetUpPage(),
//               duration: Duration(milliseconds: 500),
//               transition: Transition.downToUp,
//             );
//           });
//         },
//       ),
//     );
//   }
//
//   _levelCompleteSummary(UserInfoController todoController) async {
//     DocumentSnapshot documentSnapshot =
//     await firestore.collection('User').doc(todoController.userId).get();
//     int need = documentSnapshot['need'];
//     int want = documentSnapshot['want'];
//     int accountBalance = documentSnapshot['account_balance'];
//     Color color = Colors.white;
//
//     return Get.generalDialog(
//         barrierDismissible: false,
//         pageBuilder: (context, animation, sAnimation) {
//           return WillPopScope(
//             onWillPop: () {
//               return Future.value(false);
//             },
//             child: StatefulBuilder(
//               builder: (context, _setState) {
//                 return BackgroundWidget(
//                     level: todoController.level,
//                     document: todoController.document,
//                     container: Column(
//                       children: [
//                         SizedBox(
//                           height: 5.h,
//                         ),
//                         StatefulBuilder(builder: (context, _setState) {
//                           return LevelSummary(
//                             need: need,
//                             want: want,
//                             accountBalance: accountBalance,
//                             color: color,
//                             onPressed: color == Color(0xff00C673)
//                                 ? () {}
//                                 : () async {
//                               _setState(() {
//                                 color = Color(0xff00C673);
//                               });
//                               bool value =
//                               documentSnapshot.get('replay_level');
//                               todoController.level = documentSnapshot.get('last_level');
//                               todoController.level = todoController.level.toString().substring(6, 7);
//                               int lev = int.parse(todoController.level);
//                               if (lev == 1 && value == true) {
//                                 firestore
//                                     .collection('User')
//                                     .doc(todoController.userId)
//                                     .update({'replay_level': false});
//                               }
//                               // firestore
//                               //     .collection('User')
//                               //     .doc(userId)
//                               //     .update({
//                               //   if (value != true)'last_level': 'Level_2_setUp_page',
//                               //   'previous_session_info': 'Level_2_setUp_page',
//                               // });
//                               Future.delayed(
//                                   Duration(milliseconds: 500),
//                                       () => popQuizDialog(() {
//                                     firestore
//                                         .collection('User')
//                                         .doc(todoController.userId)
//                                         .update({
//                                       'previous_session_info':
//                                       'Level_1_Pop_Quiz',
//                                       'level_id': 0,
//                                       if (value != true)
//                                         'last_level':
//                                         'Level_1_Pop_Quiz',
//                                     });
//                                     Future.delayed(
//                                         Duration(seconds: 1),
//                                             () => Get.off(
//                                               () => LevelOnePopQuiz(),
//                                           duration: Duration(
//                                               milliseconds: 500),
//                                           transition:
//                                           Transition.downToUp,
//                                         ));
//                                   }, () {
//                                     firestore
//                                         .collection('User')
//                                         .doc(todoController.userId)
//                                         .update({
//                                       'previous_session_info':
//                                       'Level_2_setUp_page',
//                                       'level_id': 0,
//                                       if (value != true)
//                                         'last_level':
//                                         'Level_2_setUp_page',
//                                     });
//                                     Future.delayed(
//                                         Duration(seconds: 1),
//                                             () => Get.off(
//                                               () =>
//                                               LevelTwoSetUpPage(),
//                                           duration: Duration(
//                                               milliseconds: 500),
//                                           transition:
//                                           Transition.downToUp,
//                                         ));
//                                   }));
//
//                               // gameScore = documentSnapshot
//                               //     .get('game_score');
//
//                               // if (lev != 1 &&
//                               //     value == true) {
//                               //   Future.delayed(
//                               //       Duration(seconds: 1),
//                               //       () => showDialogForReplay(lev, userId),
//                               //   );
//                               // } else {
//
//                               // }
//                             },
//                           );
//                         })
//                       ],
//                     ));
//               },
//             ),
//           );
//         });
//   }
//
// }
//
// class LevelSummary extends StatelessWidget {
//   final int need;
//   final int want;
//   final int accountBalance;
//   final Color color;
//   final VoidCallback onPressed;
//
//   const LevelSummary(
//       {Key? key,
//         required this.need,
//         required this.want,
//         required this.accountBalance,
//         required this.color,
//         required this.onPressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       height: 56.h,
//       width: 80.w,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(
//             8.w,
//           ),
//           color: Color(0xff6A81F4)),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             normalText('Congratulations! You have completed this level successfully ',),
//             richText('Total Cash : ', '\$' + (200.toString()), 4.h),
//             richText('Spend on Needs : ', '${((need / 200) * 100).floor()}' + '%', 1.h),
//             richText('Spend on Wants :  ', '${((want / 200) * 100).floor()}' + '%', 1.h),
//             richText('Money Saved : ', '${((accountBalance / 200) * 100).floor()}' + '%', 1.h),
//             buttonStyle(color, 'Play Next Level', onPressed),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     top: 4.h,
//             //   ),
//             //   child: Center(
//             //     child: RichText(
//             //       textAlign: TextAlign.left,
//             //       overflow: TextOverflow.clip,
//             //       text: TextSpan(
//             //           text: 'Total Cash : ',
//             //           style: GoogleFonts.workSans(
//             //               color: Colors.white,
//             //               fontWeight: FontWeight.w500,
//             //               fontSize: 16.sp),
//             //           children: [
//             //             TextSpan(
//             //               text: '\$' + (200.toString()),
//             //               style: GoogleFonts.workSans(
//             //                   color: Color(0xffFEBE16),
//             //                   fontWeight: FontWeight.w500,
//             //                   fontSize: 16.sp),
//             //             ),
//             //           ]),
//             //     ),
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     top: 1.h,
//             //   ),
//             //   child: Center(
//             //     child: RichText(
//             //       textAlign: TextAlign.left,
//             //       overflow: TextOverflow.clip,
//             //       text: TextSpan(
//             //           text: 'Spend on Needs : ',
//             //           style: GoogleFonts.workSans(
//             //               color: Colors.white,
//             //               fontWeight: FontWeight.w500,
//             //               fontSize: 16.sp),
//             //           children: [
//             //             TextSpan(
//             //               text: '${((need / 200) * 100).floor()}' + '%',
//             //               style: GoogleFonts.workSans(
//             //                   color: Color(0xffFEBE16),
//             //                   fontWeight: FontWeight.w500,
//             //                   fontSize: 16.sp),
//             //             ),
//             //           ]),
//             //     ),
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     top: 1.h,
//             //   ),
//             //   child: Center(
//             //     child: RichText(
//             //       textAlign: TextAlign.left,
//             //       overflow: TextOverflow.clip,
//             //       text: TextSpan(
//             //           text: 'Spend on Wants : ',
//             //           style: GoogleFonts.workSans(
//             //               color: Colors.white,
//             //               fontWeight: FontWeight.w500,
//             //               fontSize: 16.sp),
//             //           children: [
//             //             TextSpan(
//             //               text: '${((want / 200) * 100).floor()}' + '%',
//             //               style: GoogleFonts.workSans(
//             //                   color: Color(0xffFEBE16),
//             //                   fontWeight: FontWeight.w500,
//             //                   fontSize: 16.sp),
//             //             ),
//             //           ]),
//             //     ),
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //     top: 1.h,
//             //   ),
//             //   child: Center(
//             //     child: RichText(
//             //       textAlign: TextAlign.left,
//             //       overflow: TextOverflow.clip,
//             //       text: TextSpan(
//             //           text: 'Money Saved : ',
//             //           style: GoogleFonts.workSans(
//             //               color: Colors.white,
//             //               fontWeight: FontWeight.w500,
//             //               fontSize: 16.sp),
//             //           children: [
//             //             TextSpan(
//             //               text:
//             //                   '${((accountBalance / 200) * 100).floor()}' + '%',
//             //               style: GoogleFonts.workSans(
//             //                   color: Color(0xffFEBE16),
//             //                   fontWeight: FontWeight.w500,
//             //                   fontSize: 16.sp),
//             //             ),
//             //           ]),
//             //     ),
//             //   ),
//             // ),
//             // Padding(
//             //     padding: EdgeInsets.only(top: 4.h),
//             //     child: Container(
//             //       alignment: Alignment.centerLeft,
//             //       width: 62.w,
//             //       height: 7.h,
//             //       decoration: BoxDecoration(
//             //           color: color, borderRadius: BorderRadius.circular(12.w)),
//             //       child: TextButton(
//             //           onPressed: onPressed,
//             //           // color == Color(0xff00C673) ? (){} : () async {
//             //           //   setState(() {
//             //           //     color = Color(0xff00C673);
//             //           //   });
//             //           //   bool value = documentSnapshot.get('replay_level');
//             //           //   level = documentSnapshot.get('last_level');
//             //           //   level = level.toString().substring(6, 7);
//             //           //   int lev = int.parse(level);
//             //           //   if(lev == 1 && value == true){
//             //           //     firestore.collection('User').doc(userId).update({
//             //           //       'replay_level' : false
//             //           //     });
//             //           //   }
//             //           //   firestore
//             //           //       .collection('User')
//             //           //       .doc(userId)
//             //           //       .update({
//             //           //     if (value != true)'last_level': 'Level_2_setUp_page',
//             //           //     'previous_session_info': 'Level_2_setUp_page',
//             //           //   });
//             //           //   Future.delayed(
//             //           //       Duration(seconds: 3),
//             //           //           () =>  Get.off(() => LevelTwoSetUpPage(),
//             //           //         duration:Duration(milliseconds: 500),
//             //           //         transition: Transition.downToUp,));
//             //           //   // gameScore = documentSnapshot
//             //           //   //     .get('game_score');
//             //           //   // if (lev != 1 &&
//             //           //   //     value == true) {
//             //           //   //   Future.delayed(
//             //           //   //       Duration(seconds: 1),
//             //           //   //       () => showDialogForReplay(lev, userId),
//             //           //   //   );
//             //           //   // } else {
//             //           //
//             //           //   // }
//             //           // },
//             //           child: Padding(
//             //             padding: EdgeInsets.only(left: 3.w),
//             //             child: Center(
//             //               child: FittedBox(
//             //                 child: Text(
//             //                   'Play Next Level',
//             //                   style: GoogleFonts.workSans(
//             //                       color: color == Color(0xff00C673)
//             //                           ? Colors.white
//             //                           : Color(0xff4D5DDD),
//             //                       fontWeight: FontWeight.w500,
//             //                       fontSize: 15.sp),
//             //                   textAlign: TextAlign.left,
//             //                   overflow: TextOverflow.clip,
//             //                 ),
//             //               ),
//             //             ),
//             //           )),
//             //     )),
//             SizedBox(
//               height: 2.h,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

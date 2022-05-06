// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:double_back_to_close_app/double_back_to_close_app.dart';
// import 'package:financial/ReusableScreen/GlobleVariable.dart';
// import 'package:financial/Screens/AllQueLevelOne.dart';
// import 'package:financial/Screens/LevelFourHouseRent.dart';
// import 'package:financial/Screens/LevelThreeSetUpPage.dart';
// import 'package:financial/Screens/LevelTwoSetUpPage.dart';
// import 'package:financial/Screens/PopQuiz.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   var userId;
//   String level = ' ';
//   int lev = 0;
//   int i = 0;
//
//   getLevel() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     userId = pref.getString('uId');
//     DocumentSnapshot documentSnapshot =
//         await firestore.collection('User').doc(userId).get();
//     level = documentSnapshot.get('last_level');

//     level = level.toString().substring(6, 7);
//     setState(() {
//       lev = int.parse(level);
//     });
//   }
//
//   @override
//   void initState() {
//     getLevel();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         alignment: Alignment.center,
//         width: displayWidth(context),
//         height: displayHeight(context),
//         decoration: boxDecoration,
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: DoubleBackToCloseApp(
//             snackBar: const SnackBar(
//               content: Text(tapBack),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: lev >= 1
//                           ? MaterialStateProperty.all(Colors.green)
//                           : MaterialStateProperty.all(Colors.grey),
//                     ),
//                     onPressed: () {
//                       i = 1;
//                       lev >= 1 ? _showDialog(i) : Container();
//                     },
//                     child: Text(
//                       'Level 1 : Smart Money',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: lev >= 2
//                           ? MaterialStateProperty.all(Colors.green)
//                           : MaterialStateProperty.all(Colors.grey),
//                     ),
//                     onPressed: () {
//
//                       lev >= 2 ? _showDialog(2) : Container();
//                     },
//                     child: Text(
//                       'Level 2 : Smart Savers',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: lev >= 2
//                           ? MaterialStateProperty.all(Colors.green)
//                           : MaterialStateProperty.all(Colors.grey),
//                     ),
//                     onPressed: () {
//                       lev >= 2
//                           ? firestore.collection('User').doc(userId).update({
//                               'previous_session_info': 'Level_2_Pop_Quiz',
//                               'replay_level': true,
//                             }).then((value) {
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => PopQuiz()));
//                             })
//                           : Container();
//                     },
//                     child: Text(
//                       'Level 2 Pop Quiz',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: lev >= 3
//                           ? MaterialStateProperty.all(Colors.green)
//                           : MaterialStateProperty.all(Colors.grey),
//                     ),
//                     onPressed: () {
//
//                       lev >= 3 ? _showDialog(3) : Container();
//                     },
//                     child: Text(
//                       'Level 3 : Building Credit',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: lev >= 3
//                           ? MaterialStateProperty.all(Colors.green)
//                           : MaterialStateProperty.all(Colors.grey),
//                     ),
//                     onPressed: () {
//                       lev >= 3
//                           ? firestore.collection('User').doc(userId).update({
//                               'previous_session_info': 'Level_3_Pop_Quiz',
//                               'replay_level': true,
//                             }).then((value) {
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => PopQuiz()));
//                             })
//                           : Container();
//                     },
//                     child: Text(
//                       'Level 3 Pop Quiz',
//                       style: TextStyle(color: Colors.white),
//                     )),
//                 lev >= 4
//                     ? TextButton(
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.green),
//                         ),
//                         onPressed: () {
//
//                           _showDialog(4);
//                         },
//                         child: Text(
//                           'Level 4 : Building Assets',
//                           style: TextStyle(color: Colors.white),
//                         ))
//                     : TextButton(
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.grey),
//                         ),
//                         onPressed: () {},
//                         child: Text(
//                           'Level 4 : Building Assets',
//                           style: TextStyle(color: Colors.white),
//                         )),
//                 lev >= 5
//                     ? TextButton(
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.green),
//                         ),
//                         onPressed: () {
//
//                           _showDialog(5);
//                         },
//                         child: Text(
//                           'Level 5 : Stock Play',
//                           style: TextStyle(color: Colors.white),
//                         ))
//                     : TextButton(
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.grey),
//                         ),
//                         onPressed: () {},
//                         child: Text(
//                           'Level 5 : Stock Play',
//                           style: TextStyle(color: Colors.white),
//                         )),
//                 TextButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.grey),
//                     ),
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => LevelFourHouseRent()));
//                     },
//                     child: Text(
//                       'Level 4 setUp Page',
//                       style: TextStyle(color: Colors.white),
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _showDialog(int i) async {
//     DocumentSnapshot document =
//         await firestore.collection('User').doc(userId).get();
//     gameScore = document.get('game_score');
//
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             // actionsPadding: EdgeInsets.all(8.0),
//             backgroundColor: Color(AllColors.darkPurple),
//             title: Text(
//               'Replay Level ?',
//               style: TextStyle(color: Colors.white, fontSize: 16.sp),
//             ),
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//
//                     if (i == 1) {
//                       FirebaseFirestore.instance
//                           .collection('User')
//                           .doc(userId)
//                           .update({
//                         'replay_level': true,
//                         'credit_score': 0,
//                         'score': 0,
//                         'account_balance': 200,
//                         'quality_of_life': 0,
//                         'bill_payment': 0,
//                         'credit_card_balance': 0,
//                         'credit_card_bill': 0,
//                         'payable_bill': 0,
//                         'level_id': 0,
//                         'previous_session_info': 'Level_1',
//                         'need': 0,
//                         'want': 0,
//                       }).then((value) => Navigator.pushReplacement(
//                               context,
//                               PageTransition(
//                                   child: AllQueLevelOne(
//                                     billPayment: 0,
//                                     gameScore: gameScore,
//                                     level: 'Level_1',
//                                     levelId: 0,
//                                     qOl: 0,
//                                     savingBalance: 200,
//                                     creditCardBalance: 0,
//                                     creditCardBill: 0,
//                                     payableBill: 0,
//                                   ),
//                                   duration: Duration(milliseconds: 500),
//                                   type: PageTransitionType.bottomToTop)));
//                     }
//
//                     if (i == 2) {
//                       _updateValue(i);
//                       Navigator.pushReplacement(
//                           context,
//                           PageTransition(
//                               child: LevelTwoSetUpPage(
//                                 controller: PageController(),
//                               ),
//                               duration: Duration(milliseconds: 500),
//                               type: PageTransitionType.bottomToTop));
//                     }
//
//                     if (i == 3) {
//                       _updateValue(i);
//                       Navigator.pushReplacement(
//                           context,
//                           PageTransition(
//                               child: LevelThreeSetUpPage(
//                                 controller: PageController(),
//                               ),
//                               duration: Duration(milliseconds: 500),
//                               type: PageTransitionType.bottomToTop));
//                     }
//                   },
//                   child: Text(
//                     'Yes',
//                     style: TextStyle(color: Colors.white, fontSize: 14.sp),
//                   )),
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('No',
//                       style: TextStyle(color: Colors.white, fontSize: 14.sp))),
//             ],
//           );
//         });
//   }
//



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/ReusableScreen/GradientText.dart';
import 'package:financial/models/ProfilePageModel.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/models/RankingUser.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllImages.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/LevelFiveSetUpPage.dart';
import 'package:financial/views/LevelFourSetUpPage.dart';
import 'package:financial/views/LevelOnePopQuiz.dart';

import 'package:financial/views/LevelOneSetUpPage.dart';
import 'package:financial/views/LevelSixSetUpPage.dart';
import 'package:financial/views/LevelThreeSetUpPage.dart';
import 'package:financial/views/LevelTwoSetUpPage.dart';
import 'package:financial/views/PopQuiz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //for model
  QueModel? queModel;
  var userId;
  final getCredential = GetStorage();
  int gameScore = 0;
  String? userName;
  TextEditingController textEditingController = TextEditingController();

  List<QueModel> list = [];
  int level1Id = 0;
  int level2Id = 0;
  int level3Id = 0;
  int level4Id = 0;
  int level5Id = 0;
  int level6Id = 0;
  int level1popQuizId = 0;
  int level2popQuizId = 0;
  int level3popQuizId = 0;
  int level4popQuizId = 0;
  int level5popQuizId = 0;
  int level6popQuizId = 0;
  int level1totalQue = 0;
  int level2totalQue = 0;
  int level3totalQue = 0;
  int level4totalQue = 0;
  int level5totalQue = 0;
  int level6totalQue = 0;
  int level1popQuizQue = 0;
  int level2popQuizQue = 0;
  int level3popQuizQue = 0;
  int level4popQuizQue = 0;
  String? level;
  int lev = 0;
  List<RankingUser> totalUsers = [];
  List<RankingUser> topThree = [];

  getTopRankingUser() async {
    int gameScore = 0;
    String userName = '';
    RankingUser rankingUser;
    QuerySnapshot<Map<String, dynamic>>? l1 =
        await firestore.collection('User').get();
    int totalAuthe = l1.size;
    QuerySnapshot snap = await firestore.collection('User').get();
    DocumentSnapshot documentSnapshot;
    snap.docs.forEach((document) async {
      documentSnapshot =
          await firestore.collection('User').doc(document.id).get();
      setState(() {
        gameScore = documentSnapshot.get('game_score');
        if (snap.docs.contains('user_name')) {
          print('true');
          userName = documentSnapshot.get('user_name');
        } else {
          userName = document.id;
        }
        rankingUser = RankingUser(gameScore: gameScore, userName: userName);

        totalUsers.add(rankingUser);

        print('total user ${totalUsers.length}');
        if (totalUsers.isNotEmpty && totalUsers.length == totalAuthe) {
          totalUsers.sort((a, b) {
            return -a.gameScore!.compareTo(b.gameScore!);
            //softing on alphabetical order (Ascending order by Name String)
          });

          topThree = totalUsers.sublist(0, 3);
          //   //print('Items ${items.length}');
          //   for(int i = 0 ;i < totalUsers.length;i++){
          //     print('UserName ${totalUsers[i].userName} ');
          //     print('gameScore ${totalUsers[i].gameScore}');
          //   }
        }
      });

      // if(l1 == )
      // print('abc ${totalUsers.length}');
    });
  }

  Future<QueModel?> getLevelId() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // userId = pref.getString('uId');
    userId = getCredential.read('uId');

    QuerySnapshot<Map<String, dynamic>>? l1 =
        await firestore.collection('Level_1').get();
    QuerySnapshot<Map<String, dynamic>>? l2 =
        await firestore.collection('Level_2').get();
    QuerySnapshot<Map<String, dynamic>>? l3 =
        await firestore.collection('Level_3').get();
    QuerySnapshot<Map<String, dynamic>>? l4 =
        await firestore.collection('Level_4').get();
    QuerySnapshot<Map<String, dynamic>>? l5 =
        await firestore.collection('Level_4').get();
    QuerySnapshot<Map<String, dynamic>>? l1PopQuiz =
        await firestore.collection('Level_1_Pop_Quiz').get();
    QuerySnapshot<Map<String, dynamic>>? l2PopQuiz =
        await firestore.collection('Level_2_Pop_Quiz').get();
    QuerySnapshot<Map<String, dynamic>>? l3PopQuiz =
        await firestore.collection('Level_3_Pop_Quiz').get();
    QuerySnapshot<Map<String, dynamic>>? l4PopQuiz =
        await firestore.collection('Level_4_Pop_Quiz').get();
    DocumentSnapshot shot =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();
    setState(() {
      gameScore = shot.get('game_score');
      userName = shot.get('user_name');
      level1Id = shot.get('level_1_id');
      level2Id = shot.get('level_2_id');
      level3Id = shot.get('level_3_id');
      level4Id = shot.get('level_4_id');
      level5Id = shot.get('level_5_id');
      level6Id = shot.get('level_6_id');
      level1popQuizId = shot.get('level_1_popQuiz_id');
      level2popQuizId = shot.get('level_2_popQuiz_id');
      level3popQuizId = shot.get('level_3_popQuiz_id');
      level4popQuizId = shot.get('level_4_popQuiz_id');
      level5popQuizId = shot.get('level_5_popQuiz_id');
      level6popQuizId = shot.get('level_6_popQuiz_id');
      level1totalQue = l1.size;
      level2totalQue = l2.size;
      level3totalQue = l3.size;
      level4totalQue = l4.size;
      level5totalQue = l5.size;

      level1popQuizQue = l1PopQuiz.size;
      level2popQuizQue = l2PopQuiz.size;
      level3popQuizQue = l3PopQuiz.size;
      level4popQuizQue = l4PopQuiz.size;

      level = shot.get('last_level');
    });
    lev = int.parse(level.toString().substring(6, 7));
    return null;
  }

  List<ProfilePageModel> levelList = [
    ProfilePageModel(
      id: 1,
      description: AllStrings.level1Dec,
      level: AllStrings.level1,
      goal: AllStrings.level1Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    ProfilePageModel(
      id: 2,
      description: AllStrings.level2Dec,
      level: AllStrings.level2,
      goal: AllStrings.level2Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    ProfilePageModel(
      id: 3,
      description: AllStrings.level3Dec,
      level: AllStrings.level3,
      goal: AllStrings.level3Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    ProfilePageModel(
      id: 4,
      description: AllStrings.level4Dec,
      level: AllStrings.level4,
      goal: AllStrings.level4Goal,
      //goal: 'Goal : Achieve investments of 30k towards down-payment to buy house.',
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    ProfilePageModel(
      id: 5,
      description: AllStrings.level5Dec,
      level: AllStrings.level5,
      goal: AllStrings.level5Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
    ProfilePageModel(
      id: 6,
      description: AllStrings.level6Dec,
      level: AllStrings.level6,
      goal: AllStrings.level6Goal,
      // levelProgress: '10',
      // popQuizProgress: '10'
    ),
  ];

  @override
  void initState() {
    getLevelId().then((value) => getTopRankingUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: level == null
          ? Container(
              decoration: boxDecoration,
              alignment: Alignment.center,
              child: CircularProgressIndicator(backgroundColor: AllColors.blue))
          : Scaffold(
              body: Container(
                decoration: boxDecoration,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.white,
                                )),
                          )),
                      Center(
                        child: Container(
                          height: 8.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.w),
                            color: Colors.white,
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 12.w,
                                height: 8.h,
                                child: Image.asset(
                                  AllImages.profileIcon,
                                ),
                              ),
                              GradientText(
                                  text: 'Profile',
                                  style: AllTextStyles.dialogStyleExtraLarge(
                                      size: 22.sp),
                                  gradient: LinearGradient(
                                    colors: [
                                      AllColors.darkBlue,
                                      AllColors.darkPink,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )),
                            ],
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      topThree.length == 0
                          ? CircularProgressIndicator()
                          : StatefulBuilder(builder: (con, _setState) {
                              print('User $userName');
                              return userName.toString().isEmpty
                                  ? Container(
                                      height: 20.h,
                                      width: 86.w,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('Leaderboard',
                                                  style: AllTextStyles
                                                      .robotoMedium(),
                                                  textAlign: TextAlign.center),
                                              Text(
                                                  'please enter your name to view leaderboard rankings.',
                                                  style: AllTextStyles
                                                      .robotoSmall(),
                                                  textAlign: TextAlign.center),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    height: 6.h,
                                                    width: 50.w,
                                                    child: TextFormField(
                                                      decoration:
                                                          InputDecoration(
                                                              contentPadding:
                                                                  new EdgeInsets.symmetric(
                                                                      vertical:
                                                                          2.h,
                                                                      horizontal:
                                                                          1.h),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(
                                                                          2.w)),
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xffe8eafd))),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(
                                                                          2.w)),
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0xff563DC1),
                                                                      )),
                                                              //fillColor: Color(0xffe8eafd),
                                                              filled: true,
                                                              hintStyle:
                                                                  AllTextStyles.dialogStyleSmall(
                                                                      size: 13.sp),
                                                              hintText: " Enter your name"),
                                                      controller:
                                                          textEditingController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        firestore
                                                            .collection('User')
                                                            .doc(userId)
                                                            .update({
                                                          'user_name':
                                                              textEditingController
                                                                  .text
                                                        });
                                                        _setState(() {
                                                          userName =
                                                              textEditingController
                                                                  .text;
                                                          textEditingController
                                                              .clear();
                                                          // DocumentSnapshot snap =
                                                          //     await firestore
                                                          //         .collection('User')
                                                          //         .doc(userId)
                                                          //         .get();
                                                          // userName =
                                                          //     snap.get('user_name');
                                                        });
                                                      },
                                                      child: Text('Submit',
                                                          style: AllTextStyles
                                                              .dialogStyleSmall()))
                                                ],
                                              )
                                            ]),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          6.w,
                                        ),
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(
                                      child: ListView.builder(
                                          itemCount: topThree.length,
                                          shrinkWrap: true,
                                          itemBuilder: (con, index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 2.w),
                                              child: Container(
                                                height: 12.h,
                                                width: 86.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    6.w,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.w),
                                                  child: Row(children: [
                                                    // Expanded(
                                                    //   child: Container(
                                                    //     child: Image.asset(
                                                    //         'assets/profileImage.png',
                                                    //         height: 100.h,
                                                    //         width: 100.w,
                                                    //         fit: BoxFit.contain),
                                                    //     // height: 100.h,
                                                    //     // width: 100.w,
                                                    //     //color: Colors.red,
                                                    //   ),
                                                    // ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                            topThree[index]
                                                                .userName
                                                                .toString(),
                                                            style: AllTextStyles
                                                                .robotoSmall()),
                                                        height: 100.h,
                                                        width: 100.w,
                                                        // color: Colors.green,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                            topThree[index]
                                                                .gameScore
                                                                .toString(),
                                                            style: AllTextStyles
                                                                .robotoSmall()),
                                                        height: 100.h,
                                                        width: 100.w,
                                                        // color: Colors.red,
                                                        alignment: Alignment
                                                            .centerRight,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            );
                                          }),
                                    );
                            }),

                      SizedBox(
                        height: 3.h,
                      ),
                      ElevatedButton(onPressed: (){_updateValue(5);}, child: Text('LEVEL 5')),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: levelList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            // height: levelList[index].id == 1 ? 30.h : 38.h,
                            height: 38.h,
                            width: 99.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  //height: levelList[index].id == 1 ? 23.h : 30.h,
                                  height: 30.h,
                                  width: 86.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      6.w,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 2.w,
                                          right: 2.w,
                                        ),
                                        child: Text(
                                          '${levelList[index].description}',
                                          style: AllTextStyles.robotoSmall(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      if (levelList[index].id! <= 4)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 1.h,
                                              bottom: 2.h,
                                              left: 2.w,
                                              right: 2.w
                                              //bottom: displayWidth(context) * .02,
                                              ),
                                          child: FittedBox(
                                            child: Text(
                                              '${levelList[index].goal}',
                                              style: AllTextStyles.robotoSmall(
                                                size: 9.sp,
                                                color: Color(0xff818186),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      if (levelList[index].id! > 4)
                                        SizedBox(
                                          height: 3.h,
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          LinearPercentIndicator(
                                            animation: true,
                                            lineHeight: 4.h,
                                            width: 60.w,
                                            animationDuration: 1000,
                                            percent: levelList[index].id == 1
                                                ? (level1Id.toDouble() /
                                                    level1totalQue)
                                                : levelList[index].id == 2
                                                    ? (level2Id.toDouble() /
                                                        level2totalQue)
                                                    : levelList[index].id == 3
                                                        ? (level3Id.toDouble() /
                                                            level3totalQue)
                                                        : levelList[index].id ==
                                                                4
                                                            ? (level4Id
                                                                    .toDouble() /
                                                                level4totalQue)
                                                            : levelList[index]
                                                                        .id ==
                                                                    5
                                                                ? (level5Id
                                                                        .toDouble() /
                                                                    36)
                                                                : (level6Id
                                                                        .toDouble() /
                                                                    80),
                                            center: Text(
                                              'LEVEL PROGRESS',
                                              style: AllTextStyles.robotoSmall(
                                                  size: 10.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor:
                                                levelList[index].id! > lev
                                                    ? Color(0xffFFDAF0)
                                                    : Color(0xffFF3D8E),
                                            backgroundColor: Color(0xffFFDAF0),
                                          ),
                                          GestureDetector(
                                            child: Image.asset(
                                              AllImages.replayImage,
                                              width: 8.w,
                                              height: 5.h,
                                            ),
                                            onTap: () {
                                              levelList[index].id! <= lev
                                                  ? _updateValue(
                                                      levelList[index].id)
                                                  : Container();
                                            },
                                          ),
                                        ],
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 22.w),
                                              child: Text(
                                                  levelList[index].id == 1
                                                      ? '${((level1Id * 100) / level1totalQue).ceil()}% COMPLETED'
                                                      : levelList[index].id == 2
                                                          ? '${((level2Id * 100) / level2totalQue).ceil()}% COMPLETED'
                                                          : levelList[index]
                                                                      .id ==
                                                                  3
                                                              ? '${((level3Id * 100) / level3totalQue).ceil()}% COMPLETED'
                                                              : levelList[index]
                                                                          .id ==
                                                                      4
                                                                  ? '${((level4Id * 100) / level4totalQue).ceil()}% COMPLETED'
                                                                  : levelList[index]
                                                                              .id ==
                                                                          5
                                                                      ? '${((level5Id * 100) / 36).ceil()}% COMPLETED'
                                                                      : '${((level6Id * 100) / 80).ceil()}% COMPLETED',
                                                  style: AllTextStyles
                                                      .workSansSmall(
                                                    fontSize: 8.sp,
                                                    color: Color(0xffC4C4C4),
                                                  )))),
                                      // levelList[index].id == 1
                                      //     ? Container()
                                      //     :
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          LinearPercentIndicator(
                                            animation: true,
                                            lineHeight: 4.h,
                                            width: 60.w,
                                            animationDuration: 1000,
                                            percent: levelList[index].id == 1
                                                ? (level1popQuizId.toDouble() /
                                                    level1popQuizQue)
                                                : levelList[index].id == 2
                                                    ? (level2popQuizId
                                                            .toDouble() /
                                                        level2popQuizQue)
                                                    : levelList[index].id == 3
                                                        ? (level3popQuizId
                                                                .toDouble() /
                                                            level3popQuizQue)
                                                        : levelList[index].id ==
                                                                4
                                                            ? (level4popQuizId
                                                                    .toDouble() /
                                                                level4popQuizQue)
                                                            : levelList[index]
                                                                        .id ==
                                                                    5
                                                                ? (level5Id
                                                                        .toDouble() /
                                                                    36)
                                                                : (level6Id
                                                                        .toDouble() /
                                                                    80),
                                            center: Text(
                                              'POP QUIZ',
                                              style: AllTextStyles.robotoSmall(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  size: 10.sp),
                                            ),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor:
                                                levelList[index].id! > lev
                                                    ? Color(0xffCDE4FD)
                                                    : Color(0xff409AFF),
                                            backgroundColor: Color(0xffCDE4FD),
                                          ),
                                          GestureDetector(
                                            child: levelList[index].id == 1 &&
                                                        (((level1popQuizId * 100) /
                                                                    level1popQuizQue)
                                                                .ceil() ==
                                                            100) ||
                                                    levelList[index].id == 2 &&
                                                        (((level2popQuizId *
                                                                        100) /
                                                                    level2popQuizQue)
                                                                .ceil() ==
                                                            100) ||
                                                    levelList[index].id == 3 &&
                                                        (((level3popQuizId *
                                                                        100) /
                                                                    level3popQuizQue)
                                                                .ceil() ==
                                                            100) ||
                                                    levelList[index].id == 4 &&
                                                        (((level4popQuizId *
                                                                        100) /
                                                                    level4popQuizQue)
                                                                .ceil() ==
                                                            100)
                                                ? Image.asset(
                                                    AllImages.rightImage,
                                                    width: 7.w,
                                                    height: 5.h,
                                                  )
                                                : Image.asset(
                                                    AllImages.popQuiz,
                                                    width: 8.w,
                                                    height: 5.h,
                                                  ),
                                            onTap: () {
                                              levelList[index].id! <= lev
                                                  ? _updatePopQuizValue(
                                                      levelList[index].id, true)
                                                  : Container();
                                            },
                                          ),
                                        ],
                                      ),
                                      // levelList[index].id == 1
                                      //     ? Container()
                                      //     :
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 22.w),
                                            child: Text(
                                                levelList[index].id == 1
                                                    ? '${((level1popQuizId * 100) / level1popQuizQue).ceil()}% COMPLETED'
                                                    : levelList[index].id == 2
                                                        ? '${((level2popQuizId * 100) / level2popQuizQue).ceil()}% COMPLETED'
                                                        : levelList[index].id ==
                                                                3
                                                            ? '${((level3popQuizId * 100) / level3popQuizQue).ceil()}% COMPLETED'
                                                            : levelList[index]
                                                                        .id ==
                                                                    4
                                                                ? '${((level4popQuizId * 100) / level4popQuizQue).ceil()}% COMPLETED'
                                                                : levelList[index]
                                                                            .id ==
                                                                        5
                                                                    ? '${((level5Id * 100) / 36).ceil()}% COMPLETED'
                                                                    : '${((level6Id * 100) / 80).ceil()}% COMPLETED',
                                                style:
                                                    AllTextStyles.workSansSmall(
                                                  fontSize: 8.sp,
                                                  color: Color(0xffC4C4C4),
                                                )),
                                          )),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0.h,
                                  left: 14.w,
                                  child: Container(
                                    width: 48.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.w),
                                      color: Color(0xffFFF1ED),
                                      border:
                                          Border.all(color: Color(0xffFF8762)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 3.w),
                                      child: Text(
                                        '${levelList[index].level}',
                                        style: AllTextStyles.robotoSmall(
                                          size: 13.sp,
                                          color: Color(0xffFE845E),
                                        ),
                                      ),
                                    ),
                                  ),
                                  height: 6.h,
                                ),
                                Positioned(
                                  top: 0.h,
                                  left: 8.w,
                                  width: 18.w,
                                  child: Container(
                                    width: 42.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffFBC712),
                                    ),
                                    child: levelList[index].id! <= lev
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${levelList[index].id}',
                                              style: AllTextStyles.balooDa(),
                                            ),
                                          )
                                        : Container(
                                            height: 4.h,
                                            child: Image.asset(AllImages.lock)),
                                  ),
                                  height: 6.h,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _updateValue(int? i) async {
    getCredential.write('update', 0);
    DocumentSnapshot document =
        await firestore.collection('User').doc(userId).get();
    gameScore = document.get('game_score');

    firestore.collection('User').doc(userId).update({
      'replay_level': true,
      'account_balance': 0,
      'bill_payment': 0,
      'credit_card_balance': 0,
      'credit_card_bill': 0,
      'credit_score': 0,
      'level_id': 0,
      'payable_bill': 0,
      'previous_session_info': 'Level_$i\_setUp_page',
      'quality_of_life': 0,
      'score': 0,
      'level_1_id': i == 1 ? 0 : level1Id,
      'level_2_id': i == 2 ? 0 : level2Id,
      'level_3_id': i == 3 ? 0 : level3Id,
      'level_4_id': i == 4 ? 0 : level4Id,
      'level_5_id': i == 5 ? 0 : level5Id,
      'level_6_id': i == 6 ? 0 : level6Id,
    }).then((value) {
      if (i == 1)
        Get.off(
          () => LevelOneSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      if (i == 2)
        Get.off(
          () => LevelTwoSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      if (i == 3)
        Get.off(
          () => LevelThreeSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );

      if (i == 4) {
        getCredential.write('level4or5innerPageViewId', 0);
        getCredential.write('count', 0);
        Get.off(
          () => LevelFourSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      }

      if (i == 5) {
        getCredential.write('level4or5innerPageViewId', 0);
        getCredential.write('count', 0);
        Get.off(
          () => LevelFiveSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      }

      if (i == 6)
        Get.off(
          () => LevelSixSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
    });
  }

  _updatePopQuizValue(
    int? i,
    bool value,
  ) async {
    DocumentSnapshot document =
        await firestore.collection('User').doc(userId).get();
    gameScore = document.get('game_score');

    firestore.collection('User').doc(userId).update({
      'replay_level': true,
      'account_balance': 0,
      'bill_payment': 0,
      'credit_card_balance': 0,
      'credit_card_bill': 0,
      'credit_score': 0,
      'level_id': 0,
      'payable_bill': 0,
      'previous_session_info': 'Level_$i\_Pop_Quiz',
      'quality_of_life': 0,
      'score': 0,
      // 'level_1_id': i == 1 ? 0 : level1Id,
      // 'level_1_id': i == 1 ? 0 : level1Id,
      // 'level_2_id': i == 2 ? 0 : level2Id,
      // 'level_3_id': i == 3 ? 0 : level3Id,
      // 'level_4_id': i == 4 ? 0 : level4Id,
      // 'level_5_id': i == 5 ? 0 : level5Id,
      // 'level_6_id': i == 6 ? 0 : level6Id,
      'level_1_popQuiz_id': i == 1 ? 0 : level1popQuizId,
      'level_2_popQuiz_id': i == 2 ? 0 : level2popQuizId,
      'level_3_popQuiz_id': i == 3 ? 0 : level3popQuizId,
      'level_4_popQuiz_id': i == 4 ? 0 : level4popQuizId,
      'level_5_popQuiz_id': i == 5 ? 0 : level5popQuizId,
      'level_6_popQuiz_id': i == 6 ? 0 : level6popQuizId,
    }).then((value) {
      if (i == 1) {
        Get.off(
          () => LevelOnePopQuiz(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      }
      if (i == 2 || i == 3 || i == 4)
        Get.off(
          () => PopQuiz(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );

      if (i == 5)
        Get.off(
          () => LevelFiveSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
      if (i == 6)
        Get.off(
          () => LevelFourSetUpPage(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
        );
    });
  }
}

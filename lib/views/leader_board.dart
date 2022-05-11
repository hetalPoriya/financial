import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/models/ranking_user.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:numeral/numeral.dart';

class LeaderBoard extends StatefulWidget {
  String userName;

  LeaderBoard({Key? key, required this.userName}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  bool getUser = false;
  String? userName;
  String? user;
  String? userId;
  List<RankingUser> totalUsers = [];
  List<RankingUser> topTen = [];
  List<RankingUser> currentUserRank = [];
  int rank = 0;
  int netWorth = 0;
  int savings = 0;
  int lifestyleScore = 0;
  int credit = 0;
  int gameScore = 0;

  TextEditingController textEditingController = TextEditingController();

  // Future<void> getUserName() async {
  //   userId = GetStorage().read('uId');
  //   print('uer $userId');
  //   DocumentSnapshot shot =
  //       await FirebaseFirestore.instance.collection("User").doc(userId).get();
  //   userName = shot.get('user_name');
  //   if (userName.toString().isNotEmpty) {
  //     getTopRankingUser();
  //   }
  // }

  getTopRankingUser() async {
    RankingUser rankingUser;
    QuerySnapshot<Map<String, dynamic>>? l1 =
        await firestore.collection('User').get();
    userId = GetStorage().read('uId');
    print('uer $userId');
    int totalAuth = l1.size;
    QuerySnapshot snap = await firestore.collection('User').get();
    DocumentSnapshot documentSnapshot;
    snap.docs.forEach((document) async {
      documentSnapshot =
          await firestore.collection('User').doc(document.id).get();
      Object? map = documentSnapshot.data();
      setState(() {
        gameScore = documentSnapshot.get('game_score');
        savings = documentSnapshot.get('account_balance');
        credit = documentSnapshot.get('credit_score');
        lifestyleScore = documentSnapshot.get('quality_of_life');

        if (map.toString().contains('user_name')) {
          print('true');
          user = documentSnapshot.get('user_name');
        } else {
          user = document.id;
        }

        if (map.toString().contains('investment')) {
          netWorth = documentSnapshot.get('investment');
        } else {
          netWorth = documentSnapshot.get('net_worth');
        }

        rankingUser = RankingUser(
            gameScore: gameScore,
            userName: user,
            userId: document.id,
            credit: credit,
            lifeStyleScore: lifestyleScore,
            netWorth: netWorth,
            savings: savings);
        totalUsers.add(rankingUser);

        print('total user ${totalUsers.length}');
        if (totalUsers.isNotEmpty && totalUsers.length == totalAuth) {
          totalUsers.sort((a, b) {
            return -a.gameScore!.compareTo(b.gameScore!);
            //softing on alphabetical order (Ascending order by Name String)
          });

          for (int i = 0; i < totalUsers.length; i++) {
            rank = rank + 1;
            if (totalUsers[i].userId == userId) {
              print('HHHHHH ${totalUsers[i].userName}');
              currentUserRank.add(RankingUser(
                  rank: rank,
                  userName: totalUsers[i].userName,
                  userId: totalUsers[i].userId,
                  gameScore: totalUsers[i].gameScore,
                  credit: totalUsers[i].credit,
                  lifeStyleScore: totalUsers[i].lifeStyleScore,
                  netWorth: totalUsers[i].netWorth,
                  savings: totalUsers[i].savings));
              print('UUUUUUUUU ${currentUserRank[0].rank}');
            }
            totalUsers[i].rank = rank;
          }
          print('Tptal Users ${totalUsers.toList()}');
          topTen = totalUsers.sublist(0, 10);
          //print('Items ${items.length}');
          for (int i = 0; i < totalUsers.length; i++) {
            print('UserName ${totalUsers[i].userName} ');
            print('gameScore ${totalUsers[i].gameScore}');
            print('rank ${totalUsers[i].rank}');
          }
        }
      });

      // if(l1 == )
      // print('abc ${totalUsers.length}');
    });
    // if(totalUsers.firstWhere((p) => p.userId == userId) == true){
    //   print('a')
    // }
  }

  @override
  void initState() {
    // print('USER ${widget.userName}');
    // if (widget.userName.toString().isNotEmpty) {
    getTopRankingUser();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Leaderboard', style: AllTextStyles.settingsAppTitle()),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          alignment: Alignment.center,
          decoration: boxDecoration,
          height: 100.h,
          width: 100.w,
          child: StatefulBuilder(builder: (con, _setState) {
            return topTen.length == 0
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            children: [
                              if (widget.userName.isNotEmpty)
                                Text(
                                    'Your rank is : ${currentUserRank[0].rank.toString()}',
                                    style: AllTextStyles.robotoMedium(
                                        color: Colors.white)),
                              if (widget.userName.isNotEmpty)
                                SizedBox(
                                  height: 1.h,
                                ),
                              if (widget.userName.isNotEmpty)
                                leaderBoardWidget(
                                    rank: currentUserRank[0].rank,
                                    userName: widget.userName,
                                    gameScore: currentUserRank[0].gameScore,
                                    savings: currentUserRank[0].savings,
                                    netWorth: currentUserRank[0].netWorth,
                                    creditScore: currentUserRank[0].credit,
                                    lifestyleScore:
                                        currentUserRank[0].lifeStyleScore),
                              SizedBox(
                                height: 2.h,
                              ),
                              ListView.builder(
                                  itemCount: topTen.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (con, index) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.h),
                                      child: Align(
                                          child: leaderBoardWidget(
                                              rank: topTen[index].rank,
                                              userName: (textEditingController
                                                          .text.isNotEmpty &&
                                                      userId ==
                                                          topTen[index].userId)
                                                  ? textEditingController.text
                                                  : topTen[index].userName,
                                              gameScore:
                                                  topTen[index].gameScore,
                                              savings: topTen[index].savings,
                                              netWorth: topTen[index].netWorth,
                                              creditScore: topTen[index].credit,
                                              lifestyleScore: topTen[index]
                                                  .lifeStyleScore)),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      if (widget.userName.isEmpty)
                        Container(
                          //  width: 100.w,
                          // height: 100.h,
                          color: Colors.white60,
                          child: Center(
                            child: Container(
                              height: 25.h,
                              width: 86.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Leaderboard',
                                          style: AllTextStyles.robotoMedium(
                                              color: Colors.white,
                                              fontSize: 16.sp),
                                          textAlign: TextAlign.center),
                                      Text(
                                          'please enter your name to view leaderboard rankings.',
                                          style: AllTextStyles.robotoSmall(
                                              color: Colors.white),
                                          textAlign: TextAlign.center),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 6.h,
                                            width: 50.w,
                                            child: TextFormField(
                                              style: AllTextStyles
                                                  .dialogStyleSmall(
                                                      size: 13.sp,
                                                      color: Colors.white),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    new EdgeInsets.symmetric(
                                                        vertical: 2.h,
                                                        horizontal: 1.h),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    2.w)),
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xffe8eafd))),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    2.w)),
                                                        borderSide: BorderSide(
                                                          color: Colors.white,
                                                        )),
                                                //fillColor: Color(0xffe8eafd),

                                                hintStyle: AllTextStyles
                                                    .dialogStyleSmall(
                                                        size: 13.sp,
                                                        color: Colors.white),
                                                hintText: " Enter your name",
                                              ),
                                              controller: textEditingController,
                                              keyboardType: TextInputType.text,
                                              cursorColor:
                                                  AllColors.leaderBoardConColor,
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          AllColors
                                                              .whiteLight2)),
                                              onPressed: () {
                                                print(
                                                    'textEditingController.text ${textEditingController.text}');
                                                userId =
                                                    GetStorage().read('uId');
                                                print(
                                                    'textEditingController.text ${userId}');
                                                firestore
                                                    .collection('User')
                                                    .doc(userId)
                                                    .update({
                                                  'user_name':
                                                      textEditingController.text
                                                });
                                                _setState(() {
                                                  getTopRankingUser();
                                                  widget.userName =
                                                      textEditingController
                                                          .text;
                                                  // textEditingController.clear();

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
                                                      .dialogStyleSmall(
                                                          color: Colors.black)))
                                        ],
                                      )
                                    ]),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  6.w,
                                ),
                                color: AllColors.lightBlue2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
          })),
    ));
  }
}

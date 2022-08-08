import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../cutom_screens/custom_screens.dart';
import '../../utils/utils.dart';

class LeaderBoard extends StatelessWidget {
  String userName;
  String userId;

  LeaderBoard({Key? key, required this.userName, required this.userId})
      : super(key: key);

  bool? user;
  bool? netWorth;
  int currentUserId = 0;
  var document;

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Leaderboard', style: AllTextStyles.settingsAppTitleInter()),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          alignment: Alignment.center,
          decoration: boxDecoration,
          height: 100.h,
          width: 100.w,
          child: Stack(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('User')
                      .orderBy('game_score', descending: true)
                      .snapshots(),
                  builder: (i, snap) {
                    if (snap.hasError) {
                      return Text('It\'s Error!');
                    }
                    switch (snap.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
                              backgroundColor: AllColors.blue),
                        );
                      default:
                        snap.data!.docs.asMap().entries.map((e) {
                          print('ID ${e.key}');
                          print('ID ${e.value.id}');
                          if (userId == e.value.id) {
                            currentUserId = e.key;
                          }
                        }).toList();

                        return Center(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snap.data!.docs.length,
                              itemBuilder: (con, index) {
                                document = snap.data!.docs[index];
                                Map<String, dynamic> map = document.data();
                                if (map.containsKey('user_name')) {
                                  user = true;
                                } else {
                                  user = false;
                                }
                                if (map.containsKey('net_worth')) {
                                  netWorth = true;
                                } else {
                                  netWorth = false;
                                }
                                return (index <= 2 ||
                                        currentUserId == index - 1 ||
                                        currentUserId == index ||
                                        currentUserId == index + 1)
                                    ? Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.h),
                                        child: Align(
                                            child: leaderBoardWidget(
                                          userOrNot: document.id == userId
                                              ? true
                                              : false,
                                          color: document.id == userId
                                              ? AllColors.leaderBoardColor
                                              : Colors.white,
                                          rank: index,
                                          userName: (textEditingController
                                                      .text.isNotEmpty &&
                                                  document.id == userId)
                                              ? textEditingController.text
                                              : user == true
                                                  ? document['user_name'] == ''
                                                      ? 'Anonymous'
                                                      : document['user_name']
                                                  : 'Anonymous',
                                          gameScore: document['game_score'],
                                          savings: document['account_balance'],
                                          netWorth: netWorth == true
                                              ? document['net_worth']
                                              : document['investment'],
                                          creditScore: document['credit_score'],
                                          lifestyleScore:
                                              document['quality_of_life'],
                                        )))
                                    : Container();
                              }),
                        );
                    }
                  }),
              StatefulBuilder(builder: (context, _setState) {
                return userName.isEmpty
                    ? Container(
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
                                        style: AllTextStyles.robotoMedium()
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 16.sp),
                                        textAlign: TextAlign.center),
                                    Text(
                                        'please enter your name to view leaderboard rankings.',
                                        style: AllTextStyles.robotoSmall()
                                            .copyWith(color: Colors.white),
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
                                                    .workSansExtraSmall()
                                                .copyWith(
                                                    fontSize: 13.sp,
                                                    color: Colors.white),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  new EdgeInsets.symmetric(
                                                      vertical: 2.h,
                                                      horizontal: 1.h),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2.w)),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Color(0xffe8eafd))),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2.w)),
                                                  borderSide: BorderSide(
                                                    color: Colors.white,
                                                  )),
                                              //fillColor: Color(0xffe8eafd),

                                              hintStyle: AllTextStyles
                                                      .workSansExtraSmall()
                                                  .copyWith(
                                                      fontSize: 13.sp,
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
                                                        AllColors.whiteLight2)),
                                            onPressed: () {
                                              print(
                                                  'textEditingController.text ${textEditingController.text}');
                                              userId = Prefs.getString(PrefString.userId)!;
                                              print(
                                                  'textEditingController.text ${userId}');
                                              firestore
                                                  .collection('User')
                                                  .doc(userId)
                                                  .update({
                                                'user_name':
                                                    textEditingController.text
                                              });

                                              //getTopRankingUser();

                                              _setState(() {
                                                userName =
                                                    textEditingController.text;
                                              });
                                              // textEditingController.clear();

                                              // DocumentSnapshot snap =
                                              //     await firestore
                                              //         .collection('User')
                                              //         .doc(userId)
                                              //         .get();
                                              // userName =
                                              //     snap.get('user_name');
                                            },
                                            child: Text('Submit',
                                                style: AllTextStyles
                                                        .workSansExtraSmall()
                                                    .copyWith(
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
                      )
                    : Container();
              })
            ],
          )),
    ));
  }
}

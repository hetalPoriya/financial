import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:financial/shareable_screens/game_score_page.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/models/que_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'local_notify_manager.dart';

class LevelOnePopQuiz extends StatefulWidget {
  LevelOnePopQuiz({
    Key? key,
  }) : super(key: key);

  @override
  _LevelOnePopQuizState createState() => _LevelOnePopQuizState();
}

class _LevelOnePopQuizState extends State<LevelOnePopQuiz>
    with SingleTickerProviderStateMixin {

  //for model
  QueModel? queModel;
  List<QueModel> list = [];
  String popQuiz = '';

  var document;
  var userId;
  int levelId = 0;
  var getCredential = GetStorage();

  //page controller
  PageController controller = PageController();

  Color color1 = Colors.white;
  Color color2 = Colors.white;
  int optionSelect = 0;

   getLevelId() async {
    userId = getCredential.read('uId');
    DocumentSnapshot snap =
        await firestore.collection('User').doc(userId).get();
    popQuiz = snap.get('previous_session_info');
    levelId = snap.get('level_id');
    print('Level Id $levelId');
    controller = PageController(initialPage: levelId);

    QuerySnapshot querySnapshot =
        await firestore.collection("Level_1_Pop_Quiz").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      queModel = QueModel();
      queModel?.id = a['id'];
      setState(() {
        list.add(queModel!);

      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLevelId();
  }

  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Container(
        decoration: boxDecoration,
        child: list.isEmpty
            ? Center(
            child: CircularProgressIndicator(
                backgroundColor: AllColors.blue))
            : StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('Level_1_Pop_Quiz')
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

              return PageView.builder(
                  itemCount: snapshot.data?.docs.length,
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      optionSelect = 0;
                      color1 = Colors.white;
                      color2 = Colors.white;
                    });
                  },
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
                                GameScorePage(
                                  level: popQuiz,
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 80.w,
                                  height: 62.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
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
                                              document['description'],
                                              style: AllTextStyles
                                                  .workSansMediumBlack(),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ),
                                        StatefulBuilder(
                                            builder: (context, _setState) {
                                          String ans = document['correct_ans'];
                                          return Column(
                                            children: [
                                              options(() {
                                                _checkCorrectAnswer(
                                                    ans, _setState, 1);
                                              }, index, document['option_1'],
                                                  color1, 1),
                                              options(() {
                                                _checkCorrectAnswer(
                                                    ans, _setState, 2);
                                              }, index, document['option_2'],
                                                  color2, 2),
                                            ],
                                          );
                                        }),
                                        SizedBox(
                                          height: 1.h,
                                        )
                                      ],
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
                                      borderRadius: BorderRadius.circular(8.w),
                                    ),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (index ==
                                              snapshot.data!.docs.length - 1) {
                                            // await localNotifyManager.flutterLocalNotificationsPlugin.cancel(21);
                                            // await localNotifyManager.repeatNotificationLevel2();
                                            await localNotifyManager.flutterLocalNotificationsPlugin.cancel(1);
                                            await localNotifyManager.flutterLocalNotificationsPlugin.cancel(7);
                                            await localNotifyManager.scheduleNotificationForLevelTwoSaturdayElevenAm();
                                            await localNotifyManager.scheduleNotificationForLevelTwoWednesdaySevenPm();
                                            firestore
                                                .collection('User')
                                                .doc(userId)
                                                .update({
                                              'level_id': index + 1,
                                              'level_1_popQuiz_id': index + 1,
                                              'previous_session_info':
                                                  'Level_2_setUp_page'
                                            }).then((value) => Future.delayed(
                                                    Duration(milliseconds: 500),
                                                    () => Get.offNamed(
                                                        '/Level2SetUp')));
                                          } else {
                                            firestore
                                                .collection('User')
                                                .doc(userId)
                                                .update({
                                              'level_id': index + 1,
                                              'level_1_popQuiz_id': index + 1,
                                            });
                                            controller.nextPage(
                                                duration: Duration(seconds: 1),
                                                curve: Curves.easeIn);
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color:AllColors.blue,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.w)))),
                                        child: Text('Tap To Move Next Question',
                                            style: AllTextStyles.workSansSmall(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                              color: AllColors.extraDarkPurple,
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

  _checkCorrectAnswer(String ans, StateSetter _setState, int i) {
    Color one = AllColors.green;
    Color two = AllColors.red;

    _setState(() {
      optionSelect = i;
      if (ans == 'a') {
        color1 = one;
        color2 = two;
      } else {
        color1 = two;
        color2 = one;
      }
    });
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
                  color: optionSelect == 0 ? AllColors.whiteLight2 : color,
                  borderRadius: BorderRadius.circular(3.w)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                  child: Text(
                    document,
                    style: AllTextStyles.workSansSmall(
                        color: optionSelect != 0
                            ? Colors.white
                            :AllColors.extraDarkPurple,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ));
}

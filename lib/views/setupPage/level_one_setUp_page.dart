import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../cutom_screens/custom_screens.dart';
import '../../utils/utils.dart';
import '../levels/levels.dart';

class LevelOneSetUpPage extends StatefulWidget {
  LevelOneSetUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LevelOneSetUpPage> createState() => _LevelOneSetUpPageState();
}

class _LevelOneSetUpPageState extends State<LevelOneSetUpPage> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SetUpPage(
        color: color,
        level: 'Level 1',
        levelText: AllStrings.level1SetUp,
        container: Container(
          child: Padding(
            padding: EdgeInsets.only(right: 04.w, left: 04.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 6.h,
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.red,
                      alignment: Alignment.center,
                      child: Text(
                        AllStrings.levelOneText1,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansMedium()
                            .copyWith(fontSize: 16.sp),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.green,
                      alignment: Alignment.center,
                      child: Text(
                        AllStrings.levelOneText2,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmallBlack(),
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                      // color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Text(AllStrings.levelOneText3,
                          textAlign: TextAlign.center,
                          style: AllTextStyles.workSansSmallBlack()
                              .copyWith(fontWeight: FontWeight.w400)),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      // color: Colors.red,
                      alignment: Alignment.center,
                      child: Text(AllStrings.levelOneText4,
                          textAlign: TextAlign.center,
                          style: AllTextStyles.workSansSmallBlack()
                              .copyWith(fontWeight: FontWeight.w500)),
                    )),
                Spacer(),
                Spacer(),
              ],
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            color = AllColors.green;
          });
          userId = Prefs.getString(PrefString.userId);
          await Prefs.setInt(PrefString.updateValue, 0);

          firestore.collection('User').doc(userId).get().then((doc) {
            bool value = doc.get('replay_level');
            firestore.collection('User').doc(userId).update({
              'account_balance': 200,
              'need': 0,
              'want': 0,
              'quality_of_life': 0,
              'level_id': 0,
              'level_1_id': 0,
              'previous_session_info': 'Level_1',
              if (value != true) 'last_level': 'Level_1',
            }).then((value) async {
              await Prefs.setInt(PrefString.totalBalanceForUser, 0);
              await Prefs.setInt(PrefString.totalQolForUser, 0);
              await Prefs.setInt(PrefString.totalInvestmentForUser, 0);
              await Prefs.setInt(PrefString.totalCreditForUser, 0);
              await Prefs.setInt(PrefString.countForUser, 0);

              getUser(levelId: 1).then((value) => Get.offAll(
                    () => AllQueLevelOne(),
                    duration: Duration(milliseconds: 250),
                    transition: Transition.downToUp,
                  ));
            });
          });
        },
        buttonText: 'Start Spending',
      ),
    );
  }
}

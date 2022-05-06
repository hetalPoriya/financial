import 'package:financial/controllers/user_info_controller.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/setUp_page.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/all_que_level_one.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

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
    return SetUpPage(
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
                      style: AllTextStyles.workSansMedium(),
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
                      style: AllTextStyles.workSansSmall(),
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    // color: Colors.yellow,
                    alignment: Alignment.center,
                    child: Text(AllStrings.levelOneText3,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmall(
                            fontWeight: FontWeight.w400)),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(AllStrings.levelOneText4,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmall(
                            fontWeight: FontWeight.w500)),
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
        var storeValue = GetStorage();
        userId = storeValue.read('uId');
        storeValue.write('update', 0);
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
          }).then((value) {
            storeValue.write('tBalance', 0);
            storeValue.write('tQol', 0);
            storeValue.write('tInvestment', 0);
            storeValue.write('tCredit', 0);
            storeValue.write('tUser', 0);
            getUser(1).then((value) => Get.off(
                  () => AllQueLevelOne(),
                  duration: Duration(milliseconds: 250),
                  transition: Transition.downToUp,
                ));
          });
        });
      },
      buttonText: 'Start Spending',
    );
  }
}


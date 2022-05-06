import 'package:financial/ReusableScreen/CommanClass.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/utils/AllStrings.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:financial/views/AllQueLevelOne.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class LevelOneSetUpPage extends StatelessWidget {
  LevelOneSetUpPage({Key? key,}) : super(key: key);

  var userId;
  final getData = GetStorage();


  @override
  Widget build(BuildContext context) {
    return SetUpPage(
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
                      style:AllTextStyles.workSansMedium(),
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
                    child: Text(
                        AllStrings.levelOneText3,
                      textAlign: TextAlign.center,
                      style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w400)
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(
                        AllStrings.levelOneText4,
                      textAlign: TextAlign.center,
                      style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w500)
                    ),
                  )),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
      onPressed: () async {
        var storeValue = GetStorage();
        userId =  storeValue.read('uId');
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
            getUser(1).then((value) =>  Get.off(
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
// import 'package:financial/ReusableScreen/CommanClass.dart';
// import 'package:financial/ReusableScreen/GlobleVariable.dart';
// import 'package:financial/controllers/UserInfoController.dart';
// import 'package:financial/utils/AllStrings.dart';
// import 'package:financial/utils/AllTextStyle.dart';
// import 'package:financial/views/AllQueLevelOne.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:sizer/sizer.dart';
//
// class LevelOneSetUpPage extends StatelessWidget {
//   LevelOneSetUpPage({Key? key,}) : super(key: key);
//
//   final userInfo = Get.put<UserInfoController>(UserInfoController());
//  // GetStorage getCredential= GetStorage();
//
//   @override
//   Widget build(BuildContext context) {
//     return SetUpPage(
//       level: 'Level 1',
//       levelText: AllStrings.level1SetUp,
//       container: Container(
//         child: Padding(
//           padding: EdgeInsets.only(right: 04.w, left: 04.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 6.h,
//               ),
//               Expanded(
//                   flex: 2,
//                   child: Container(
//                     // color: Colors.red,
//                     alignment: Alignment.center,
//                     child: Text(
//                       AllStrings.levelOneText1,
//                       textAlign: TextAlign.center,
//                       style:AllTextStyles.workSansMedium(),
//                     ),
//                   )),
//               Expanded(
//                   flex: 1,
//                   child: Container(
//                     // color: Colors.green,
//                     alignment: Alignment.center,
//                     child: Text(
//                       AllStrings.levelOneText2,
//                       textAlign: TextAlign.center,
//                       style: AllTextStyles.workSansSmall(),
//                     ),
//                   )),
//               Expanded(
//                   flex: 3,
//                   child: Container(
//                     // color: Colors.yellow,
//                     alignment: Alignment.center,
//                     child: Text(
//                         AllStrings.levelOneText3,
//                         textAlign: TextAlign.center,
//                         style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w400)
//                     ),
//                   )),
//               Expanded(
//                   flex: 2,
//                   child: Container(
//                     // color: Colors.red,
//                     alignment: Alignment.center,
//                     child: Text(
//                         AllStrings.levelOneText4,
//                         textAlign: TextAlign.center,
//                         style: AllTextStyles.workSansSmall(fontWeight: FontWeight.w500)
//                     ),
//                   )),
//               Spacer(),
//               Spacer(),
//             ],
//           ),
//         ),
//       ),
//       onPressed: () async {
//         userInfo.getCredential.write('update', 0);
//         firestore.collection('User').doc(userInfo.userId).get().then((doc) {
//           bool value = doc.get('replay_level');
//           firestore.collection('User').doc(userInfo.userId).update({
//             'account_balance': 200,
//             'need': 0,
//             'want': 0,
//             'quality_of_life': 0,
//             'level_id': 0,
//             'level_1_id': 0,
//             'previous_session_info': 'Level_1',
//             if (value != true) 'last_level': 'Level_1',
//           }).then((value) {
//             userInfo.getCredential.write('tBalance', 0);
//             userInfo.getCredential.write('tQol', 0);
//             userInfo.getCredential.write('tInvestment', 0);
//             userInfo.getCredential.write('tCredit', 0);
//             userInfo.getCredential.write('tUser', 0);
//             userInfo.updateValue = 0;
//             userInfo.update();
//             getUser(1).then((value) =>  Get.offAll(
//                   () => AllQueLevelOne(),
//               duration: Duration(milliseconds: 250),
//               transition: Transition.downToUp,
//             ));
//           });
//         });
//       },
//       buttonText: 'Start Spending',
//     );
//
//   }
// }

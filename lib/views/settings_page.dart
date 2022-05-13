import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/models/settings_model.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/leader_board.dart';
import 'package:financial/views/levels.dart';
import 'package:financial/views/rate_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  List<SettingsModel> settingsModel = [
    SettingsModel(
        id: 1,
        title: AllStrings.levels,
        description: AllStrings.profileDes,
        image: AllImages.levels),
    SettingsModel(
        id: 2,
        title: AllStrings.leaderBoard,
        description: AllStrings.leaderBoardDes,
        image: AllImages.leaderBoard),
    SettingsModel(
        id: 3,
        title: AllStrings.feedback,
        description: AllStrings.feedbackDes,
        image: AllImages.feedback),
    SettingsModel(
        id: 4,
        title: AllStrings.share,
        description: AllStrings.shareDes,
        image: AllImages.share),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Dashboard',
            style: AllTextStyles.settingsAppTitle()),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AllColors.settingsPageColor1,
              AllColors.settingsPageColor2,
              AllColors.settingsPageColor3
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Align(
            alignment: Alignment.center,
            child: ListView.builder(
                itemCount: settingsModel.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    //color: AllColors.green,
                    child: Align(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (settingsModel[index].id == 1) {
                              Get.to(() => Levels());
                            }
                            if (settingsModel[index].id == 2) {
                              var userId = GetStorage().read('uId');
                              print('uer $userId');
                              DocumentSnapshot shot = await firestore
                                  .collection("User")
                                  .doc(userId)
                                  .get();
                              String userName = shot.get('user_name');
                              Get.to(() => LeaderBoard(userName: userName,userId : userId));
                            }
                            if (settingsModel[index].id == 3) {
                              Get.to(() => RateUs(onSubmit: () {}));
                            }
                            if (settingsModel[index].id == 4) {
                              FlutterShare.share(
                                  title: 'https://play.google.com/store/apps/details?id=com.finshark',
                                  text: AllStrings.shareAppDesText,
                                  linkUrl: 'https://play.google.com/store/apps/details?id=com.finshark',
                                  chooserTitle: 'https://play.google.com/store/apps/details?id=com.finshark')
                                  .then((value) {
                                // Future.delayed(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LevelThreeSetUpPage(controller: PageController()))));
                              });
                            }
                          },
                          child: Container(
                            height: 14.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                                color: AllColors.purple,
                                borderRadius: BorderRadius.circular(4.w)),
                            child: Row(children: [
                              Expanded(
                                child: Container(
                                    child: Image.asset(
                                  settingsModel[index].image.toString(),
                                  height: 9.h,
                                  //width: 19.w,
                                )),
                                flex: 1,
                              ),
                              Expanded(
                                child: Container(
                                  // /color: AllColors.green,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            settingsModel[index]
                                                .title
                                                .toString(),
                                            style:
                                                AllTextStyles.settingTitle()),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                            settingsModel[index]
                                                .description
                                                .toString(),
                                            style: AllTextStyles.settingDes()),
                                      ]),
                                ),
                                flex: 3,
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                      ],
                    )),
                  );
                }),
          )),
    ));
  }
}

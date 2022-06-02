//ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class ExpandedBottomDrawer extends StatefulWidget {
  ExpandedBottomDrawer({Key? key}) : super(key: key);

  @override
  _ExpandedBottomDrawerState createState() => _ExpandedBottomDrawerState();
}

class _ExpandedBottomDrawerState extends State<ExpandedBottomDrawer> {
  var userId;

  var format = NumberFormat.currency(locale: 'HI',decimalDigits: 0,name: '');
  int? creditScore;
  String level = '';
  int levelId = 0;
  var storeValue = GetStorage();
  List<BottomDrawer> info = [];

  getUserValue() async {
    userId = storeValue.read('uId');
    DocumentSnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();
    setState(() {
      level = querySnapshot.get('previous_session_info');
      levelId = querySnapshot.get('level_id');
      if (level == 'Level_1' || level == 'Level_2')
        info = [balance, qol, gameScore];
      if (level == 'Level_3') info = [balance, qol, credit, gameScore];
      if (level == 'Level_4' || level == 'Level_5')
        info = [balance, qol, netWorth, gameScore];
    });
  }

  BottomDrawer balance = BottomDrawer(
      id: 1,
      image: AllImages.saveMoney,
      info: AllStrings.accountBalanceText,
      text: AllStrings.accountBalance);
  BottomDrawer qol = BottomDrawer(
      id: 2,
      image: AllImages.symbol,
      info: AllStrings.lifeStyleScoreText,
      text: AllStrings.lifeStyleScore);
  BottomDrawer credit = BottomDrawer(
      id: 3,
      image: AllImages.creditScore,
      info: AllStrings.creditScoreText,
      text: AllStrings.creditScore);
  BottomDrawer netWorth = BottomDrawer(
      id: 4,
      image: AllImages.netWorth,
      info: AllStrings.netWorthText,
      text: AllStrings.investment);
  BottomDrawer gameScore = BottomDrawer(
      id: 5,
      image: AllImages.star,
      info: AllStrings.gameScoreText,
      text: AllStrings.gameScore);

  @override
  void initState() {
    getUserValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AllColors.blue,
              AllColors.purple,
              AllColors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.0))),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.keyboard_arrow_down,
            size: 10.w,
            color: AllColors.lightPurple,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: info.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              child: Image.asset(
                                '${info[index].image}',
                                width: 10.w,
                                height: 9.h,
                                fit: BoxFit.contain,
                              ),
                              //  color: Colors.green,
                            ),
                            flex: 2,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Expanded(
                            child: Container(
                              height: 9.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0) _savingBalance(),
                                  if (index == 1) _qualityOfLife(),
                                  if ((level == 'Level_1' ||
                                          level == 'Level_2') &&
                                      index == 2)
                                    _gameScore(),
                                  if (level == 'Level_3' && index == 2)
                                    _creditScore(),
                                  if ((level == 'Level_4' ||
                                          level == 'Level_5') &&
                                      index == 2)
                                    _netWorth(),
                                  if ((level == 'Level_3' ||
                                          level == 'Level_4' ||
                                          level == 'Level_5') &&
                                      index == 3)
                                    _gameScore(),
                                  Text(
                                    '${info[index].text}',
                                    style: AllTextStyles.dialogStyleSmall(
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              // color: Colors.red,
                            ),
                            flex: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: Tooltip(
                                message: '${info[index].info}',
                                //height: 4.h,
                                triggerMode: TooltipTriggerMode.tap,
                                textStyle: AllTextStyles.dialogStyleSmall(
                                  fontWeight: FontWeight.w400,
                                  color: AllColors.extraDarkBlue,
                                ),
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.w),
                                ),
                                preferBelow: false,
                                verticalOffset: 2.h,
                                //margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Image.asset(
                                  AllImages.iImage,
                                  width: 11.w,
                                  height: 3.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              //color: Colors.blue,
                              alignment: Alignment.center,
                              height: 9.h,
                            ),
                            flex: 3,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  _savingBalance() {
    return getValues('account_balance', AllColors.darkYellow);
  }

  _creditScore() {
    return getValues('credit_score', AllColors.lightGreen);
  }

  _gameScore() {
    return getValues('game_score', AllColors.cosmicLatte);
  }

  _netWorth() {
    return getValues('investment', AllColors.orange);
  }

  _qualityOfLife() {
    return getValues('quality_of_life', AllColors.extraLightBlue);
  }

  Widget getValues(String text, Color color) => StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('User').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('It\'s Error!');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: Padding(
                padding: EdgeInsets.only(bottom: 2.w),
                child: SizedBox(
                  height: 3.h,
                  width: 6.w,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white10,
                    color: Colors.white10,
                  ),
                ),
              ));
            default:
              return Container(
                child: text == 'account_balance'
                    ? RichText(
                        text: TextSpan(
                            text:  country == 'India'
                                ? '\u{20B9}' : country == 'Europe'? '\€'
                                : '\$',
                            style: AllTextStyles.dialogStyleMedium(
                              color: color,
                              size: 16.sp,
                            ),
                            children: [
                              TextSpan(
                                text: format
                                    .format(snapshot.data![text]),
                                style: AllTextStyles.dialogStyleExtraLarge(
                                    size: 16.sp, color: color),
                              )
                            ]),
                      )
                    : Text(
                  text == 'game_score'
                      ? snapshot.data![text].toString()
                      : format.format(snapshot.data![text]),
                        style: AllTextStyles.dialogStyleExtraLarge(
                            size: 16.sp, color: color),
                      ),
              );
          }
        },
      );
}

class BottomDrawer {
  int? id;
  String? image;
  String? text;
  String? info;

  BottomDrawer({this.id, this.image, this.text, this.info});

  factory BottomDrawer.fromJson(Map<String, dynamic> json) => BottomDrawer(
        id: json["id"],
        image: json["image"],
        text: json["text"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "text": text,
        "info": info,
      };
}

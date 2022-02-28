//ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ExpandedBottomDrawer extends StatefulWidget {
  ExpandedBottomDrawer({Key? key}) : super(key: key);

  @override
  _ExpandedBottomDrawerState createState() => _ExpandedBottomDrawerState();
}

class _ExpandedBottomDrawerState extends State<ExpandedBottomDrawer> {
  var userId;
  int? _qol;
  int? _gameS;
  int? _accountBal;
  int? creditScore;
  String level = '';
  int levelId = 0;
  var storeValue = GetStorage();
  List<BottomDrawer> info = [];

  getUserValue() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    userId = storeValue.read('uId');
    DocumentSnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("User").doc(userId).get();
    setState(() {
      // _qol = querySnapshot.get('quality_of_life');
      // _accountBal = querySnapshot.get('account_balance');
      // _gameS = querySnapshot.get('game_score');
      // creditScore = querySnapshot.get('credit_score');
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
      image: 'assets/saveMoney.png',
      info:
          'This is your bank balance. Every time you make a purchase the corresponding amount will be deducted from here.',
      text: 'Account Balance');
  BottomDrawer qol = BottomDrawer(
      id: 2,
      image: 'assets/symbol.png',
      info:
          'This indicates your standard of living. The more expensive choices in the game earn higher Quality of Life points. ',
      text: 'Quality Of Life');
  BottomDrawer credit = BottomDrawer(
      id: 3,
      image: 'assets/credit_score.png',
      info:
          'This represents how well you use your Credit Card which depends on various factors. Read the Insights Cards to learn how to maximize your Credit Score.',
      text: 'Credit Score');
  BottomDrawer netWorth = BottomDrawer(
      id: 4,
      image: 'assets/netWorth.png',
      info:
          'This indicates your overall financial situation. Acquire more assets and keep your liabilities low to earn a high Net Worth Score.',
      text: 'Investment');
  BottomDrawer gameScore = BottomDrawer(
      id: 5,
      image: 'assets/star.png',
      info:
          'This is the total of the above scores. You need to balance individual scores to maximize your game score.',
      text: 'Game Score');

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
              Color(0xff4D6EF2),
              Color(0xff6448E8),
              Color(0xff6448E8),
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
            color: Color(0xffC3A7FF),
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
                                  if ((level == 'Level_1' || level == 'Level_2') && index == 2)
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
                                    style: GoogleFonts.workSans(
                                        color: Colors.white,
                                        fontSize: 12.sp,
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
                                textStyle: GoogleFonts.workSans(
                                    color: Color(0xff000072),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.w),
                                ),
                                preferBelow: false,
                                verticalOffset: 2.h,
                                //margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Image.asset(
                                  'assets/i.png',
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
    return getValues('account_balance', Color(0xffFEBE16));
  }

  _creditScore() {
    return getValues('credit_score', Color(0xff28D38B));
  }

  _gameScore() {
    return getValues('game_score', Color(0xffFFE9CF));
  }

  _netWorth() {
    return getValues('investment', Color(0xffFF627F));
  }

  _qualityOfLife() {
    return getValues('quality_of_life', Color(0xff3FAEFF));
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
                child: Text(
                  text == 'account_balance'
                      ? '${'\$${snapshot.data![text].toString()}'}'
                          : '${snapshot.data![text].toString()}',
                  style: GoogleFonts.robotoCondensed(
                      color: color,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
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

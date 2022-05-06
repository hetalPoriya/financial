//ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllImages.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

class PreviewOfBottomDrawer extends StatefulWidget {
  GlobalKey? keyValue;

  PreviewOfBottomDrawer({Key? key, this.keyValue}) : super(key: key);

  @override
  _PreviewOfBottomDrawerState createState() => _PreviewOfBottomDrawerState();
}

class _PreviewOfBottomDrawerState extends State<PreviewOfBottomDrawer>
    with SingleTickerProviderStateMixin {
  var userId;
  // int? _qol;
  // int? _accountBal;
  int? levelId;
  int? creditScore;
  int? netWorth;
  int? mutualFund;
  String level = '';
  int innerId = 0;
  var storeValue = GetStorage();
  bool? showCase;
  int? showCaseId;

  getUserValue() async {
    userId = storeValue.read('uId');
    DocumentSnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("User").doc(userId).get();

    setState(() {
      //   _qol = querySnapshot.get('quality_of_life');
      //   _accountBal = querySnapshot.get('account_balance');
      //   creditScore = querySnapshot.get('credit_score');
      level = querySnapshot.get('previous_session_info');
      levelId = querySnapshot.get('level_id');
      innerId = storeValue.read('level4or5innerPageViewId');
    });
  }

  initState() {
    super.initState();
    getUserValue();
    showCase = GetStorage().read('showCase');
    showCaseId = GetStorage().read('showCaseId');
    (showCase == false && showCaseId == 1)
        ? WidgetsBinding.instance?.addPostFrameCallback((_) async {
          ShowCaseWidget.of(context)!.startShowCase([widget.keyValue!]);
      GetStorage().write('showCase', true);
    })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 15.h,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
               AllColors.preview1,
               AllColors.preview2,
               AllColors.preview3,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(40.0))),
        child: (level == 'Level_1' && levelId == 0)
            ? Showcase(
          child: previewWidget(),
          description: 'Slide up to see detailed scores',
          key: widget.keyValue!,
        )
            : previewWidget());
  }

  _savingBalance() {
    return getValues('account_balance', AllColors.darkYellow);
  }

  _creditScore() {
    return getValues('credit_score', AllColors.lightGreen);
  }

  _netWorth() {
    return getValues('investment', AllColors.orange);
  }

  _qualityOfLife() {
    return getValues('quality_of_life', AllColors.extraLightBlue);
  }

  Widget bottomValue(Widget widget, String image) =>
      Container(
        width: 30.w,
        height: 9.h,
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 1.w,),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.center,
                    //color: Colors.green,
                    child: FittedBox(child: widget))),
            Expanded(
              flex: 1,
              child: Container(
                //color: Colors.blue,
                alignment: Alignment.center,
                child: Image.asset(
                  image,
                  width: 8.w,
                  height: 6.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            //SizedBox(height: 1.w,),
          ],
        ),
      );

  Widget getValues(String text, Color color) =>
      StreamBuilder<DocumentSnapshot>(
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
                  style: AllTextStyles.dialogStyleMedium(
                      color: color,
                      size:  16.sp,
                      ),
                ),
              );
          }
        },
      );

  previewWidget() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Container(
            width: 20.w,
            height: 1.h,
            decoration: BoxDecoration(
                color: AllColors.lightPurple,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 2.w, left: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (levelId == 0 &&
                  innerId == 0 &&
                  (level == 'Level_1' || level == 'Level_2'))
                  ? RippleAnimation(
                duration: Duration(seconds: 1),
                ripplesCount: 6,
                minRadius: 6.w,
                repeat: false,
                child: bottomValue(
                  _savingBalance(),
                  AllImages.saveMoney,
                ),
                color:AllColors.previewSaveMoney,
              )
                  : bottomValue(
                _savingBalance(),
                  AllImages.saveMoney,
              ),
              if (level == "Level_3")
                (levelId == 0 && innerId == 0)
                    ? RippleAnimation(
                  duration: Duration(seconds: 1),
                  ripplesCount: 6,
                  minRadius: 6.w,
                  repeat: false,
                  child: bottomValue(
                    _creditScore(),
                      AllImages.creditScore
                  ),
                  color: AllColors.previewCreditScore,
                )
                    : bottomValue(
                  _creditScore(),
                    AllImages.creditScore
                ),
              if (level == 'Level_4' || level == 'Level_5')
                (levelId == 0 && innerId == 0)
                    ? RippleAnimation(
                  duration: Duration(seconds: 1),
                  ripplesCount: 6,
                  minRadius: 6.w,
                  repeat: false,
                  child: bottomValue(
                    _netWorth(),
                    AllImages.netWorth,
                  ),
                  color:AllColors.previewNetWorth,
                )
                    : bottomValue(
                  _netWorth(),
                  AllImages.netWorth,
                ),
              (levelId == 0 &&
                  innerId == 0 &&
                  (level == 'Level_1' || level == 'Level_2'))
                  ? RippleAnimation(
                duration: Duration(seconds: 1),
                ripplesCount: 6,
                minRadius: 6.w,
                repeat: false,
                child: bottomValue(
                  _qualityOfLife(),
                  AllImages.symbol
                ),
                color: Colors.white,
              )
                  : bottomValue(
                _qualityOfLife(),
                AllImages.symbol
              ),
            ],
          ),
        ),
      ],
    );
  }
}


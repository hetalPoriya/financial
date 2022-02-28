//ignore: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripple_animation/ripple_animation.dart';
import 'package:sizer/sizer.dart';

class PreviewOfBottomDrawer extends StatefulWidget {
  PreviewOfBottomDrawer({Key? key}) : super(key: key);

  @override
  _PreviewOfBottomDrawerState createState() => _PreviewOfBottomDrawerState();
}

class _PreviewOfBottomDrawerState extends State<PreviewOfBottomDrawer>
    with SingleTickerProviderStateMixin {
  var userId;
  int? _qol;
  int? _accountBal;
  int? levelId;
  int? creditScore;
  int? netWorth;
  int? mutualFund;
  String level = '';
  int innerId = 0;
  var storeValue = GetStorage();

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.h,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff553EC4),
              Color(0xff4F47C8),
              Color(0xff4A50CA),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.0))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Container(
              width: 20.w,
              height: 1.h,
              decoration: BoxDecoration(
                  color: Color(0xffC3A7FF),
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
                          'assets/saveMoney.png',
                        ),
                        color: Color(0xfffff8e6),
                      )
                    : bottomValue(
                        _savingBalance(),
                        'assets/saveMoney.png',
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
                            'assets/credit_score.png',
                          ),
                          color: Color(0xffeafbf4),
                        )
                      : bottomValue(
                          _creditScore(),
                          'assets/credit_score.png',
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
                            'assets/netWorth.png',
                          ),
                          color: Color(0xffffe6ea),
                        )
                      : bottomValue(
                          _netWorth(),
                          'assets/netWorth.png',
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
                          'assets/symbol.png',
                        ),
                        color: Color(0xffe6f4ff),
                      )
                    : bottomValue(
                        _qualityOfLife(),
                        'assets/symbol.png',
                      ),
              ],
            ),
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

  _netWorth() {
    return getValues('investment', Color(0xffFF627F));
  }

  _qualityOfLife() {
    return getValues('quality_of_life', Color(0xff3FAEFF));
  }

  Widget bottomValue(Widget widget, String image) => Container(
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

// _qualityOfLife() {
//   return  StreamBuilder<DocumentSnapshot>(
//           stream: firestore.collection('User').doc(userId).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('It\'s Error!');
//             }
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Center(
//                     child: Padding(
//                   padding: EdgeInsets.only(bottom: 2.w),
//                   child: SizedBox(
//                     height: 3.h,
//                     width: 6.w,
//                     child: CircularProgressIndicator(
//                       backgroundColor: Colors.white10,
//                       color: Colors.white10,
//                     ),
//                   ),
//                 ));
//               default:
//                 return Container(
//                   child: Text(
//                     snapshot.data!['quality_of_life'].toString(),
//                     style: GoogleFonts.robotoCondensed(
//                         color: Color(0xff3FAEFF),
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 );
//             }
//           },
//         );
// }
//
// _savingBalance() {
//   return  StreamBuilder<DocumentSnapshot>(
//           stream: firestore.collection('User').doc(userId).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('It\'s Error!');
//             }
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Center(
//                     child: Padding(
//                   padding: EdgeInsets.only(bottom: 2.w),
//                   child: SizedBox(
//                     height: 3.h,
//                     width: 6.w,
//                     child: CircularProgressIndicator(
//                       backgroundColor: Colors.white10,
//                       color: Colors.white10,
//                     ),
//                   ),
//                 ));
//               default:
//                 return Container(
//                   child: Text(
//                     '${'\$${snapshot.data!['account_balance']}'}',
//                     style: GoogleFonts.robotoCondensed(
//                         color: Color(0xffFEBE16),
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 );
//             }
//           },
//         );
// }
//
// _creditScore() {
//   return  StreamBuilder<DocumentSnapshot>(
//           stream: firestore.collection('User').doc(userId).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('It\'s Error!');
//             }
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Center(
//                     child: Padding(
//                   padding: EdgeInsets.only(bottom: 2.w),
//                   child: SizedBox(
//                     height: 3.h,
//                     width: 6.w,
//                     child: CircularProgressIndicator(
//                       backgroundColor: Colors.white10,
//                       color: Colors.white10,
//                     ),
//                   ),
//                 ));
//               default:
//                 return Container(
//                   child: Text(
//                     snapshot.data!['credit_score'].toString(),
//                     style: GoogleFonts.robotoCondensed(
//                         color: Color(0xff28D38B),
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 );
//             }
//           },
//         );
// }
//
// _netWorth() {
//   return
//     // netWorth.toString().isEmpty
//     //   ? Center(
//     //       child: Padding(
//     //       padding: EdgeInsets.only(bottom: 2.w),
//     //       child: SizedBox(
//     //         height: 3.h,
//     //         width: 6.w,
//     //         child: CircularProgressIndicator(
//     //           backgroundColor: Colors.white10,
//     //           color: Colors.white10,
//     //         ),
//     //       ),
//     //     ))
//     //   :
//   StreamBuilder<DocumentSnapshot>(
//           stream: firestore.collection('User').doc(userId).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('It\'s Error!');
//             }
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return Center(
//                     child: Padding(
//                   padding: EdgeInsets.only(bottom: 2.w),
//                   child: SizedBox(
//                     height: 3.h,
//                     width: 6.w,
//                     child: CircularProgressIndicator(
//                       backgroundColor: Colors.white10,
//                       color: Colors.white10,
//                     ),
//                   ),
//                 ));
//               default:
//                 return Container(
//                   child: Text(
//                       (snapshot.data!['mutual_fund']+ snapshot.data!['net_worth']).toString(),
//                     style: GoogleFonts.robotoCondensed(
//                         color: Color(0xffFF627F),
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 );
//             }
//           },
//         );
// }

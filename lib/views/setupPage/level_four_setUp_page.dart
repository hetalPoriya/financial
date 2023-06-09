import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../cutom_screens/custom_screens.dart';
import '../../utils/utils.dart';
import 'setup_page.dart';

class LevelFourSetUpPage extends StatefulWidget {
  const LevelFourSetUpPage({Key? key}) : super(key: key);

  @override
  _LevelFourSetUpPageState createState() => _LevelFourSetUpPageState();
}

class _LevelFourSetUpPageState extends State<LevelFourSetUpPage> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SetUpPage(
      color: color,
      level: 'Level 4',
      levelText: AllStrings.level4,
      buttonText: 'Let’s Go',
      container: Container(
        child: Padding(
          padding: EdgeInsets.only(right: 04.w, left: 04.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Text(AllStrings.congratulations,
                  textAlign: TextAlign.center,
                  style: AllTextStyles.workSansMedium()),
              // SizedBox(
              //   height: 1.h,
              // ),
              Expanded(
                  flex: 3,
                  //fit: FlexFit.loose,
                  child: Container(
                    alignment: Alignment.center,
                    //color: Colors.red,
                    child: Text(AllStrings.levelFourText1,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmallBlack().copyWith(
                            fontWeight: FontWeight.w500, fontSize: 14.sp)),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    //color: Colors.green,
                    child: Text(AllStrings.levelFourText2,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmallBlack().copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12.sp)),
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    //color: Colors.yellow,
                    child: Text(AllStrings.levelFourText3,
                        textAlign: TextAlign.center,
                        style: AllTextStyles.workSansSmallBlack().copyWith(
                            fontWeight: FontWeight.w500, fontSize: 12.sp)),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(//color: Colors.red,
                      )),
            ],
          ),
        ),
      ),
      onPressed: () async {
        setState(() {
          color = AllColors.green;
        });
        Get.offAll(
          () => LevelFourAndFiveOptions(),
          duration: Duration(seconds: 1),
          transition: Transition.downToUp,
        );
      },
    );
  }
}

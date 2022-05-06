import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/comman_functions.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class BillPaymentWidget extends StatefulWidget {
  final String billPayment;
  final String? forPlan1;
  final String? forPlan2;
  final String? forPlan3;
  final String? forPlan4;
  final String? forPlan5;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
  final String? text5;
  final VoidCallback onPressed;
  final Color color;

  const BillPaymentWidget(
      {Key? key,
        required this.onPressed,
        required this.color,
        required this.billPayment,
        this.forPlan1,
        this.forPlan2,
        this.forPlan3,
        this.forPlan4,
        this.forPlan5,
        this.text1,
        this.text2,
        this.text3,
        this.text4,
        this.text5})
      : super(key: key);

  @override
  State<BillPaymentWidget> createState() => _BillPaymentWidgetState();
}

class _BillPaymentWidgetState extends State<BillPaymentWidget> {
  int rentPrice = 0;
  int transportPrice = 0;
  int homeLoan = 0;
  int transportLoan = 0;
  String? level;
  var userId;
  final storeValue = GetStorage();

  getData() async {
    userId = storeValue.read('uId');
    // rentPrice = storeValue.read('rentPrice');
    // transportPrice = storeValue.read('transportPrice');
    DocumentSnapshot snapshot =
    await firestore.collection('User').doc(userId).get();
    setState(() {
      level = snapshot.get('previous_session_info');
      homeLoan = snapshot.get('home_loan');
      transportLoan = snapshot.get('transport_loan');
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Container(
          alignment: Alignment.center,
          height: 54.h,
          width: 80.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8.w,
              ),
              color: AllColors.lightBlue),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 54.h),
              child: IntrinsicHeight(child: StatefulBuilder(
                builder: (context, _setState) {
                  if (level == 'Level_5') {
                    _setState(() {
                      rentPrice = storeValue.read('rentPrice');
                      transportPrice = storeValue.read('transportPrice');
                    });
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        AllStrings.billsDue,
                        style: AllTextStyles.dialogStyleExtraLarge(size: 22.sp),
                        textAlign: TextAlign.center,
                      ),

                      (level == 'Level_4' || level == 'Level_5')
                          ? normalText(AllStrings.level4And5TitleTextForBill)
                          : normalText(
                        AllStrings.normalBillTitleText,
                      ),

                      (level == 'Level_5' && rentPrice != 0)
                          ? Column(
                        children: [
                          level5BillPayment(
                              richText(
                                  widget.text1.toString(),
                                  '${'\$' + widget.forPlan1.toString()}',
                                  2.h,
                                  0.0,
                                  0.0,
                                  TextAlign.left),
                              AllImages.house),
                          Text(
                            '${AllStrings.outstandingAmount} ${'\$$homeLoan'}',
                            style: AllTextStyles.dialogStyleMedium(
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                          : richText(
                          widget.text1.toString(),
                          '${'\$' + widget.forPlan1.toString()}',
                          2.h,
                          0.0,
                          0.0,
                          TextAlign.left),

                      (level == 'Level_5' && transportPrice != 0)
                          ? Column(
                        children: [
                          level5BillPayment(
                            richText(
                                widget.text2.toString(),
                                '${'\$' + widget.forPlan2.toString()}',
                                2.h,
                                0.0,
                                0.0,
                                TextAlign.left),
                            AllImages.car,
                          ),
                          Text(
                            '${AllStrings.outstandingAmount} ${'\$$transportLoan'}',
                            style: AllTextStyles.dialogStyleMedium(
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                          : richText(
                          widget.text2.toString(),
                          '${'\$' + widget.forPlan2.toString()}',
                          1.h,
                          0.0,
                          0.0,
                          TextAlign.left),

                      // if (level == 'Level_2' ||
                      //     level == 'Level_3' ||
                      //     level == 'Level_4')
                      //   richText(
                      //       widget.text3.toString(),
                      //       '${'\$' + widget.forPlan3.toString()}',
                      //       1.h,
                      //       0.0,
                      //       0.0,
                      //       TextAlign.left),

                      level == 'Level_5'
                          ? level5BillPayment(
                        richText(
                            widget.text3.toString(),
                            '${'\$' + widget.forPlan3.toString()}',
                            2.h,
                            0.0,
                            0.0,
                            TextAlign.left),
                        AllImages.lifeStyle,
                      )
                          : richText(
                          widget.text3.toString(),
                          '${'\$' + widget.forPlan3.toString()}',
                          1.h,
                          0.0,
                          0.0,
                          TextAlign.left),

                      if (level != 'Level_4')
                        richText(
                            widget.text4.toString(),
                            '${'\$' + widget.forPlan4.toString()}',
                            1.h,
                            0.0,
                            0.0,
                            TextAlign.left),

                      if (level == 'Level_5')
                        richText(
                            widget.text5.toString(),
                            '${'\$' + widget.forPlan5.toString()}',
                            1.h,
                            0.0,
                            0.0,
                            TextAlign.left),

                      Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: 62.w,
                            height: 7.h,
                            decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(12.w)),
                            child: TextButton(
                                onPressed: widget.onPressed,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Center(
                                    child: FittedBox(
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        text: TextSpan(
                                            text: 'Pay now ',
                                            style:
                                            AllTextStyles.dialogStyleLarge(
                                              color: widget.color ==
                                                  AllColors.green
                                                  ? Colors.white
                                                  : AllColors.darkBlue,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '\$' +
                                                    widget.billPayment
                                                        .toString(),
                                                style: AllTextStyles
                                                    .dialogStyleLarge(
                                                  color: widget.color ==
                                                      AllColors.green
                                                      ? Colors.white
                                                      : AllColors.darkYellow,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                )),
                          )),
                      Spacer(),
                    ],
                  );
                },
              )),
            ),
          )),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/utils.dart';
import 'custom_screens.dart';

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


  getData() async {
    userId = Prefs.getString(PrefString.userId);
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
    return Container(
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
                    rentPrice = Prefs.getInt(PrefString.rentPrice)!;
                    transportPrice = Prefs.getInt(PrefString.transportPrice)!;
                  });
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      AllStrings.billsDue,
                      style: AllTextStyles.workSansExtraLarge()
                          .copyWith(fontSize: 22.sp),
                      textAlign: TextAlign.center,
                    ),
                    (level == 'Level_4' || level == 'Level_5')
                        ? normalText(
                            text: AllStrings.level4And5TitleTextForBill)
                        : normalText(
                            text: AllStrings.normalBillTitleText,
                          ),
                    (level == 'Level_5' && rentPrice != 0)
                        ? Column(
                            children: [
                              allLevelBillPaymentText(
                                image: AllImages.house,
                                text1: widget.text1.toString(),
                                text2:
                                    '${AllStrings.countrySymbol + widget.forPlan1.toString()}',
                              ),
                              Text(
                                '${AllStrings.outstandingAmount} ${'${AllStrings.countrySymbol}$homeLoan'}',
                                style: AllTextStyles.workSansSmallWhite()
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade400),
                              ),
                            ],
                          )
                        : (level == 'Level_5' && rentPrice == 0)
                            ? Container()
                            : allLevelBillPaymentText(
                                text: level == 'Level_4' ? '🏠' : '🏡',
                                text1: widget.text1.toString(),
                                text2:
                                    '${AllStrings.countrySymbol + widget.forPlan1.toString()}',
                              ),
                    (level == 'Level_5' && transportPrice != 0)
                        ? Column(
                            children: [
                              allLevelBillPaymentText(
                                image: AllImages.car,
                                text1: widget.text2.toString(),
                                text2:
                                    '${AllStrings.countrySymbol + widget.forPlan2.toString()}',
                              ),
                              Text(
                                '${AllStrings.outstandingAmount} ${'${AllStrings.countrySymbol}$transportLoan'}',
                                style: AllTextStyles.workSansSmallWhite()
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade400),
                              ),
                            ],
                          )
                        : (level == 'Level_5' && transportPrice == 0)
                            ? Container()
                            : allLevelBillPaymentText(
                                text: level == 'Level_4' ? '🚗' : '📺',
                                text1: widget.text2.toString(),
                                text2:
                                    '${AllStrings.countrySymbol + widget.forPlan2.toString()}',
                              ),
                    allLevelBillPaymentText(
                      image: level == 'Level_5' ? AllImages.lifeStyle : null,
                      text: level == 'Level_4' ? '🛍️' : '🍞',
                      text1: widget.text3.toString(),
                      text2:
                          '${AllStrings.countrySymbol + widget.forPlan3.toString()}',
                    ),
                    if (level != 'Level_4')
                      allLevelBillPaymentText(
                        text: level == 'Level_5' ? '💰' : '📱',
                        text1: widget.text4.toString(),
                        text2:
                            '${AllStrings.countrySymbol + widget.forPlan4.toString()}',
                      ),
                    if (level == 'Level_5')
                      richText(
                          text1: widget.text5.toString(),
                          text2:
                              '${AllStrings.countrySymbol + widget.forPlan5.toString()}',
                          paddingTop: 1.h,
                          textAlign: TextAlign.left),
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
                                          style: AllTextStyles.workSansLarge()
                                              .copyWith(
                                            color:
                                                widget.color == AllColors.green
                                                    ? Colors.white
                                                    : AllColors.darkBlue,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: AllStrings.countrySymbol +
                                                  widget.billPayment.toString(),
                                              style:
                                                  AllTextStyles.workSansLarge()
                                                      .copyWith(
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
        ));
  }
}

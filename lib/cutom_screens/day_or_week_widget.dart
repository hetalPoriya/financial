import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DayOrWeekWidget extends StatelessWidget {
  var document;
  String? level;
  Widget containerWidget;

  DayOrWeekWidget(
      {Key? key, this.level, this.document, required this.containerWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Spacer(),
          if (level == 'Level_2_Pop_Quiz' && level == 'Level_3_Pop_Quiz')
            Padding(
                padding: EdgeInsets.only(
              top: 0.h,
            )),
          if ((level == "Level_1" || level == "") &&
              document['card_type'] == 'GameQuestion')
            document['day'] == 0
                ? _text('DAY 1/7')
                : _text('DAY ' + document['day'].toString() + '/7'),
          if ((level == "Level_2" || level == 'Level_3') &&
              (document.toString() == 'GameQuestion' ||
                  document['card_type'] == 'GameQuestion'))
            document.toString() == 'GameQuestion' || document['week'] == null
                ? _text('WEEK 1/24')
                : _text('WEEK ' + document['week'].toString() + '/24'),
          if ((level == "Level_4" || level == "Level_5") &&
              document['card_type'] == 'GameQuestion')
            document['month'] == 0
                ? _text('MONTH 1/30')
                : _text('MONTH ' + document['month'].toString() + '/30'),
          Spacer(),
          containerWidget,
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer(),
          if ((document.toString() == 'GameQuestion') ||
              document['card_type'] == 'GameQuestion')
            Spacer(),
          if ((document.toString() == 'GameQuestion' ||
              document['card_type'] == 'GameQuestion'))
            Spacer(),
        ],
      ),
    );
  }

  Widget _text(String text) => Text(
        text,
        style: AllTextStyles.workSansLarge(),
        textAlign: TextAlign.center,
      );
}

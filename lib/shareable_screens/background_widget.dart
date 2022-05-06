import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:financial/shareable_screens/expanded_bottom_drawer.dart';
import 'package:financial/shareable_screens/game_score_page.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/preview_of_bottom_drawer.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

class BackgroundWidget extends StatefulWidget {
  final String level;
  final Widget container;
  final document;
  final Decoration? decoration;

  BackgroundWidget(
      {Key? key,
        required this.container,
        required this.level,
        this.document,
        this.decoration})
      : super(key: key);

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  bool? showCase;
  GlobalKey one = GlobalKey();
  GlobalKey two = GlobalKey();
  var userId;

  String level = '';

  getLevelId() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    userId = GetStorage().read('uId');
    showCase = GetStorage().read('showCase');
    DocumentSnapshot snapshot =
    await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    int levelId = snapshot.get('level_id');
    if (level == 'Level_1' && levelId == 0) {
      showCase == false
          ? WidgetsBinding.instance?.addPostFrameCallback((_) async {
        ShowCaseWidget.of(context)!.startShowCase([one, two]);
        GetStorage().write('showCase', true);
      })
          : null;
    }
    return null;
  }

  @override
  initState() {
    getLevelId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(AllStrings.tapBack),
            ),
            child: DraggableBottomSheet(
              backgroundWidget: Container(
                width: 100.w,
                height: 100.h,
                decoration: widget.decoration == null
                    ? boxDecoration
                    : widget.decoration,
                child: Column(
                  children: [
                    Spacer(),
                    GameScorePage(
                      level: widget.level,
                      document: widget.document,
                      keyValue: one,
                    ),
                    widget.container,
                    Spacer(),
                    Spacer(),
                    Spacer(),
                  ],
                ),
              ),
              previewChild: level == 'Level_1'
                  ? Showcase(
                  key: two,
                  description: AllStrings.showCaseBottomText,
                  descTextStyle:
                  AllTextStyles.workSansSmall(fontSize: 12.sp),
                  animationDuration: Duration(milliseconds: 500),
                  child: PreviewOfBottomDrawer(keyValue: two))
                  : PreviewOfBottomDrawer(keyValue: two),
              expandedChild: ExpandedBottomDrawer(),
              minExtent: 14.h,
              maxExtent: 55.h,
            ),
          )),
    );
  }
}
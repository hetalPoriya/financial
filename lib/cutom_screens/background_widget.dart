import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import '../utils/utils.dart';
import 'custom_screens.dart';

class BackgroundWidget extends StatefulWidget {
  final String level;
  final Widget container;
  final Widget? dayOrWeek;
  final document;
  final Decoration? decoration;

  BackgroundWidget(
      {Key? key,
      required this.container,
      required this.level,
      this.document,
      this.dayOrWeek,
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
    userId = Prefs.getString(PrefString.userId);
    showCase = Prefs.getBool(PrefString.showCase);
    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    int levelId = snapshot.get('level_id');
    if (level == 'Level_1' && levelId == 0) {
      showCase == false
          ? WidgetsBinding.instance.addPostFrameCallback((_) async {
              ShowCaseWidget.of(context).startShowCase([one, two]);
              await Prefs.setBool(PrefString.showCase,true);
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
      child: Container(
        decoration:
            widget.decoration == null ? boxDecoration : widget.decoration,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                content: Text(AllStrings.tapBack),
              ),
              child: DraggableBottomSheet(
                backgroundWidget: Container(
                  width: 100.w,
                  height: 85.h,
                  decoration: widget.decoration == null
                      ? boxDecoration
                      : widget.decoration,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.greenAccent,
                          child: GameScorePage(
                            level: widget.level,
                            document: widget.document,
                            keyValue: one,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: 100.w,
                          alignment: Alignment.center,
                          // color: Colors.red,
                          child: Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Container(
                                height: 85.h,
                                width: 80.w,
                                child: Container(child: widget.container)),
                          ),
                        ),
                      ),
                      // Spacer(),
                      // Spacer(),
                      // Spacer(),
                    ],
                  ),
                ),
                previewChild: level == 'Level_1'
                    ? Showcase(
                        key: two,
                        description: AllStrings.showCaseBottomText,
                        descTextStyle:
                            AllTextStyles.workSansSmallBlack().copyWith(fontSize: 12.sp),
                        animationDuration: Duration(milliseconds: 500),
                        child: PreviewOfBottomDrawer(keyValue: two))
                    : PreviewOfBottomDrawer(keyValue: two),
                expandedChild: ExpandedBottomDrawer(),
                minExtent: 14.h,
                maxExtent: 55.h,
              ),
            )),
      ),
    );
  }
}

import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:financial/shareable_screens/expanded_bottom_drawer.dart';
import 'package:financial/shareable_screens/game_score_page.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/preview_of_bottom_drawer.dart';
import 'package:financial/utils/all_images.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LevelSummaryScreen extends StatelessWidget {
  final String? level;
  Widget container;
  var document;

  LevelSummaryScreen(
      {Key? key, this.level, required this.container, this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              DraggableBottomSheet(
                backgroundWidget: Container(
                  decoration: boxDecoration,
                  width: 100.w,
                  height: 100.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: GameScorePage(
                      level: level.toString(),
                      document: document,
                    ),
                  ),
                ),
                previewChild: PreviewOfBottomDrawer(),
                expandedChild: ExpandedBottomDrawer(),
                minExtent: 14.h,
                maxExtent: 55.h,
              ),
              Material(
                elevation: 2.h,
                color: Colors.black26,
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  child: Image.asset(AllImages.summaryGif, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: container,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
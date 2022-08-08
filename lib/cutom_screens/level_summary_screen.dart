
import 'package:financial/utils/all_images.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'custom_screens.dart';

class LevelSummaryScreen extends StatelessWidget {
  final String? level;
  Widget container;
  var document;

  LevelSummaryScreen(
      {Key? key, this.level, required this.container, this.document});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            BackgroundWidget(container: Container(), level: level.toString()),
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
    );
  }
}
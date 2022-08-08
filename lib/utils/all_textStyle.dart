import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'utils.dart';

class AllTextStyles {
  static TextStyle workSansExtraSmall() => GoogleFonts.workSans(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
      );

  static TextStyle workSansSmallBlack() => GoogleFonts.workSans(
      color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14.sp);

  static TextStyle workSansSmallWhite() => GoogleFonts.workSans(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
      );

  static TextStyle workSansMedium() => GoogleFonts.workSans(
        color: AllColors.purple,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontSize: 17.sp,
      );

  static TextStyle workSansLarge() => GoogleFonts.workSans(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
      );

  static TextStyle workSansExtraLarge() => GoogleFonts.workSans(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 20.sp,
      );

  static TextStyle gameQuestionOptionText({Color? color}) =>
      GoogleFonts.workSans(
          color: color, fontWeight: FontWeight.w500, fontSize: 15.sp);

  static TextStyle robotoSmall() => GoogleFonts.roboto(
      color: Color(0xff563DC1), fontSize: 12.sp, fontWeight: FontWeight.w600);

  static TextStyle robotoMedium() => GoogleFonts.roboto(
      color: Color(0xff563DC1), fontSize: 14.sp, fontWeight: FontWeight.w800);

  static TextStyle robotoLarge() => GoogleFonts.roboto(
      fontSize: 18.sp, color: Color(0xffA566FF), fontWeight: FontWeight.w600);

  static TextStyle robotoExtraLarge() => GoogleFonts.roboto(
      color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w600);

  static TextStyle balooDaSmall() => GoogleFonts.balooDa(
      fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold);

  static TextStyle balooDaSmallMedium() => GoogleFonts.balooDa(
      color: Color(0xffFFD25E), fontSize: 28.sp, fontWeight: FontWeight.w900);

  static TextStyle robotoCondensed() => GoogleFonts.robotoCondensed(
      fontSize: 26.sp, fontWeight: FontWeight.w600, color: Colors.white);

  static TextStyle signikaTextSmall() =>
      GoogleFonts.signika(
          fontSize:  14.sp,
          color:Colors.white,
          fontWeight:  FontWeight.w600);

  static TextStyle signikaTextMedium() =>
      GoogleFonts.signika(
          fontSize:  20.sp,
          color:Colors.white,
          fontWeight:  FontWeight.w600);

  static TextStyle signikaTextLarge() =>
      GoogleFonts.signika(
          fontSize: 30.sp,
          color: AllColors.rateText1Color,
          fontWeight: FontWeight.w600);

  //settings page style
  static TextStyle settingTitleInter() =>
      GoogleFonts.inter(
          color: Colors.white,
          fontSize:15.sp,
          fontWeight:  FontWeight.w700);

  static TextStyle settingDesInter() =>
      GoogleFonts.inter(color: Colors.white, fontSize: 12.sp);

  static TextStyle settingsAppTitleInter() => GoogleFonts.inter(
      color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500);

  //leaderBoardStyle
  static TextStyle leaderBoardNameInter() => GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 13.sp,
      color: AllColors.leaderBoardTextColor);

  static gaugeStyle() => GaugeTextStyle(
      color: Colors.grey.shade900, fontWeight: FontWeight.w500, fontSize: 8.sp);
}

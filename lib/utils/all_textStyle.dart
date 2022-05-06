import 'package:financial/utils/all_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AllTextStyles {
  static TextStyle workSansSmall({FontWeight? fontWeight,double? fontSize,Color? color}) => GoogleFonts.workSans(
      color: color ?? Colors.black, fontWeight: fontWeight ?? FontWeight.w600, fontSize: fontSize ?? 14.sp);

  static TextStyle workSansMediumBlack({FontWeight? fontWeight,double? fontSize}) => GoogleFonts.workSans(
      color: Colors.black, fontWeight: fontWeight ?? FontWeight.w500, fontSize: fontSize ?? 16.sp);

  static TextStyle workSansMedium() => GoogleFonts.workSans(
        color: AllColors.purple,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontSize: 17.sp,
      );

  static gameQuestionOption({Color? color}) => GoogleFonts.workSans(
      color:color,
      fontWeight:  FontWeight.w500,
      fontSize: 15.sp);

  static dialogStyleSmall({double? size,FontWeight? fontWeight,Color? color}) => GoogleFonts.workSans(
    color:color ?? Colors.white,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontSize: size ?? 12.sp,
  );

  static dialogStyleMedium({double? size,FontWeight? fontWeight,Color? color}) => GoogleFonts.workSans(
    color:color ?? Colors.white,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontSize: size ?? 14.sp,
  );

  static dialogStyleLarge({double? size,FontWeight? fontWeight,Color? color}) => GoogleFonts.workSans(
    color:color ?? Colors.white,
    fontWeight: fontWeight ?? FontWeight.w500,
    fontSize: size ?? 15.sp,
  );

  static dialogStyleExtraLarge({double? size,FontWeight? fontWeight,Color? color}) => GoogleFonts.workSans(
    color:color ?? Colors.white,
    fontWeight: fontWeight ?? FontWeight.w600,
    fontSize: size ?? 20.sp,
  );

  static robotoSmall({Color? color,double? size,FontWeight?fontWeight}) => GoogleFonts.roboto(
      color: color ?? Color(0xff563DC1),
      fontSize:size ?? 12.sp,
      fontWeight:
     fontWeight ?? FontWeight.w600);

  static robotoMedium({Color? color}) => GoogleFonts.roboto(
      color:color ?? Color(0xff563DC1),
      fontSize: 14.sp,
      fontWeight:
      FontWeight.w800);

  static comingSoon() => GoogleFonts.balooDa(
      color: Color(0xffFFD25E),
      fontSize: 28.sp,
      fontWeight: FontWeight.w900);


  static balooDa() => GoogleFonts.balooDa(
      fontSize: 20.sp,
      color: Colors.white,
      fontWeight: FontWeight.bold);

  static finsharkRoboto({double? fontSize}) =>  GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 26.sp,
      fontWeight: FontWeight.w600);

  static gameScore() =>  GoogleFonts.robotoCondensed(
      fontSize: 26.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white);


  static roboto({double? size,FontWeight? fontWeight,Color? color}) =>   GoogleFonts.roboto(
      fontSize: size ?? 18.sp,
      color:color ?? Color(0xffA566FF),
      fontWeight: fontWeight ??FontWeight.w600);


  static signikaText1({double? size,FontWeight? fontWeight,Color? color}) =>   GoogleFonts.signika(
      fontSize: size ?? 30.sp,
      color:color ?? AllColors.rateText1Color,
      fontWeight: fontWeight ??FontWeight.w600);


  static signikaText2({double? size,FontWeight? fontWeight,Color? color}) =>   GoogleFonts.signika(
      fontSize: size ?? 20.sp,
      color:color ?? Colors.white,
      fontWeight: fontWeight ??FontWeight.w600);
}

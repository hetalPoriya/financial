library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/utils/AllColors.dart';
import 'package:financial/utils/AllTextStyle.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//for store select plan(rent,tv etc) value
int globalVar = 0;
int forPlan1 = 0;
int forPlan2 = 0;
int forPlan3 = 0;
int forPlan4 = 0;

int rentPrice = 0;
int transportPrice = 0;
int lifestylePrice = 0;
int level4TotalPrice = 0;

//to store bal,qol,gs
// int balance = 0;
// int qualityOfLife = 0;
// int gameScore = 0;

//counting for max 100 plus in credit score
int creditCount = 100;

//create firestore instance
FirebaseFirestore firestore = FirebaseFirestore.instance;

//decoration color
BoxDecoration boxDecoration = BoxDecoration(
    gradient: LinearGradient(
  colors: [
    AllColors.darkPurple,
    AllColors.darkPurple,
    AllColors.blue,
    AllColors.blue,
    AllColors.purple,
    AllColors.purple,
  ],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
));

//button style for restart level or (creditbalance or debitbalance not enough) ok button

Widget restartOrOkButton(String text, VoidCallback onPressed,
        [Alignment? alignment]) =>
    Padding(
      padding: EdgeInsets.all(6.0),
      child: Align(
        alignment: alignment == null ? Alignment.centerRight : alignment,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w)))),
            child: Padding(
              padding: EdgeInsets.all(1.w),
              child: Text(text,
                  style: AllTextStyles.dialogStyleSmall(
                      color: AllColors.darkPurple,
                      fontWeight: FontWeight.normal)),
            )),
      ),
    );

library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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


String level = '';
int levelId = 0;
int gameScore = 0;
int balance = 0;
int qualityOfLife = 0;
var userId;
int updateValue = 0;
Color color = Colors.white;
int billPayment = 0;
// page controller
PageController controller = PageController();

//store streambuilder value
var document;

// for option selection
bool flag1 = false;
bool flag2 = false;
bool scroll = true;
bool flagForKnow = false;
final storeValue = GetStorage();


// LocalNotifyManager localNotifyManager = LocalNotifyManager.init();


 getLevelId() async {
  //SharedPreferences pref = await SharedPreferences.getInstance();
  userId = storeValue.read('uId');
  updateValue = storeValue.read('update');
  DocumentSnapshot snapshot =
  await firestore.collection('User').doc(userId).get();
  level = snapshot.get('previous_session_info');
  levelId = snapshot.get('level_id');
  gameScore = snapshot.get('game_score');
  balance = snapshot.get('account_balance');
  qualityOfLife = snapshot.get('quality_of_life');
  billPayment = snapshot.get('bill_payment');
  controller = PageController(initialPage: levelId);

  if(level == 'Level_2' || level == 'Level_3'){
    forPlan1 = storeValue.read('plan1')!;
    forPlan2 = storeValue.read('plan2')!;
    forPlan3 = storeValue.read('plan3')!;
    forPlan4 = storeValue.read('plan4')!;
  }
  return null;
}



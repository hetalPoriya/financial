import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/models/QueModel.dart';
import 'package:financial/models/RankingUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserInfoController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<String> fundName = ['Mutual Fund', 'Home EMI', 'Transport EMI'].obs;
  List<int> fundAllocation = [0, 0, 0].obs;

  DocumentSnapshot? snapshot;

  //to get user id
  var userId;
  var getCredential = GetStorage();
  bool flag1 = false;
  bool flag2 = false;
  bool scroll = true;
  bool flagForKnow = false;
  String level = '';
  int levelId = 0;
  int gameScore = 0;
  int balance = 0;
  int qualityOfLife = 0;
  int updateValue = 0;

  bool submit = false;

  //get bill data
  int billPayment = 0;
  int forPlan1 = 0;
  int forPlan2 = 0;
  int forPlan3 = 0;
  int forPlan4 = 0;

  Color color = Colors.white;
  QueModel? queModel;
  List<QueModel> list = [];

  getLevelId() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    list = [];
    userId = getCredential.read('uId');
    color = Colors.white;
    updateValue = getCredential.read('update');
    DocumentSnapshot snapshot =
        await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    levelId = snapshot.get('level_id');
    gameScore = snapshot.get('game_score');
    balance = snapshot.get('account_balance');
    qualityOfLife = snapshot.get('quality_of_life');
    updateValue = getCredential.read('update');
    update();
    if (level == 'Level_2' || level == 'Level_3') {
      forPlan1 = getCredential.read('plan1')!;
      forPlan2 = getCredential.read('plan2')!;
      forPlan3 = getCredential.read('plan3')!;
      forPlan4 = getCredential.read('plan4')!;
      billPayment = snapshot.get('bill_payment');
      update();
    }

    String getLevel = level == 'Level_1'
        ? 'Level_1'
        : level == 'Level_2'
            ? 'Level_2'
            : level == 'Level_3'
                ? 'Level_3'
                : level == 'Level_4'
                    ? 'Level_4'
                    : level == 'Level_5'
                        ? 'Level_5'
                        : 'Level_6';

    print('Get Level $level');
    // QuerySnapshot querySnapshot = await firestore.collection(getLevel).get();
    // getLevelIndex(querySnapshot);
    snapshot = await firestore.collection('User').doc(userId).get();
    update();

    // if (level == 'Level_1') {
    //   querySnapshot = firestore.collection('Level_1').orderBy('id').snapshots();
    // } else if (level == 'Level_2') {
    //   querySnapshot = firestore.collection('Level_2').orderBy('id').snapshots();
    // } else if (level == 'Level_3') {
    //   querySnapshot = firestore.collection('Level_3').orderBy('id').snapshots();
    // } else if (level == 'Level_4') {
    //   querySnapshot = firestore.collection('Level_4').orderBy('id').snapshots();
    // } else if (level == 'Level_5') {
    //   querySnapshot = firestore.collection('Level_5').orderBy('id').snapshots();
    // } else {
    //   querySnapshot = firestore.collection('Level_6').orderBy('id').snapshots();
    // }
    return null;
  }

  // int gameScore = 0;
  // int balance = 0;
  // int qualityOfLife = 0;
  // int updateValue = 0;
  //
  // // page controller
  // PageController controller = PageController();
  //
  // //store streambuilder value
  // var document;
  //
  // //for model
  // QueModel? queModel;
  // List<QueModel> list = [];
  //
  // bool flag1 = false;
  // bool flag2 = false;
  // bool scroll = true;
  // bool flagForKnow = false;
  //
  // Future<QueModel?> getLevelId() async {
  //   //SharedPreferences pref = await SharedPreferences.getInstance();
  //   userId = getCredential.read('uId');
  //   updateValue = getCredential.read('update');
  //   DocumentSnapshot snapshot =
  //   await firestore.collection('User').doc(userId).get();
  //   level = snapshot.get('previous_session_info');
  //   levelId = snapshot.get('level_id');
  //   gameScore = snapshot.get('game_score');
  //   balance = snapshot.get('account_balance');
  //   qualityOfLife = snapshot.get('quality_of_life');
  //   controller = PageController(initialPage: levelId!);
  //
  //   update();
  //   QuerySnapshot querySnapshot =
  //   await FirebaseFirestore.instance.collection("Level_1").get();
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];
  //     queModel = QueModel();
  //     queModel?.id = a['id'];
  //       list.add(queModel!);
  //       update();
  //   }
  //
  //   snapshot = await firestore.collection('User').doc(userId).get();
  //   update();
  //   return null;
  // }

  // for rate
  double star = 0.0;
  TextEditingController feedbackCon = TextEditingController();

  // Future<void> feedback() =>  firestore.collection('Feedback').doc().set({
  //   'user_id': userId,
  //   'level_id': level,
  //   'rating': star,
  //   'feedback': feedbackCon.text.toString()
  // });

  // Future<void> getUser(int levelId) async {
  //   int countForUser = 0;
  //
  //   int accountBalanceForUser = 0;
  //   int totalBalanceForUser = 0;
  //
  //   int creditScoreForUser = 0;
  //   int totalCreditForUser = 0;
  //
  //   int qolForUser = 0;
  //   int totalQolForUser = 0;
  //
  //   int investmentForUser = 0;
  //   int totalInvestmentForUser = 0;
  //
  //   String level = '';
  //   var storeValue = GetStorage();
  //   var userId;
  //
  //   userId = storeValue.read('uId');
  //   QuerySnapshot snap = await firestore.collection('User').get();
  //   DocumentSnapshot documentSnapshot;
  //
  //   documentSnapshot = await firestore.collection('User').doc(userId).get();
  //   level = documentSnapshot.get('previous_session_info');
  //
  //   // QuerySnapshot<Map<String, dynamic>>? l1 =
  //   //     await firestore.collection('Level_1').get();
  //   // QuerySnapshot<Map<String, dynamic>>? l2 =
  //   //     await firestore.collection('Level_2').get();
  //   // QuerySnapshot<Map<String, dynamic>>? l3 =
  //   //     await firestore.collection('Level_3').get();
  //   // QuerySnapshot<Map<String, dynamic>>? l4 =
  //   //     await firestore.collection('Level_4').get();
  //   // QuerySnapshot<Map<String, dynamic>>? l5 =
  //   //     await firestore.collection('Level_5').get();
  //
  //   snap.docs.forEach((document) async {
  //     documentSnapshot =
  //     await firestore.collection('User').doc(document.id).get();
  //     //levelForUser = documentSnapshot.get('previous_session_info');
  //     if ((documentSnapshot.data() as Map<String, dynamic>)
  //         .containsKey("level_1_balance")) {
  //       if (documentSnapshot.get('level_$levelId\_balance') != 0 &&
  //           document.id != userId) {
  //         countForUser = countForUser + 1;
  //         accountBalanceForUser = documentSnapshot.get('level_$levelId\_balance');
  //         qolForUser = documentSnapshot.get('level_$levelId\_qol');
  //
  //         totalBalanceForUser = totalBalanceForUser + accountBalanceForUser;
  //         totalQolForUser = totalQolForUser + qolForUser;
  //
  //         if (level == 'Level_3') {
  //           creditScoreForUser =
  //               documentSnapshot.get('level_$levelId\_creditScore');
  //           totalCreditForUser = totalCreditForUser + creditScoreForUser;
  //         }
  //
  //         if (level == 'Level_4' || level == 'Level_5') {
  //           investmentForUser =
  //               documentSnapshot.get('level_$levelId\_investment');
  //           totalInvestmentForUser = totalInvestmentForUser + investmentForUser;
  //         }
  //       }
  //
  //       storeValue.write('tBalance', totalBalanceForUser);
  //       storeValue.write('tQol', totalQolForUser);
  //       storeValue.write('tInvestment', totalInvestmentForUser);
  //       storeValue.write('tCredit', totalCreditForUser);
  //       storeValue.write('tUser', countForUser);
  //     }
  //   });
  // }
  //
  // getTopRankingUser() async {
  //  int gameScore = 0;
  //  String userName = '';
  //  RankingUser rankingUser;
  //  List<RankingUser> totalUsers = [];
  //   QuerySnapshot snap = await firestore.collection('User').get();
  //   DocumentSnapshot documentSnapshot;
  //   snap.docs.map((document) async {
  //     documentSnapshot =
  //         await firestore.collection('User').doc(document.id).get();
  //     gameScore = documentSnapshot.get('game_score');
  //     userName = documentSnapshot.get('user_name');
  //     rankingUser = RankingUser(gameScore: gameScore,userName: userName );
  //    totalUsers.add(rankingUser);
  //   });
  //   print(totalUsers.length);
  // }
  @override
  void onInit() {
    //todoStream();
    print('USERCON $level');
    userId = getCredential.read('uId');
    getLevelId();
    update();
    super.onInit();
  }

  getLevelIndex(QuerySnapshot<Object?> querySnapshot) {
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      queModel = QueModel();
      queModel?.id = a['id'];
      list.add(queModel!);
    }
    update();
  }
}

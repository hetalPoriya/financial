
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:financial/models/AllQueModel.dart';
import 'package:financial/models/QueModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserInfoController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<List<AllQueModel>> list1 = Rx<List<AllQueModel>>([]);
  List<AllQueModel> get todos => list1.value;

  String level = '';
  int levelId = 0;
  int gameScore = 0;
  int balance = 0;
  int qualityOfLife = 0;
  var document;
  PageController controller = PageController();

  // for option selection
  bool flag1 = false;
  bool flag2 = false;
  bool scroll = true;
  bool flagForKnow = false;
  final storeValue = GetStorage();

  //for model
  QueModel? queModel;
  List<QueModel> list = [];

  List<String> fundName = ['Mutual Fund', 'Home EMI', 'Transport EMI'].obs;
  List<int> fundAllocation = [0, 0, 0].obs;

  // int countForUser = 0;
  // int accountBalanceForUser = 0;
  // int totalBalanceForUser = 0;
  // int qolForUser = 0;
  // int totalQolForUser = 0;
  // String levelForUser = '';
  var userId;
  // Key? key;
  //
  // Stream<List<AllQueModel>> todoStream() {
  //   return firestore
  //       .collection('Level_1')
  //       .orderBy('id')
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //     List<AllQueModel> todos = [];
  //     for (var todo in query.docs) {
  //       final todoModel =
  //           AllQueModel.fromDocumentSnapshot(documentSnapshot: todo);
  //       todos.add(todoModel);
  //       print(todoModel.cardType);
  //     }
  //     print(todos[1].cardType);
  //     return todos;
  //   });
  // }

  // late AnimationController controller = AnimationController(
  //   duration: const Duration(milliseconds: 10),
  //   vsync: this,
  // );
  // late Animation<double> animation =
  //     CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
  //
  // @override
  // void onInit() {
  //   repeatOnce();
  //   super.onInit();
  // }
  //
  // void repeatOnce() async {
  //   await controller.forward();
  //   await controller.reverse();
  //   await controller.forward();
  // }

  getLevelId() async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    userId = storeValue.read('uId');
    DocumentSnapshot snapshot = await firestore.collection('User').doc(userId).get();
    level = snapshot.get('previous_session_info');
    levelId = snapshot.get('level_id');
    gameScore = snapshot.get('game_score');
    balance = snapshot.get('account_balance');
    qualityOfLife = snapshot.get('quality_of_life');
    controller = PageController(initialPage: levelId);
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("Level_1").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      queModel = QueModel();
      queModel?.id = a['id'];
        list.add(queModel!);
    }
    return null;
  }

 // getUser() async{
 //    QuerySnapshot snap = await firestore.collection('User').get();
 //    DocumentSnapshot documentSnapshot;
 //    documentSnapshot = await firestore.collection('User').doc(userId).get();
 //    level = documentSnapshot.get('previous_session_info');
 //    print('Current User Level $level');
 //
 //    snap.docs.forEach((document) async {
 //       documentSnapshot = await firestore.collection('User').doc(document.id).get();
 //       levelForUser = documentSnapshot.get('previous_session_info');
 //         print('User ${document.id}');
 //
 //        if(levelForUser == level && document.id != userId){
 //          print('Called');
 //          print('User ${document.id}');
 //          countForUser = countForUser + 1;
 //
 //          accountBalanceForUser = documentSnapshot.get('account_balance');
 //          print('Balance $accountBalanceForUser');
 //
 //          qolForUser = documentSnapshot.get('quality_of_life');
 //          print('qol $qolForUser');
 //
 //          totalBalanceForUser = totalBalanceForUser + accountBalanceForUser;
 //          totalQolForUser = totalQolForUser + qolForUser;
 //
 //          print('totalBalanceForUser  $totalBalanceForUser');
 //          print('totalQolForUser  $totalQolForUser');
 //        }
 //
 //      print(countForUser);
 //    });
 //  }

@override
  void onInit() {
    getLevelId();
    //todoStream();
    super.onInit();
  }
}

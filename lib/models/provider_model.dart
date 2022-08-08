import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/views/setupPage/level_three_setUp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../utils/utils.dart';

class ProviderModel with ChangeNotifier {
  InAppPurchase _iap = InAppPurchase.instance;
  bool available = true;
  StreamSubscription? subscription;
  final String myProductId = 'finshark_game_unlock';

  bool _isPurchased = false;

  bool get isPurchased => _isPurchased;

  set isPurchased(bool value) {
    print('PurchaseVAlue $value');
    _isPurchased = value;
    notifyListeners();
  }

  List _purchases = [];

  List get purchases => _purchases;

  set purchases(List value) {
    print('VALUEEE $value');
    _purchases = value;
    notifyListeners();
  }

  List _products = [];

  List get products => _products;

  set products(List value) {
    _products = value;
    print('PRODUVTT ${_products.toList()}');
    notifyListeners();
  }

  void initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();
      // await _getPastPurchases();
      verifyPurchase();
      subscription = _iap.purchaseStream.listen((data) async {
        purchases.addAll(data);
        // var userId = await SessionData.getUserId();
        // DocumentSnapshot snap =
        //     await firestore.collection('User').doc(userId).get();
        // bool value = snap.get('replay_level');
        // level = snap.get('last_level');
        // level = level.toString().substring(6, 7);
        // int lev = int.parse(level);
        // if (lev == 2 && value == true) {
        //   firestore
        //       .collection('User')
        //       .doc(userId)
        //       .update({'replay_level': false});
        // }
        // firestore.collection('User').doc(userId).set({
        //   'enter_via_paying': true,
        //   'previous_session_info': 'Level_3_setUp_page',
        //   'level_id': 0,
        //   'account_balance': 0,
        //   'need': 0,
        //   'want': 0,
        //   'quality_of_life': 0,
        //   'bill_payment': 0,
        //   if (value != true) 'last_level': 'Level_3_setUp_page',
        // }, SetOptions(merge: true)).then((value) {
        //   Future.delayed(Duration(seconds: 1), () {
        //     Get.offAll(
        //       () => LevelThreeSetUpPage(),
        //     );
        //   });
        // });
        verifyPurchase();
      });
    }
  }

  Future<void> verifyPurchase() async {
    PurchaseDetails purchase = hasPurchased(myProductId);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      var userId = Prefs.getString(PrefString.userId);
      DocumentSnapshot snap =
          await firestore.collection('User').doc(userId).get();
      bool value = snap.get('replay_level');
      level = snap.get('last_level');
      level = level.toString().substring(6, 7);
      int lev = int.parse(level);
      if (lev == 2 && value == true) {
        firestore
            .collection('User')
            .doc(userId)
            .update({'replay_level': false});
      }
      firestore.collection('User').doc(userId).set({
        'enter_via_paying': true,
        'previous_session_info': 'Level_3_setUp_page',
        'level_id': 0,
        'account_balance': 0,
        'need': 0,
        'want': 0,
        'quality_of_life': 0,
        'bill_payment': 0,
        if (value != true) 'last_level': 'Level_3_setUp_page',
      }, SetOptions(merge: true)).then((value) {
        Future.delayed(Duration(seconds: 1), () {
          Get.offAll(
            () => LevelThreeSetUpPage(),
          );
        });
      });
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
        if (purchase != null && purchase.status == PurchaseStatus.purchased) {
          isPurchased = true;
        }
      }
    }
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhereOrNull((purchase) {
      print('PurchaseId ${purchase.productID}');
      print('PurchaseId ${productID}');
      return purchase.productID == productID;
    });
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([myProductId]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    await Prefs.setString(
        PrefString.productPrice, response.productDetails[0].price);
    print('ProduDR ${response.productDetails[0].price}');
    // await Prefs.setString(PrefString.productPrice, data.toString());
    products = response.productDetails;
  }

//
// Future<void> _getPastPurchases() async {
//   // purchases = purchases.map((e){
//   //   return
//   await _iap.restorePurchases();
//   // }).toList();
//   print('REstore ${ _iap.restorePurchases()}');
//
//
//   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
//   for (PurchaseDetails purchase in response.pastPurchases) {
//     if (Platform.isIOS) {
//       _iap.consumePurchase(purchase);
//     }
//   }
//   print("PURCHASES ${response.pastPurchases}");
//   purchases = response.pastPurchases;
// }

}

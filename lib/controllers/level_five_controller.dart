import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/ReusableScreen/GlobleVariable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LevelFiveController extends GetxController {
  List getTotalEmi = [];
  int totalEMILength = 0;

  int totalEMIAmount = 0;
  int getMonth = 0;
  int getEmi = 0;
  int totalEmiAndMonth = 0;
  int creditEmi = 0;
  int checkForEmiCredit = 0;

  int billAmountEmi = 0;
  int emi = 0;
  int getTotalMonth = 0;
  int month = 0;
  var userId;

  getEmiData() {
    userId = GetStorage().read('uId');
    totalEMILength = 0;
    firestore.collection('User').doc(userId).get().then((value) {
      getTotalEmi = value.data()!['List'];
    }).then((v) async {
      if (getTotalEmi == null) {
        totalEMILength = 0;
      } else {
        totalEMILength = getTotalEmi.toList().length;
        totalEMILength = totalEMILength + 1;
      }
      update();
    });
  }

  getEMITotal() {
    billAmountEmi = 0;
    firestore.collection('User').doc(userId).get().then((value) {
      getTotalEmi = value.data()!['List'];
    }).then((v) async {
      if (getTotalEmi != null) {
        for (int i = 0; i < getTotalEmi.toList().length; i++) {
          if (getTotalEmi[i]['month'] != 0) {
            emi = getTotalEmi[i]['emiAmount'];
            billAmountEmi = billAmountEmi + emi;
            update();
          }
        }
        print('TotalEMiAmount $billAmountEmi');
        update();
      }
    });
  }

  decreaseMonthForEmi() {
    // firestore
    //     .collection('User')
    //     .doc(userId)
    //     .collection('List')
    //     .get()
    //     .then((value) {
    //   for (int i = 0; i <= value.docs.length; i++) {
    //     print('aa');
    //     firestore.collection('User').doc(userId).update(
    //       {'month': 0},
    //     );
    //   }
    // });

    firestore.collection('User').doc(userId).get().then((value) {
      getTotalEmi = value.data()!['List'];
      print('GET EMI DATA ${getTotalEmi}');
    }).then((v) async {
      if (getTotalEmi != null) {
        for (int i = 0; i < getTotalEmi.length; i++) {
          if (getTotalEmi[i]['month'] > 0) {
            print(getTotalEmi[i]);
            getTotalMonth = getTotalEmi[i]['month'];
            getTotalMonth = getTotalMonth - 1;

            var mapList = Map<String, dynamic>();
            mapList['emiAmount'] = getTotalEmi[i]['emiAmount'];
            mapList['month'] = getTotalMonth;
            mapList['queId'] = getTotalEmi[i]['queId'];

            getTotalEmi[i] = mapList;
            print('MApList ${mapList}');
            firestore.collection('User').doc(userId).update(
              {'List': getTotalEmi},
            );
          }
        }
      }
      update();
    }).then((value) {
      getTotalMonth = 0;
      month = 0;
      for (int i = 0; i < getTotalEmi.length; i++) {
        if (getTotalEmi[i]['month'] > 0) {
          month = getTotalEmi[i]['month'];
          getTotalMonth = getTotalMonth + month;
        }
      }
    }).then((value) {
      if (getTotalMonth == 0) {
        firestore.collection('User').doc(userId).update({
          'List': FieldValue.delete(),
        });
      }
    });
  }

  getYourEmiData(document) async {
    userId = GetStorage().read('uId');
    DocumentSnapshot doc = await firestore.collection('User').doc(userId).get();
    totalEMIAmount = doc.get('total_emi_level_5');
    print('Total emi amount $totalEMIAmount');
    getEmi = document['emi_amount'];
    getMonth = document['total_month'];
    totalEmiAndMonth = getEmi * getMonth;
    creditEmi = 5000 - totalEMIAmount;
    print('Ttotal emi month $totalEmiAndMonth');
    print('Ttotal emi month $creditEmi');
    checkForEmiCredit = creditEmi - totalEmiAndMonth;
    update();
    print('CRedit ${checkForEmiCredit}');
  }


}

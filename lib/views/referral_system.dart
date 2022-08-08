import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial/cutom_screens/custom_functions.dart';
import 'package:financial/models/provider_model.dart';
import 'package:financial/views/profile/profile.dart';
import 'package:financial/views/setupPage/level_three_setUp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/provider_model.dart';
import '../utils/utils.dart';

class ReferralSystem extends StatefulWidget {
  const ReferralSystem({Key? key}) : super(key: key);

  @override
  State<ReferralSystem> createState() => _ReferralSystemState();
}

class _ReferralSystemState extends State<ReferralSystem> {
  TextEditingController enterCodeCon = TextEditingController();
  StreamController<String> controllerUrl = StreamController<String>();
  var userId;

  getUserId() async {
    userId = Prefs.getString(PrefString.userId);
    print('UserId $userId');
  }

  @override
  void initState() {
    getUserId();
    _referralSystemCompleted();
    super.initState();
  }

  void _buyProduct(ProductDetails product) {
    InAppPurchase _iap = InAppPurchase.instance;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    print('PurchaseParam $purchaseParam');
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderModel>(context);
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0xffFFFFFF),
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.all(3.w),
              child: GestureDetector(
                onTap: () => Get.to(() => SettingsPage()),
                child: Image.asset(AllImages.profileThreeLine,
                    color: Colors.black, width: 8.w, height: 1.h),
              ),
            ),
          ],
        ),
        body: Container(
          height: 100.h,
          width: 100.w,
          color: Color(0xffFFFFFF),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AllStrings.unlockNextLevel,
                      style: AllTextStyles.workSansExtraLarge().copyWith(
                        color: AllColors.purple,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Container(
                      child: Image.asset(AllImages.invitationGif,
                          width: 60.w, height: 35.h),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        AllStrings.inviteFriendsText,
                        style: AllTextStyles.signikaTextMedium().copyWith(
                          color: AllColors.yellowMedium,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    buttonStyleLinear(
                        text: AllStrings.bringFriend,
                        onPressed: () {
                          var userId = Prefs.getString(PrefString.userId);
                          BranchLinkProperties lp = BranchLinkProperties(
                              channel: 'facebook',
                              feature: 'sharing',
                              //alias: 'flutterplugin' //define link url,
                              stage: 'new share',
                              campaign: 'xxxxx',
                              tags: ['one', 'two', 'three']);
                          lp.addControlParam('\$uri_redirect_mode', '1');
                          generateLink(
                              BranchUniversalObject(
                                  canonicalIdentifier: 'flutter/branch',
                                  title: 'Finshark App',
                                  contentDescription: 'Join Us ',
                                  contentMetadata: BranchContentMetaData()
                                    ..addCustomMetadata('userId', userId),
                                  keywords: ['Plugin', 'Branch', 'Flutter'],
                                  publiclyIndex: true,
                                  locallyIndex: true,
                                  expirationDateInMilliSec: DateTime.now()
                                      .add(Duration(days: 365))
                                      .millisecondsSinceEpoch),
                              lp);
                        }),
                    SizedBox(
                      height: 2.h,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: firestore
                            .collection('User')
                            .doc(userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          var userDocument = snapshot.data;
                          List items = userDocument?['referral_by'];
                          int remainingUser = 0;
                          if (items.length != 2) {
                            remainingUser = 2 - items.length;
                          }
                          if (items.length == 2) {
                            _referralSystemCompleted(
                                enterCodeCon: enterCodeCon,
                                totalUser: items.length);
                          }

                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Text(
                                  '${items.length} friend joined, ${remainingUser.toString()} more to go!',
                                  style:
                                      AllTextStyles.signikaTextSmall().copyWith(
                                    color: AllColors.yellowMedium,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Text(
                                  'Or',
                                  style:
                                      AllTextStyles.signikaTextSmall().copyWith(
                                    color: AllColors.leaderBoardTextColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              for (var prod in provider.products)
                                if (userDocument?['enter_via_paying'] == true ||
                                    provider.hasPurchased(prod.id) != null) ...[
                                  Text(
                                    'Thank you for paying',
                                    style: AllTextStyles.signikaTextSmall()
                                        .copyWith(
                                      color: AllColors.yellowMedium,
                                    ),
                                  ),
                                ] else ...[
                                  buttonStyleLinear(
                                      text:
                                          'Pay ${Prefs.getString(PrefString.productPrice)} to UNLOCK',
                                      imageWidget: Image.asset(
                                        AllImages.lockForReferralPage,
                                        height: 4.h,
                                        width: 8.w,
                                      ),
                                      onPressed: () {
                                        _buyProduct(prod);
                                      }),

                                ],
                            ],
                          );
                        }),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 100.w,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: TextFormField(
                              controller: enterCodeCon,
                              decoration: InputDecoration(
                                hintText: AllStrings.inviteCode,
                                filled: true,
                                fillColor: AllColors.skin,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.w),
                                    borderSide:
                                        BorderSide(color: AllColors.lightRed)),
                                hintStyle: AllTextStyles.workSansExtraSmall()
                                    .copyWith(color: Colors.black12),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.w),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.w),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.w),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Flexible(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    primary: AllColors.lightRed,
                                    backgroundColor: AllColors.lightRed),
                                onPressed: () async {
                                  _referralSystemCompleted(
                                      enterCodeCon: enterCodeCon);
                                },
                                child: Center(
                                  child: FittedBox(
                                    child: Text('Enter',
                                        style:
                                            AllTextStyles.workSansSmallWhite()),
                                  ),
                                )),
                          ),
                          // Flexible(
                          //   child: TextButton(
                          //       style: TextButton.styleFrom(
                          //           primary: AllColors.lightRed,
                          //           backgroundColor: AllColors.lightRed),
                          //       onPressed: () async {
                          //         // firestore.collection('User').doc('UdOAibSqCTSf8hoxTLyHnk3hcMC2').set({
                          //         //   'referral_by': [],
                          //         //   'send_by': 0,
                          //         //   'enter_via_special_code': false,
                          //         //   'enter_via_paying': false,
                          //         // }, SetOptions(merge: true));
                          //
                          //         FirebaseFirestore.instance
                          //             .collection('User')
                          //             .get()
                          //             .then((value) {
                          //           value.docs.forEach(
                          //             (element) {
                          //               var docRef = FirebaseFirestore.instance
                          //                   .collection('User')
                          //                   .doc(element.id);
                          //               print(docRef.get());
                          //
                          //               docRef.set({
                          //                 'referral_by': [],
                          //                 'send_by': 0,
                          //                 'enter_via_special_code': false,
                          //                 'enter_via_paying': false,
                          //               }, SetOptions(merge: true));
                          //             },
                          //           );
                          //         });
                          //       },
                          //       child: Center(
                          //         child: FittedBox(
                          //           child: Text('DONE',
                          //               style:
                          //                   AllTextStyles.workSansSmallWhite()),
                          //         ),
                          //       )),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  _referralSystemCompleted(
      {TextEditingController? enterCodeCon, int? totalUser}) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('User').doc(userId).get();
    bool value = documentSnapshot.get('replay_level');
    List referralByLength = documentSnapshot.get('referral_by');
    print('ReferrL ${referralByLength.length}');

    print(enterCodeCon?.text);
    if (enterCodeCon?.text.toString() == 'FINLIT50' ||
        referralByLength.length == 2 ||
        totalUser == 2) {
      firestore.collection('User').doc(userId).set({
        if (enterCodeCon?.text.toString() == 'FINLIT50')
          'enter_via_special_code': true,
        'previous_session_info': 'Level_3_setUp_page',
        if (value != true) 'last_level': 'Level_3_setUp_page',
      }, SetOptions(merge: true));
      Future.delayed(
          Duration(seconds: 1), () => Get.offAll(() => LevelThreeSetUpPage()));
    } else {
      if (enterCodeCon?.text.isNotEmpty == true)
        Fluttertoast.showToast(
          msg: 'Enter valid invitation code',
        );
    }
  }

  void generateLink(BranchUniversalObject buo, BranchLinkProperties lp) async {
    var userId = Prefs.getString(PrefString.userId);
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      print('Short Link ${response.result}');
      controllerUrl.sink.add('${response.result}');
      FlutterShare.share(title: 'Finshark', linkUrl: response.result,)
          .then((value) {
        firestore.collection('User').doc(userId).set({
          'send_by': FieldValue.increment(1),
        }, SetOptions(merge: true));
      });
      // BranchResponse response1 = await FlutterBranchSdk.showShareSheet(
      //     buo: buo,
      //     linkProperties: lp,
      //     messageText: 'My Share text',
      //     androidMessageTitle: 'My Message Title',
      //     androidSharingTitle: 'My Share with');
      // if (response1.success) {
      //   Fluttertoast.showToast(
      //     msg: 'Sharing Success',
      //   );
      // } else {
      //   Fluttertoast.showToast(
      //     msg: 'Sharing Error',
      //   );
      // }
    } else {
      controllerUrl.sink
          .add('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

// Future<Uri> createDynamicLink({required String userId}) async {
//   print('userId $userId');
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//       // This should match firebase but without the username query param
//       uriPrefix: 'https://finshark.page.link',
//       // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
//       link:
//           Uri.parse('https://finshark.referral.com/referral?userId=$userId'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.finshark',
//       ),
//       socialMetaTagParameters: SocialMetaTagParameters(
//           title: 'Refer A Friend', description: 'Refer And Unlock')
//       // iosParameters: IosParameters(
//       //   bundleId: 'com.test.demo',
//       //   minimumVersion: '1',
//       //   appStoreId: '',
//       // ),
//       );
//   final link = await parameters.buildUrl();
//   final ShortDynamicLink shortenedLink =
//       await DynamicLinkParameters.shortenUrl(
//     link,
//     DynamicLinkParametersOptions(
//         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
//   );
//   print('ShortLink ${shortenedLink.shortUrl}');
//   FlutterShare.share(title: 'Finshark', linkUrl: '${shortenedLink.shortUrl}');
//   return shortenedLink.shortUrl;
// }
}

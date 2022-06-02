import 'dart:async';
import 'dart:convert';
import 'package:devicelocale/devicelocale.dart';
import 'package:financial/shareable_screens/globle_variable.dart';
import 'package:financial/shareable_screens/gradient_text.dart';
import 'package:financial/utils/all_colors.dart';
import 'package:financial/utils/all_images.dart';
import 'package:financial/utils/all_strings.dart';
import 'package:financial/utils/all_textStyle.dart';
import 'package:financial/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import '../shareable_screens/network_class.dart';

class ComingSoon extends StatelessWidget {


  ComingSoon({Key? key}) : super(key: key);

  StreamController<String> controllerUrl = StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,),
        // extendBodyBehindAppBar: true,
        body: Container(
          decoration: boxDecoration,
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              Spacer(),
              Text(
                'finshark',
                style: AllTextStyles.finsharkRoboto(),
              ),
              SizedBox(
                height: 8.h,
              ),
              Image.asset(
                AllImages.comingSoon,
                width: 90.w,
                height: 20.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'COMING SOON',
                style: AllTextStyles.comingSoon(),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 18.h,
                width: 80.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w),
                    color: AllColors.lightBlue),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
                  child: Center(
                    child: Text(
                      AllStrings.comingSoon,
                      style: AllTextStyles.dialogStyleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                width: 56.w,
                height: 6.h,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ))),
                  child: GradientText(
                    text: AllStrings.playAgain,
                    style: AllTextStyles.dialogStyleExtraLarge(
                        fontWeight: FontWeight.w700, size: 18.sp),
                    gradient: LinearGradient(colors: [
                      AllColors.blue,
                      AllColors.purple,
                    ]),
                  ),
                  onPressed: () async {
                    // var userId = GetStorage().read('uId');
                    // BranchLinkProperties lp = BranchLinkProperties(
                    //     channel: 'facebook',
                    //     feature: 'sharing',
                    //     //alias: 'flutterplugin' //define link url,
                    //     stage: 'new share',
                    //     campaign: 'xxxxx',
                    //     tags: ['one', 'two', 'three']);
                    // lp.addControlParam('\$uri_redirect_mode', '1');
                    // generateLink(
                    //     BranchUniversalObject(
                    //         canonicalIdentifier: 'flutter/branch',
                    //         title: 'Finshark App',
                    //         contentDescription: 'Join Us ',
                    //         contentMetadata: BranchContentMetaData()
                    //           ..addCustomMetadata('userId', userId),
                    //         keywords: ['Plugin', 'Branch', 'Flutter'],
                    //         publiclyIndex: true,
                    //         locallyIndex: true,
                    //         expirationDateInMilliSec: DateTime.now()
                    //             .add(Duration(days: 365))
                    //             .millisecondsSinceEpoch),
                    //     lp);
                    // firestore
                    //     .collection('User')
                    //     .doc(userId)
                    //     .update({'replay_level': true});
                    Future.delayed(
                        Duration(seconds: 1),
                        () => Get.to(
                              () => SettingsPage(),
                              duration: Duration(milliseconds: 500),
                              transition: Transition.downToUp,
                            ));
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }


  void generateLink(BranchUniversalObject buo, BranchLinkProperties lp) async {
    var userId = GetStorage().read('uId');
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      print('Short Link ${response.result}');
      controllerUrl.sink.add('${response.result}');
      FlutterShare.share(title: 'Finshark', linkUrl: response.result);
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
// Future<String> generateLink() async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'https://finshark.page.link/finsharkApp',
//     link: Uri.parse('https://finshark.page.link/finsharkApp/?uId = $userId'),
//     dynamicLinkParametersOptions: DynamicLinkParametersOptions(
//         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
//     androidParameters:
//         AndroidParameters(packageName: 'com.finshark', minimumVersion: 1),
//     socialMetaTagParameters: SocialMetaTagParameters(title: 'Click the link'),
//   );
//   final Uri dynamicUrl = await parameters.buildUrl();
//   final ShortDynamicLink shortDynamicLink =
//       await DynamicLinkParameters.shortenUrl(
//           dynamicUrl,
//           DynamicLinkParametersOptions(
//               shortDynamicLinkPathLength:
//                   ShortDynamicLinkPathLength.unguessable));
//   final Uri shortUrl = shortDynamicLink.shortUrl;
//   print("${'https://finshark.page.link/finsharkApp' + shortUrl.path}");
//   return 'https://finshark.page.link/finsharkApp' + shortUrl.path;
// }

// @dart=2.9

import 'package:country_code_picker/country_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:financial/helper/route_helper.dart';
import 'package:financial/models/provider_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.android) {
    // For play billing library 2.0 on Android, it is mandatory to call
    // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
    // as part of initializing the app.
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  // FlutterBranchSdk.validateSDKIntegration();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');
  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );
  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  // );
  // await localNotifyManager.configureLocalTimeZone();
  await Firebase.initializeApp();
  await Prefs.init();
  // runApp(ChangeNotifierProvider(
  //   create: (context) => ProviderModel(),
  //   child: DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // ));
  runApp(ChangeNotifierProvider(
      create: (context) => ProviderModel(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();
    super.initState();
    //_checkVersion(context);
  }

  @override
  void dispose() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.subscription.cancel();
    super.dispose();
  }

  _checkVersion(BuildContext context) async {
    try {
      print('CalledVersion');
      NewVersion(
        // iOSId: 'com.version check.iOS',//dummy IOS bundle ID
        androidId: 'com.finshark', //dummy android ID
      ).showAlertIfNecessary(context: context);
    } catch (e) {
      debugPrint("error=====>${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        // supportedLocales: [
        //   Locale("af"),
        //   Locale("am"),
        //   Locale("ar"),
        //   Locale("az"),
        //   Locale("be"),
        //   Locale("bg"),
        //   Locale("bn"),
        //   Locale("bs"),
        //   Locale("ca"),
        //   Locale("cs"),
        //   Locale("da"),
        //   Locale("de"),
        //   Locale("el"),
        //   Locale("en"),
        //   Locale("es"),
        //   Locale("et"),
        //   Locale("fa"),
        //   Locale("fi"),
        //   Locale("fr"),
        //   Locale("gl"),
        //   Locale("ha"),
        //   Locale("he"),
        //   Locale("hi"),
        //   Locale("hr"),
        //   Locale("hu"),
        //   Locale("hy"),
        //   Locale("id"),
        //   Locale("is"),
        //   Locale("it"),
        //   Locale("ja"),
        //   Locale("ka"),
        //   Locale("kk"),
        //   Locale("km"),
        //   Locale("ko"),
        //   Locale("ku"),
        //   Locale("ky"),
        //   Locale("lt"),
        //   Locale("lv"),
        //   Locale("mk"),
        //   Locale("ml"),
        //   Locale("mn"),
        //   Locale("ms"),
        //   Locale("nb"),
        //   Locale("nl"),
        //   Locale("nn"),
        //   Locale("no"),
        //   Locale("pl"),
        //   Locale("ps"),
        //   Locale("pt"),
        //   Locale("ro"),
        //   Locale("ru"),
        //   Locale("sd"),
        //   Locale("sk"),
        //   Locale("sl"),
        //   Locale("so"),
        //   Locale("sq"),
        //   Locale("sr"),
        //   Locale("sv"),
        //   Locale("ta"),
        //   Locale("tg"),
        //   Locale("th"),
        //   Locale("tk"),
        //   Locale("tr"),
        //   Locale("tt"),
        //   Locale("uk"),
        //   Locale("ug"),
        //   Locale("ur"),
        //   Locale("uz"),
        //   Locale("vi"),
        //   Locale("zh")
        // ],
        localizationsDelegates: [
          CountryLocalizations.delegate,
        ],
        // builder: (BuildContext context, Widget child) {
        //   return MediaQuery(
        //     data: MediaQuery.of(context).copyWith(
        //       textScaleFactor: 1.0,
        //     ),
        //     //set desired text scale factor here
        //     child: child,
        //   );
        // },
        title: 'Finshark',
        debugShowCheckedModeBanner: false,
        //initialBinding: NetworkBinding(),
        locale: DevicePreview.locale(context),
        // Add the locale here
        builder: DevicePreview.appBuilder,
        // Add the builder here
        getPages: RouteHelper.getPages,
        initialRoute: RouteHelper.splash,
        //home: LevelOneSetUpPage()
      );
    });
  }
}

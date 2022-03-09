// @dart=2.9
import 'package:country_code_picker/country_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:financial/controllers/UserInfoController.dart';
import 'package:financial/network/network_binding.dart';
import 'package:financial/views/AllDoneScreen.dart';
import 'package:financial/views/AllQueLevelFive.dart';
import 'package:financial/views/AllQueLevelFour.dart';
import 'package:financial/views/AllQueLevelOne.dart';
import 'package:financial/views/AllQueLevelSix.dart';
import 'package:financial/views/AllQueLevelThree.dart';
import 'package:financial/views/AllQueLevelTwo.dart';
import 'package:financial/views/ComingSoon.dart';
import 'package:financial/views/LevelFiveSetUpPage.dart';
import 'package:financial/views/LevelFourAndFiveOptions.dart';
import 'package:financial/views/LevelFourSetUpPage.dart';
import 'package:financial/views/LevelOnePopQuiz.dart';
import 'package:financial/views/LevelOneSetUpPage.dart';
import 'package:financial/views/LevelSixSetUpPage.dart';
import 'package:financial/views/LevelThreeSetUpPage.dart';
import 'package:financial/views/LevelTwoAndThreeOptions.dart';
import 'package:financial/views/LevelTwoSetUpPage.dart';
import 'package:financial/views/LoginPage.dart';
import 'package:financial/views/OnBoardingPage.dart';
import 'package:financial/views/PopQuiz.dart';
import 'package:financial/views/ProfilePage.dart';
import 'package:financial/views/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

// void main() async {
//   await GetStorage.init();
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(  DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => MyApp(), // Wrap your app
//   ),);
// }


void main() async {
await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        supportedLocales: [
          Locale("af"),
          Locale("am"),
          Locale("ar"),
          Locale("az"),
          Locale("be"),
          Locale("bg"),
          Locale("bn"),
          Locale("bs"),
          Locale("ca"),
          Locale("cs"),
          Locale("da"),
          Locale("de"),
          Locale("el"),
          Locale("en"),
          Locale("es"),
          Locale("et"),
          Locale("fa"),
          Locale("fi"),
          Locale("fr"),
          Locale("gl"),
          Locale("ha"),
          Locale("he"),
          Locale("hi"),
          Locale("hr"),
          Locale("hu"),
          Locale("hy"),
          Locale("id"),
          Locale("is"),
          Locale("it"),
          Locale("ja"),
          Locale("ka"),
          Locale("kk"),
          Locale("km"),
          Locale("ko"),
          Locale("ku"),
          Locale("ky"),
          Locale("lt"),
          Locale("lv"),
          Locale("mk"),
          Locale("ml"),
          Locale("mn"),
          Locale("ms"),
          Locale("nb"),
          Locale("nl"),
          Locale("nn"),
          Locale("no"),
          Locale("pl"),
          Locale("ps"),
          Locale("pt"),
          Locale("ro"),
          Locale("ru"),
          Locale("sd"),
          Locale("sk"),
          Locale("sl"),
          Locale("so"),
          Locale("sq"),
          Locale("sr"),
          Locale("sv"),
          Locale("ta"),
          Locale("tg"),
          Locale("th"),
          Locale("tk"),
          Locale("tr"),
          Locale("tt"),
          Locale("uk"),
          Locale("ug"),
          Locale("ur"),
          Locale("uz"),
          Locale("vi"),
          Locale("zh")
        ],
        localizationsDelegates: [
          CountryLocalizations.delegate,
         ],
      builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            //set desired text scale factor here
            child: child,
          );
        },
         title: 'Finshark',
        debugShowCheckedModeBanner: false,
        initialBinding: NetworkBinding(),
        // locale: DevicePreview.locale(context), // Add the locale here
        // builder: DevicePreview.appBuilder, // Add the builder here
        getPages: [
          GetPage(name: '/Level1', page:()=> AllQueLevelOne()),
          GetPage(name: '/Level2', page:()=> AllQueLevelTwo()),
          GetPage(name: '/Level3', page:()=> AllQueLevelThree()),
          GetPage(name: '/Level4', page:()=> AllQueLevelFour()),
          GetPage(name: '/Level5', page:()=> AllQueLevelFive()),
          GetPage(name: '/Level6', page:()=> AllQueLevelSix()),
          GetPage(name: '/Level1SetUp', page:()=> LevelOneSetUpPage()),
          GetPage(name: '/Level2SetUp', page:()=> LevelTwoSetUpPage()),
          GetPage(name: '/Level3SetUp', page:()=> LevelThreeSetUpPage()),
          GetPage(name: '/Level4SetUp', page:()=> LevelFourSetUpPage()),
          GetPage(name: '/Level5SetUp', page:()=> LevelFiveSetUpPage()),
          GetPage(name: '/Level6SetUp', page:()=> LevelSixSetUpPage()),
          GetPage(name: '/LevelTwoThreeOptions', page:()=> LevelTwoAndThreeOptions()),
          GetPage(name: '/LevelFourOptionsPage', page:()=> LevelFourAndFiveOptions()),
          GetPage(name: '/Splash', page:()=> SplashScreen()),
          GetPage(name: '/OnBoarding', page:()=> OnBoardingPage()),
          GetPage(name: '/Login', page:()=> LoginPage()),
          GetPage(name: '/LevelOnePopQuiz', page:()=> LevelOnePopQuiz()),
          GetPage(name: '/PopQuiz', page:()=> PopQuiz()),
          GetPage(name: '/Profile', page:()=> ProfilePage()),
          GetPage(name: '/ComingSoon', page:()=> ComingSoon()),
          GetPage(name: '/AllDone', page:()=> AllDone()),
        ],
       // initialRoute: '/Level4SetUp',
        home: LevelOneSetUpPage(),
      );
    });
  }

}


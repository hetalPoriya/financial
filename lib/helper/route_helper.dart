import 'package:financial/views/all_done_screen.dart';
import 'package:financial/views/all_que_level_five.dart';
import 'package:financial/views/all_que_level_four.dart';
import 'package:financial/views/all_que_level_one.dart';
import 'package:financial/views/all_que_level_six.dart';
import 'package:financial/views/all_que_level_three.dart';
import 'package:financial/views/all_que_level_two.dart';
import 'package:financial/views/coming_soon.dart';
import 'package:financial/views/leader_board.dart';
import 'package:financial/views/level_five_setUp_page.dart';
import 'package:financial/views/level_four_and_five_options.dart';
import 'package:financial/views/level_four_setUp_page.dart';
import 'package:financial/views/level_one_pop_quiz.dart';
import 'package:financial/views/level_one_setUp_page.dart';
import 'package:financial/views/level_six_setUp_page.dart';
import 'package:financial/views/level_three_setUp_page.dart';
import 'package:financial/views/level_two_and_three_options.dart';
import 'package:financial/views/level_two_setUp_page.dart';
import 'package:financial/views/login_page.dart';
import 'package:financial/views/on_boarding_page.dart';
import 'package:financial/views/pop_quiz.dart';
import 'package:financial/views/levels.dart';
import 'package:financial/views/rate_us.dart';
import 'package:financial/views/settings_page.dart';
import 'package:financial/views/splash_screen.dart';
import 'package:get/get.dart';

class RouteHelper{

  static  String splash = '/Splash';
  static  String onBoarding = '/OnBoarding';
  static  String login = '/Login';
  static  String levels = '/Levels';
  static  String level1 = '/Level1';
  static  String level2 = '/Level2';
  static  String level3= '/Level3';
  static  String level4= '/Level4';
  static  String level5= '/Level5';
  static  String level6= '/Level6';
  static  String allDone= '/AllDone';
  static  String popQuiz= '/PopQuiz';
  static  String level1PopQuiz= '/LevelOnePopQuiz';
  static  String level1setUpPage= '/Level1SetUp';
  static  String level2setUpPage= '/Level2SetUp';
  static  String level3setUpPage= '/Level3SetUp';
  static  String level4setUpPage= '/Level4SetUp';
  static  String level5setUpPage= '/Level5SetUp';
  static  String level6setUpPage= '/Level6SetUp';
  static  String level2And3Options= '/LevelTwoThreeOptions';
  static  String level4Options= '/LevelFourOptionsPage';
  static  String comingSoon= '/ComingSoon';
  static  String rateUs= '/RateUs';
  static  String settings= '/Settings';
  static  String leaderBoard= '/LeaderBoard';

  static List<GetPage> getPages = [
    GetPage(name: level1, page: () => AllQueLevelOne()),
    GetPage(name:level2, page: () => AllQueLevelTwo()),
    GetPage(name: level3, page: () => AllQueLevelThree()),
    GetPage(name: level4, page: () => AllQueLevelFour()),
    GetPage(name: level5, page: () => AllQueLevelFive()),
    GetPage(name: level6, page: () => AllQueLevelSix()),
    GetPage(name: level1setUpPage, page: () => LevelOneSetUpPage()),
    GetPage(name: level2setUpPage, page: () => LevelTwoSetUpPage()),
    GetPage(name:level3setUpPage, page: () => LevelThreeSetUpPage()),
    GetPage(name: level4setUpPage, page: () => LevelFourSetUpPage()),
    GetPage(name:level5setUpPage, page: () => LevelFiveSetUpPage()),
    GetPage(name:level6setUpPage, page: () => LevelSixSetUpPage()),
    GetPage(name: level2And3Options, page: () => LevelTwoAndThreeOptions()),
    GetPage(name:level4Options, page: () => LevelFourAndFiveOptions()),
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: onBoarding, page: () => OnBoardingPage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: level1PopQuiz, page: () => LevelOnePopQuiz()),
    GetPage(name: popQuiz, page: () => PopQuiz()),
    GetPage(name: levels, page: () => Levels()),
    GetPage(name: comingSoon, page: () => ComingSoon()),
    GetPage(name: allDone, page: () => AllDone()),
    GetPage(name: rateUs, page: () => RateUs(onSubmit: () {},)),
    GetPage(name: settings, page: () => SettingsPage()),
    GetPage(name: leaderBoard, page: () => LeaderBoard(userName: '',userId: '',)),
  ];
}
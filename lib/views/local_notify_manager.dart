import 'dart:io' show Platform;
import 'package:financial/utils/AllStrings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifyManager {
  //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;

  var userId = GetStorage().read('uId');

  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<ReceiveNotification>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LocalNotifyManager.init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatform();
  }

  initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    initSetting = InitializationSettings(android: initSettingAndroid);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String? payLoad) async {
      onNotificationClick(payLoad);
    });
  }

  // Future<void> showNotification() async {
  //   var androidChannel =
  //       AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           playSound: true,
  //           //sound: RawResourceAndroidNotificationSound('notification_sound')
  //           //icon: '@mipmap/ic_launcher'
  //           timeoutAfter: 5000,
  //           enableLights: true);
  //   var platformChannel = NotificationDetails(android: androidChannel);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Test 1',
  //     'Body 1',
  //     platformChannel,
  //     payload: 'New payload',
  //   );
  // }
  // Future<void> scheduleNotification() async {
  //   var scheduleNotificationDataTime = DateTime.now().add(Duration(seconds: 5));
  //   var androidChannel =
  //       AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           playSound: true,
  //           //sound: RawResourceAndroidNotificationSound('notification_sound')
  //           //icon: '@mipmap/ic_launcher'
  //           timeoutAfter: 5000,
  //           enableLights: true);
  //   var platformChannel = NotificationDetails(android: androidChannel);
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'schedule title',
  //       'schedule body',
  //       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
  //       platformChannel,
  //       payload: 'schedule payload',
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime);
  // }

  Future<void> repeatNotificationLevel1() async {
    var androidChannel =
        AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            //sound: RawResourceAndroidNotificationSound('notification_sound')
            //icon: '@mipmap/ic_launcher'
            timeoutAfter: 5000,
            enableLights: true);
    var platformChannel = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      21,
      'repeat Level 1',
      'repeat Level 1',
      RepeatInterval.everyMinute,
      platformChannel,
      payload: 'repeat payload',
      androidAllowWhileIdle: true,
    );
  }
  Future<void> repeatNotificationLevel2() async {
    var androidChannel =
    AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        //sound: RawResourceAndroidNotificationSound('notification_sound')
        //icon: '@mipmap/ic_launcher'
        timeoutAfter: 5000,
        enableLights: true);
    var platformChannel = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      22,
      'repeat Level 2',
      'repeat Level 2',
      RepeatInterval.everyMinute,
      platformChannel,
      payload: 'repeat payload',
      androidAllowWhileIdle: true,
    );
  }
  Future<void> repeatNotificationLevel3() async {
    var androidChannel =
    AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        //sound: RawResourceAndroidNotificationSound('notification_sound')
        //icon: '@mipmap/ic_launcher'
        timeoutAfter: 5000,
        enableLights: true);
    var platformChannel = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      23,
      'repeat Level 3',
      'repeat Level 3',
      RepeatInterval.everyMinute,
      platformChannel,
      payload: 'repeat payload',
      androidAllowWhileIdle: true,
    );
  }
  Future<void> repeatNotificationLevel4() async {
    var androidChannel =
    AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        //sound: RawResourceAndroidNotificationSound('notification_sound')
        //icon: '@mipmap/ic_launcher'
        timeoutAfter: 5000,
        enableLights: true);
    var platformChannel = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      24,
      'repeat Level 4',
      'repeat Level 4',
      RepeatInterval.everyMinute,
      platformChannel,
      payload: 'repeat payload',
      androidAllowWhileIdle: true,
    );
  }


  // Future<void> dailyAtTimeNotification() async {
  //   var androidChannel = AndroidNotificationDetails(
  //     'CHANNEL_ID', 'CHANNEL_NAME',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     playSound: true,
  //     //sound: RawResourceAndroidNotificationSound('notification_sound')
  //     //icon: '@mipmap/ic_launcher'
  //     timeoutAfter: 5000,
  //     enableLights: true,
  //     styleInformation: BigTextStyleInformation(''),
  //   );
  //   var platformChannel = NotificationDetails(android: androidChannel);
  //   await flutterLocalNotificationsPlugin.zonedSchedule(0, 'daily title',
  //       'daily body', _nextInstanceOfSaturdayTenAM(), platformChannel,
  //       payload: 'daily payload',
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.dateAndTime);
  // }
  // tz.TZDateTime _nextInstanceOfTenAM() {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   // tz.TZDateTime scheduledDate =
  //   //     tz.TZDateTime(tz.local, now.year, now.month, now.day, 18);
  //   tz.TZDateTime scheduledDate = tz.TZDateTime.from(
  //       DateTime(now.year, now.month, now.day, 10, 33), tz.local);
  //   print('sss ${scheduledDate}');
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
  // tz.TZDateTime _nextInstanceOfSaturdayTenAM() {
  //   tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
  //   while (scheduledDate.weekday != DateTime.thursday) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

  var androidChannel = AndroidNotificationDetails(
    'CHANNEL_ID',
    'CHANNEL_NAME',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    timeoutAfter: 5000,
    enableLights: true,
    styleInformation: BigTextStyleInformation(''),
  );

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  tz.TZDateTime _nextInstanceOfElevenAm() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
    // tz.TZDateTime scheduledDate = tz.TZDateTime.from(
    //     DateTime(now.year, now.month, now.day, 10, 00), tz.local);
    print('sss ${scheduledDate}');
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  tz.TZDateTime _nextInstanceOfSaturdayElevenAM() {
    tz.TZDateTime scheduledDate = _nextInstanceOfElevenAm();
    while (scheduledDate.weekday != DateTime.thursday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfSevenPm() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    // tz.TZDateTime scheduledDate = tz.TZDateTime.from(
    //     DateTime(now.year, now.month, now.day, 10, 02), tz.local);
    print('sss ${scheduledDate}');
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  tz.TZDateTime _nextInstanceOfWednesdaySevenPm() {
    tz.TZDateTime scheduledDate = _nextInstanceOfSevenPm();
    while (scheduledDate.weekday != DateTime.friday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  functionForPushNotification(
      {int? id, String? title, String? body, tz.TZDateTime? tzDateTime}) async {
    var platformChannel = NotificationDetails(android: androidChannel);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id!, title, body, tzDateTime!, platformChannel,
        payload: 'daily payload',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  scheduleNotificationForLevelOneSaturdayElevenAm() async {
    functionForPushNotification(
        id: 1,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel1,
        // title: 'Level 1 First Title',
        // body: 'Level 1 First Body',
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }
  scheduleNotificationForLevelTwoSaturdayElevenAm() async {
    functionForPushNotification(
        id: 2,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel2,
        // title: 'Level 2 First Title',
        // body: 'Level 2 First Body',
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }
  scheduleNotificationForLevelThreeSaturdayElevenAm() async {
    functionForPushNotification(
        id: 3,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel3,
        // title: 'Level 3 First Title',
        // body: 'Level 3 First Body',
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }
  scheduleNotificationForLevelFourSaturdayElevenAm() async {
    functionForPushNotification(
        id: 4,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel4,
        // title: 'Level 4 First Title',
        // body: 'Level 4 First Body',
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }

  scheduleNotificationForLevelOneWednesdaySevenPm() async {
    functionForPushNotification(
        id: 7,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel1,
        // title: 'Level 1 Second Title',
        // body: 'Level 1 Second Body',
        tzDateTime: _nextInstanceOfWednesdaySevenPm());
  }
  scheduleNotificationForLevelTwoWednesdaySevenPm() async {
    functionForPushNotification(
        id: 8,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel2,
        // title: 'Level 2 Second Title',
        // body: 'Level 2 Second Body',
        tzDateTime: _nextInstanceOfWednesdaySevenPm());
  }
  scheduleNotificationForLevelThreeWednesdaySevenPm() async {
    functionForPushNotification(
        id: 9,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel3,
        // title: 'Level 3 Second Title',
        // body: 'Level 3 Second Body',
        tzDateTime: _nextInstanceOfWednesdaySevenPm());
  }
  scheduleNotificationForLevelFourWednesdaySevenPm() async {
    functionForPushNotification(
        id: 10,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel4,
        // title: 'Level 4 Second Title',
        // body: 'Level 4 Second Body',
        tzDateTime: _nextInstanceOfWednesdaySevenPm());
  }

// Future<void> scheduleWeeklySaturdayElevenAmNotificationForLevelOne() async {
//   scheduleNotificationForLevelOne(tzDateTime: _nextInstanceOfSaturdayElevenAM());
// }
// Future<void> scheduleWeeklySaturdayElevenAmNotificationForLevelTwo() async {
//   scheduleNotificationForLevelTwo(tzDateTime: _nextInstanceOfSaturdayElevenAM());
// }
// Future<void> scheduleWeeklySaturdayElevenAmNotificationForLevelThree() async {
//   scheduleNotificationForLevelThree(tzDateTime: _nextInstanceOfSaturdayElevenAM());
// }
// Future<void> scheduleWeeklySaturdayElevenAmNotificationForLevelFour() async {
//   scheduleNotificationForLevelFour(tzDateTime: _nextInstanceOfSaturdayElevenAM());
// }
//
//
// Future<void> scheduleWeeklyWednesdaySevenPmNotificationForLevelOne() async {
//   scheduleNotificationForLevelOne(tzDateTime: _nextInstanceOfWednesdaySevenPm());
// }
// Future<void> scheduleWeeklyWednesdaySevenPmNotificationForLevelTwo() async {
//   scheduleNotificationForLevelTwo(tzDateTime: _nextInstanceOfWednesdaySevenPm());
// }
// Future<void> scheduleWeeklyWednesdaySevenPmNotificationForLevelThree() async {
//   scheduleNotificationForLevelThree(tzDateTime: _nextInstanceOfWednesdaySevenPm());
// }
// Future<void> scheduleWeeklyWednesdaySevenPmNotificationForLevelFour() async {
//   scheduleNotificationForLevelFour(tzDateTime: _nextInstanceOfWednesdaySevenPm());
// }

}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceiveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

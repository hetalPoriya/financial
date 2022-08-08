import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../utils/utils.dart';

class LocalNotifyManager {
  //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;

  var userId =Prefs.getString(PrefString.userId);

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



  var androidChannel =const AndroidNotificationDetails(
    'CHANNEL_ID',
    'CHANNEL_NAME',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
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
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  tz.TZDateTime _nextInstanceOfSaturdayElevenAM() {
    tz.TZDateTime scheduledDate = _nextInstanceOfElevenAm();
    while (scheduledDate.weekday != DateTime.saturday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfSevenPm() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 19);
    // tz.TZDateTime scheduledDate = tz.TZDateTime.from(
    //     DateTime(now.year, now.month, now.day, 10, 02), tz.local);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  tz.TZDateTime _nextInstanceOfWednesdaySevenPm() {
    tz.TZDateTime scheduledDate = _nextInstanceOfSevenPm();
    while (scheduledDate.weekday != DateTime.wednesday) {
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
         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime
    );
  }

  Future<void>  scheduleNotificationForLevelOneSaturdayElevenAm() async {
    await functionForPushNotification(
        id: 1,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel1,
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }
  Future<void>  scheduleNotificationForLevelTwoSaturdayElevenAm() async {
    await functionForPushNotification(
        id: 2,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel2,
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }
  Future<void>  scheduleNotificationForLevelThreeSaturdayElevenAm() async {
    await functionForPushNotification(
        id: 3,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel3,
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }
  Future<void> scheduleNotificationForLevelFourSaturdayElevenAm() async {
    await  functionForPushNotification(
        id: 4,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel4,
        tzDateTime: _nextInstanceOfSaturdayElevenAM());
  }

  Future<void>  scheduleNotificationForLevelOneWednesdaySevenPm() async {
    await functionForPushNotification(
        id: 7,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel1,
        tzDateTime: _nextInstanceOfWednesdaySevenPm());
  }
  Future<void> scheduleNotificationForLevelTwoWednesdaySevenPm() async {
    await functionForPushNotification(
        id: 8,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel2,
        tzDateTime: _nextInstanceOfWednesdaySevenPm());
  }
  Future<void>  scheduleNotificationForLevelThreeWednesdaySevenPm() async {
    await functionForPushNotification(
        id: 9,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel3,
        tzDateTime: _nextInstanceOfWednesdaySevenPm());
  }
  Future<void> scheduleNotificationForLevelFourWednesdaySevenPm() async {
    await functionForPushNotification(
        id: 10,
        title: AllStrings.notificationTitle,
        body: AllStrings.notificationBodyLevel4,
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


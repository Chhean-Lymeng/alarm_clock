import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleAlarm(DateTime scheduledNotificationDateTime) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'alarm_notif',
    'Alarm Notifications',
    channelDescription: 'Channel for Alarm notification',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
  );

  const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
    sound: 'a_long_cold_sting.wav',
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(
    0,
    'Alarm',
    'Your alarm is ringing',
    scheduledNotificationDateTime,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}

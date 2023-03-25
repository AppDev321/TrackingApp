import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Controller.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  late FlutterLocalNotificationsPlugin plugin;

  NotificationService._internal() {

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    plugin = FlutterLocalNotificationsPlugin();
    plugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      Controller().printLogs('notification payload: $payload');
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  Future<void> newNotification(String title,String msg, bool vibration) async {
    // Define vibration pattern
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    AndroidNotificationDetails androidNotificationDetails;

    final channelName = 'Text messages';

    androidNotificationDetails = AndroidNotificationDetails(
        channelName, channelName,
        importance: Importance.max,
        priority: Priority.high,
        vibrationPattern: vibration ? vibrationPattern : null,
        enableVibration: vibration);

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails);

    try {
      await plugin.show(0, title, msg, notificationDetails);
    } catch (ex) {
      Controller().printLogs(ex.toString());
    }
  }
}

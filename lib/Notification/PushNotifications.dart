import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tracking_app/Utils/Controller.dart';

import '../Utils/NotificationService.dart';

class PushNotifications {
  static final PushNotifications _instance = PushNotifications._internal();

  factory PushNotifications() => _instance;

  PushNotifications._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isConfigured = false;

  var _tokenStreamController = StreamController<String>.broadcast();

  Stream<String> get token => _tokenStreamController.stream;

  var _notificationStreamController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get notification => _notificationStreamController.stream;

  init() {
    // Request push permissions
    _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // Get device token
    _firebaseMessaging.getToken().then((token) {
      Controller().printLogs('===== FCM Token =====');
      Controller().printLogs(token.toString());
      saveDeviceToken(token);
    });

    // Configure messaging receiving
    //if (!_isConfigured) {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Controller().printLogs('======= On Message =======');
      setStreamData(message);
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      Controller().printLogs('======= On Background Message =======');
      setStreamData(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Controller().printLogs('======= On App Open Message =======');
      setStreamData(message);
    });

    // _isConfigured = true;
    //}
  }

  static Future<dynamic> backgroundMessageHandler(
      Map<String, dynamic> notInfo) async {
    return Future.value();
  }

  setStreamData(RemoteMessage message) {
    if (kDebugMode) {
      Controller()
          .printLogs('Handling a foreground message: ${message.messageId}');
      Controller().printLogs('Message data: ${message.data}');
      Controller()
          .printLogs('Message notification: ${message.notification?.title}');
      Controller()
          .printLogs('Message notification: ${message.notification?.body}');
    }

    Controller().printLogs('===== STREAM NOTIFICATION =====');

    _notificationStreamController.sink.add(message);
    NotificationService().newNotification(
        message.notification!.title.toString(),
        "Set Local Notification",
        false);
  }

  saveDeviceToken(token) {
    // await UserPreferences.setString(config.deviceTokenPrefId, token);
    _tokenStreamController.sink.add(token);
  }

  /* Future<String> getDeviceToken() async {
    return await UserPreferences.getString(config.deviceTokenPrefId);
  }*/

  dispose() {
    _notificationStreamController?.close();
    _tokenStreamController?.close();
  }
}

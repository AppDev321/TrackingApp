import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:tracking_app/Controller/BackgroundService.dart';
import 'package:tracking_app/Notification/PushNotifications.dart';
import 'package:tracking_app/View/LoginPage.dart';
import 'Utils/Controller.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Controller().printLogs("background notficaiton");
  PushNotifications().firebaseMessagingBackgroundHandler(message);
}




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   //await Firebase.initializeApp();
 //  NotificationService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            return LoginPage();
          }

          return Container(color: Colors.white,);
        },
      )
    );
  }

  Future<void> initializeFirebaseData() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    //For IOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

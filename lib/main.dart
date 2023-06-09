import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_app/Notification/PushNotifications.dart';
import 'package:tracking_app/View/LoginPage.dart';

import 'Utils/Controller.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Controller().printLogs("background notification");
  PushNotifications().firebaseMessagingBackgroundHandler(message);
}
Future<void> initializeFirebaseData() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebaseData();

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


}

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tracking_app/View/LoginPage.dart';

final service = FlutterBackgroundService();
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {


 DartPluginRegistrant.ensureInitialized();

   service.on('setAsForeground').listen((event) {
     print("Service foreground");
   });
   service.on('setAsBackground').listen((event) {
     print("Service backgorund");
   });

 service.on('stopService').listen((event) {
   print("Service stop");
   service.stopSelf();
 });

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration:IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),

  );
  service.startService();

/*

  Timer.periodic(const Duration(seconds: 2), (timer) async {

    service.invoke(
      'setAsForeground',
      {
        "current_date": DateTime.now().toIso8601String(),
      },
    );
  });
*/




  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

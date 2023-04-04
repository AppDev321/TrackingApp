import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../NetworkAPI/app_repository.dart';
import '../NetworkAPI/response/api_response.dart';

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  print("Background Service:== $service");
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();


  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      print("Foregorund listin");
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      print("backgorund listin");
      service.setAsBackgroundService();
    });
  }


  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  service.on('update').listen((event) {
    print("Service events: $event");
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": "Testing data ",
      },
    );
  });

  //service.on("start_tracking").listen((event) {

   /* Timer.periodic(const Duration(seconds: 5), (timer) async {

     var position=await  Geolocator.getCurrentPosition();

     var map = Map<String, String>();
     map['latitude'] = position.latitude.toString();
     map['longitude'] = position.longitude.toString();
     map['driver_id'] = "7";
     BackgroundService().updateDriverLocation(map);

     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

     if (service is AndroidServiceInstance) {
       service.setForegroundNotificationInfo(
         title: "Tracking App",
         content: " Updated at ${DateTime.now()} Your device is begin used for realtime tracking ",
       );
     }
    });*/


  //});



  // bring to foreground
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    print("Periodic Service ==(:::)== $service");
    var position = await Geolocator.getCurrentPosition();

    var map = Map<String, String>();
    map['latitude'] = position.latitude.toString();
    map['longitude'] = position.longitude.toString();
    map['driver_id'] = "7";
    print('Location SERVICE: ${map.toString()}');
   // BackgroundService().updateDriverLocation(map);


    //if (service is AndroidServiceInstance) {
    //  if (await service.isForegroundService()) {
         flutterLocalNotificationsPlugin.show(
          888,
          'Tracking App',
           "Updated at ${DateTime.now()}",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
              playSound: false
            ),
            iOS: DarwinNotificationDetails(
              presentSound: false,
              presentBadge: true,
              presentAlert: true,

            )
          ),
        );

       // if you don't using custom notification, uncomment this
      /*  service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );*/
   //   }
  //  }


          // if you don't using custom notification, uncomment this
          /*  service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );*/



    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');




  });
}

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();

  factory BackgroundService() => _instance;

  BackgroundService._internal();
  final service = FlutterBackgroundService();

  final _appRepo = NetworkRepository();
  var apiResponseData = ApiResponse.none();


  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'Tracking App Service',
        initialNotificationContent: 'Initializing itself',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground:onIosBackground,
      ),
    );
  }

  void startService() async {

    var isRunning = await service.isRunning();
    if (!isRunning) {

      service.startService();
      Future.delayed(Duration(seconds: 2),(){
        service.invoke(
          'start_tracking',
          {
            "current_date": DateTime.now().toIso8601String(),
            "device": "Testing data ",
          },
        );
      });

    }
   // runBackgroundWork();
  }

  void stopService() async {

    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
  }

  void updateDriverLocation(Map<String, String> request) async {
    apiResponseData = ApiResponse.loading();
    var res = await _appRepo.updateLocation(request);
    if (res is String) {
      apiResponseData = ApiResponse.error(res);
    } else {
      apiResponseData = ApiResponse.completed(res);
    }
  }

}

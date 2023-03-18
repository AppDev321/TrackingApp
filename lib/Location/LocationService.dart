import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class LocationService {



  Future<void> init() async {
    try {

      beginTracking();



    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }


  static Future<String> callAPI() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to call API');
    }
  }


  Future<void> beginTracking() async {
    BackgroundLocation.setAndroidNotification(
      title: "Gatego is tracking your location",
      message: "Click here to open the Gatego Driver app.",
      icon: "@mipmap/launcher_icon",
    );
    BackgroundLocation.startLocationService(distanceFilter: 1);


    BackgroundLocation.getLocationUpdates((location) {
      print("backgorund workssss");
    });
  }

}

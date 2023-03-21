import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


//Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//Position position = await Geolocator.getLastKnownPosition()

class LocationController extends GetxController {
  var latitude = 'Getting Latitude..'.obs;
  var longitude = 'Getting Longitude..'.obs;
  var address = 'Getting Address..'.obs;
  late StreamSubscription<Position> streamSubscription;
  Timer? timer;

  @override
  void onInit() async {
    super.onInit();
    await GetStorage.init();
    await beginTracking();
    getLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    print("onclose called");
    streamSubscription.cancel();
  }

  getLocation() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    /*streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          latitude.value = 'Latitude : ${position.latitude}';
          longitude.value = 'Longitude : ${position.longitude}';
          getAddressFromLatLang(position);
         // print("location = ${latitude.value}");

        });*/


    timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      var location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("location == ${location.longitude}");
      latitude.value = 'Latitude : ${location.latitude}';
      longitude.value = 'Longitude : ${location.longitude}';
    });



  }

  Future<void> beginTracking() async {
    BackgroundLocation.setAndroidNotification(
      title: "Gatego is tracking your location",
      message: "Click here to open the Gatego Driver app.",
      icon: "@mipmap/launcher_icon",
    );
    BackgroundLocation.startLocationService(distanceFilter: 1);

    /* BackgroundLocation.getLocationUpdates((location) {
      print("backgorund workssss");
    });*/
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address.value = 'Address : ${place.locality},${place.country}';
  }
}

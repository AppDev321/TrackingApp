import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracking_app/Controller/LocationController.dart';

import '../Model/response/LoginResponse.dart';
import '../Model/response/RouteResponse.dart';
import '../NetworkAPI/app_repository.dart';
import '../NetworkAPI/response/api_response.dart';
import '../Utils/Controller.dart';
import 'BackgroundService.dart';

class HomeController extends GetxController {
  late BuildContext context;

  final _appRepo = NetworkRepository();
  var loginData = ApiResponse.none().obs;

  Rx<List<SegmentDetail>> listRoutes = Rx<List<SegmentDetail>>([]);
  Rx<List<RouteDetail>> listWayPoints = Rx<List<RouteDetail>>([]);
  var fromRoute = RouteDetail().obs;
  var destinationRoute = RouteDetail().obs;
  var segmentDetail = Segment().obs;

  @override
  void onInit() {
    context = Get.context!;

    super.onInit();
  }

  void startForegroundTrackingService() async {
    BackgroundService().initializeService().then((value) {});
    BackgroundService().startService();
  }

  void stopForegroundService() {
    BackgroundService().stopService();
  }

  void getDriverRoute(String driverID) async {
    loginData.value = ApiResponse.loading();
    var res = await _appRepo.getRouteList(driverID);

    if (res is String) {
      loginData.value = ApiResponse.error(res);
    } else {
      loginData.value = ApiResponse.completed(res);
      res as List<SegmentDetail>;
      listRoutes.value.clear();
      listRoutes.value.addAll(res);
      /*if (res.waypoints != null) {
        listWayPoints.value.addAll(res.waypoints!);
      }
      if (res.from != null) {
        fromRoute.value = res.from!;
      }
      if (res.to != null) {
        destinationRoute.value = res.to!;
      }

      if (res.segment != null) {
        segmentDetail.value = res.segment!;
      }*/
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracking_app/Controller/LocationController.dart';
import 'package:tracking_app/Model/response/NotificationHistoryResponse.dart';

import '../Model/response/LoginResponse.dart';
import '../Model/response/RouteResponse.dart';
import '../NetworkAPI/app_repository.dart';
import '../NetworkAPI/response/api_response.dart';
import '../Utils/Controller.dart';
import 'BackgroundService.dart';

class NotificationController extends GetxController {
  late BuildContext context;

  final _appRepo = NetworkRepository();
  var loginData = ApiResponse.none().obs;

  Rx<List<NotificationHistory>> listNotification =
      Rx<List<NotificationHistory>>([]);

  String driverId = "";

  @override
  void onInit() {
    context = Get.context!;
    super.onInit();
  }

  @override
  void onReady() {
    getNotificationHistory();
    super.onReady();
  }

  void getNotificationHistory() async {
    // var driverID =  GetStorage().read(Controller.DRIVER_DETAIL);
    loginData.value = ApiResponse.loading();
    var res = await _appRepo.getNotificationHistory(driverId);

    if (res is String) {
      loginData.value = ApiResponse.error(res);
    } else {
      loginData.value = ApiResponse.completed(res);
      res as List<NotificationHistory>;
      listNotification.value.clear();
      listNotification.value.addAll(res);
    }
  }

  void markLocationCompleted(Map<String, String> request) async {
    loginData.value = ApiResponse.loading();
    var res = await _appRepo.markRouteComplete(request);
    if (res is String) {
      loginData.value = ApiResponse.error(res);
    } else {
      loginData.value = ApiResponse.completed(res);
    }
  }
}

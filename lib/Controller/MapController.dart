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
import '../NetworkAPI/response/status.dart';
import '../Utils/Controller.dart';
import 'BackgroundService.dart';

class MapController extends GetxController {
  late BuildContext context;

  final _appRepo = NetworkRepository();
  var loginData = ApiResponse.none().obs;
  var isMarkCompleted = false.obs;

  @override
  void onInit() {
    context = Get.context!;
    ever(loginData, (value) {
      value as ApiResponse;
      switch (value.status) {
        case Status.COMPLETED:
          Navigator.pop(context);
          isMarkCompleted.value = true;
          break;
        case Status.NONE:
          break;
        case Status.ERROR:
          Controller().showToastMessage(context, value.message.toString());
          Navigator.pop(context);
          break;
        case Status.LOADING:
          Controller().showProgressDialog(context);
          break;
      }
    });

    super.onInit();
  }

  void startForegroundTrackingService() async {
    BackgroundService().initializeService().then((value) {});
    BackgroundService().startService();
  }

  void stopForegroundService() {
    BackgroundService().stopService();
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

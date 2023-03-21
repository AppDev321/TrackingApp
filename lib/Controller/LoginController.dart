import 'package:get/state_manager.dart';

import '../Model/response/LoginResponse.dart';
import '../NetworkAPI/app_repository.dart';
import '../NetworkAPI/response/api_response.dart';

class LoginController extends GetxController {
  final _appRepo = NetworkRepository();
  var loginData = ApiResponse.none().obs;

  void loginDriver(Map<String, String> request) async {
    loginData.value = ApiResponse.loading();
    var res = await _appRepo.loginUser(request);
    if (res is String) {
      loginData.value = ApiResponse.error(res);
    } else {

      loginData.value = ApiResponse.completed(res);
    }
  }




}

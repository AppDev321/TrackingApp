import 'dart:convert';

import '../Model/response/GeneralResponse.dart';
import '../Model/response/LoginResponse.dart';
import 'api.dart';
import 'network/network_api_services.dart';

import '../utils/controller.dart';

class NetworkRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  void printException(title, e) {
    Controller().printLogs("$title Api Exception => $e");
  }

  Future<dynamic> loginUser(data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppURL.apiKey, data, true);

      var responseData = json.encode(response);
      final body = json.decode(responseData);
      GeneralResponse res = GeneralResponse.fromJson(body);
      if (res.code == 200) {
        return  LoginResponse.fromJson(res.data?.data);
      } else {
        return res.errors;
      }
    } catch (e) {
      printException("Login", e.toString());
      rethrow;
    }
  }
}

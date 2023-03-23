import 'dart:convert';

import 'package:tracking_app/Model/response/RouteResponse.dart';

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
      dynamic response = await _apiServices.getFormDataApiResponse(
          AppURL.loginUrl, data, true);

      var responseData = json.encode(response);
      final body = json.decode(responseData);

      if (body is String) {
        return body;
      } else {
        LoginResponse res = LoginResponse.fromJson(body);
        if(res.status == true) {
          return res.data;
        }
        else
          {
            return res.data!.errorMessage.toString();
          }
      }
    } catch (e) {
      printException("Login", e.toString());
      rethrow;
    }
  }

  Future<dynamic> getRouteList(String driverID) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppURL.routesUrl + driverID, true);

      var responseData = json.encode(response);
      final body = json.decode(responseData);
      if (body is String) {
        return body;
      } else {
        RouteResponse res = RouteResponse.fromJson(body);
        if(res.status == true) {
          return res.segments;
        }
        else
        {
          return <SegmentDetail>[];
        }
      }
    } catch (e) {
      printException("Login", e.toString());
      rethrow;
    }
  }


  Future<dynamic> updateLocation(data) async {
    try {
      dynamic response = await _apiServices.getFormDataApiResponse(
          AppURL.driverLocation, data, true);

      var responseData = json.encode(response);
      final body = json.decode(responseData);

      if (body is String) {
        return body;
      } else {
        LoginResponse res = LoginResponse.fromJson(body);
        if(res.status == true) {
          return res.data;
        }
        else
        {
          return res.data!.errorMessage.toString();
        }
      }
    } catch (e) {
      printException("Login", e.toString());
      rethrow;
    }
  }


}

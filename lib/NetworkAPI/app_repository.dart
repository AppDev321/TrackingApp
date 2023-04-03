import 'dart:convert';

import 'package:tracking_app/Model/response/NotificationHistoryResponse.dart';
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
        if (res.status == true) {
          return res.data;
        } else {
          return "Invalid Email/Password";
        }
      }
    } catch (e) {

      printException("Login", e.toString());
      return  e.toString();
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
        if (res.status == true) {
          return res.segments;
        } else {
          return <SegmentDetail>[];
        }
      }
    } catch (e) {
      printException("Route List", e.toString());
      return  e.toString();
      rethrow;
    }
  }

  Future<dynamic> getNotificationHistory(String driverID) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          AppURL.notificationHistory + driverID, true);

      var responseData = json.encode(response);
      final body = json.decode(responseData);
      if (body is String) {
        return body;
      } else {
        NotificationHistoryResponse res =
            NotificationHistoryResponse.fromJson(body);
        if (res.status == true) {
          return res.data!.notifications!.isEmpty
              ? <NotificationHistory>[]
              : res.data!.notifications!;
        } else {
          return <NotificationHistory>[];
        }
      }
    } catch (e) {
      printException("Notification", e.toString());
      return  e.toString();
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
        if (res.status == true) {
          return res.data;
        } else {
          return res.data!.errorMessage.toString();
        }
      }
    } catch (e) {
      printException("Location", e.toString());
      return  e.toString();
      rethrow;
    }
  }

  Future<dynamic> markRouteComplete(data) async {
    try {
      dynamic response = await _apiServices.getFormDataApiResponse(
          AppURL.markAddressCompleted, data, true);

      var responseData = json.encode(response);
      final body = json.decode(responseData);

      if (body is String) {
        return body;
      } else {
        LoginResponse res = LoginResponse.fromJson(body);
        if (res.status == true) {
          return res.data;
        } else {
          return res.data!.errorMessage.toString();
        }
      }
    } catch (e) {
      printException("mark update", e.toString());
      return  e.toString();
      rethrow;
    }
  }
}

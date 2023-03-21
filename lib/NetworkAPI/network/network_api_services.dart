import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../utils/controller.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  dynamic responseJson;

  @override
  Future getGetApiResponse(String url, bool printLog) async {
    if (printLog) {
      Controller().printLogs(url);
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Accept": "application/json",
          // "Content-Type": "application/json",
        },
      );

      if (printLog) Controller().printLogs(response.body);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }




  @override
  Future getFormDataApiResponse(String url, data, bool printlog) async {
    if (printlog) {
      Controller().printLogs(url);
    }

    try {
      final request = http.MultipartRequest(   'POST',  Uri.parse(url));
      request.fields.addAll(data);
      request.headers.addAll({
        "Access-Control-Allow-Origin": "*",
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });


     var response = await request.send();
     // var res = await response.stream.bytesToString();

      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);
     // print(responsed.body);
     // final responseData = json.decode(responsed.body);






     // res= jsonDecode(jsonEncode(res));
      if (printlog) Controller().printLogs(responsed.body);
      if (response.statusCode == 200) {

        responseJson = returnResponse(responsed);
      }
      else {

        responseJson = response.reasonPhrase;
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data, bool printLog) async {
    dynamic responseJson;
    data = json.encode(data);
    if (printLog) {
      Controller().printLogs(url);
      Controller().printLogs(data);
    }

    try {
      http.Response? response = await http
          .post(Uri.parse(url),
              headers: {
                "Access-Control-Allow-Origin": "*",
                "Accept": "application/json",
                //  "Content-Type": "application/json",

              },
              body: data)
          .timeout(const Duration(seconds: 60))
          .then((value) {
        return value;
      }).onError((error, stackTrace) {
        Controller().printLogs("<onError> $error\n<stackTrace> $stackTrace");
        throw FetchDataException('error in request please check logs');
      });
      if (printLog) {
        Controller().printLogs(response.body);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);

        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw BadRequestException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException(
            "Error occurred while communicating with server with status code ${response.statusCode}");
    }
  }
}

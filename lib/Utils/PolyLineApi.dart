import 'dart:convert';
import 'package:http/http.dart' as http;
class NetworkHelper{
  NetworkHelper({required this.startLng,required this.startLat,required this.endLng,required this.endLat});

  final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '<Your-Api-Key>';
  final String journeyMode = 'driving-car'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{

    var uri = Uri.parse("$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");
    http.Response response = await http.get(uri);
    print("$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);

    }
    else{
      print(response.statusCode);
    }
  }
}
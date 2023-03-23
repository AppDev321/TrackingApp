import 'dart:ffi';

class LoginResponse  {
  bool? status;
  Driver? data;

  LoginResponse({this.status, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Driver.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


class Driver {
  String? errorMessage;
  String? id;
  String? fullName;
  String? email;
  String? mobileNo;
  String? maxSpeed;
  Double? longitude;
  Double? latitude;

  Driver(
      {
        this.errorMessage,
        this.id,
        this.fullName,
        this.email,
        this.mobileNo,
        this.maxSpeed,
        this.longitude,
        this.latitude});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['DriverId'];
    fullName = json['FullName'];
    email = json['Email'];
    mobileNo = json['MobileNo'];
    maxSpeed = json['MaxSpeed'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
    errorMessage = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DriverId'] = this.id;
    data['FullName'] = this.fullName;
    data['Email'] = this.email;
    data['MobileNo'] = this.mobileNo;
    data['MaxSpeed'] = this.maxSpeed;
    data['Longitude'] = this.longitude;
    data['Latitude'] = this.latitude;
    data['message'] = this.errorMessage;
    return data;
  }
}
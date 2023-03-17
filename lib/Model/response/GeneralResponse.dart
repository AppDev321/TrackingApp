class Errors {
  Errors({
    this.message,
  });

  Errors.fromJson(dynamic json) {
    message = json['message'];
  }

  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }
}

class Data {
  dynamic data;

  Data({this.data});

  Data.fromJson(Map<String, dynamic> json) {
    // data = jsonDecode(json.toString());
    data = json;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data.toString();
    return map;
  }
}

class GeneralResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  GeneralResponse({this.code, this.message, this.data, this.errors});

  GeneralResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];

    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

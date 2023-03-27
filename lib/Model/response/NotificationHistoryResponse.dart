class NotificationHistoryResponse {
  bool? status;
  Data? data;

  NotificationHistoryResponse({this.status, this.data});

  NotificationHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<NotificationHistory>? notifications;

  Data({this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <NotificationHistory>[];
      json['notifications'].forEach((v) {
        notifications!.add(new NotificationHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationHistory {
  String? id;
  String? driverId;
  String? title;
  String? message;
  String? createdAt;
  String? updatedAt;

  NotificationHistory(
      {this.id,
        this.driverId,
        this.title,
        this.message,
        this.createdAt,
        this.updatedAt});

  NotificationHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    title = json['title'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_id'] = this.driverId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
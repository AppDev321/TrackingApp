import 'dart:convert';

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
  MessageNotification? message;
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
    message = MessageNotification.fromJson(jsonDecode(json['message']));
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


class MessageNotification {
  String? to;
  Notification? notification;
  String? priority;

  MessageNotification({this.to, this.notification, this.priority});

  MessageNotification.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    data['priority'] = this.priority;
    return data;
  }
}

class Notification {
  String? title;
  Body? body;
  String? sound;
  String? badge;

  Notification({this.title, this.body, this.sound, this.badge});

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    sound = json['sound'];
    badge = json['badge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    data['sound'] = this.sound;
    data['badge'] = this.badge;
    return data;
  }
}

class Body {
  String? type;
  String? message;

  Body({this.type, this.message});

  Body.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['message'] = this.message;
    return data;
  }
}
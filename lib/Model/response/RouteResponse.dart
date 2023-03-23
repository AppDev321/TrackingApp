import 'dart:ffi';

class RouteResponse {
  bool? status;
  List<SegmentDetail>? segments;

  RouteResponse({this.status, this.segments});

  RouteResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['segments'] != null) {
      segments = <SegmentDetail>[];
      json['segments'].forEach((v) {
        segments!.add(new SegmentDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.segments != null) {
      data['segments'] = this.segments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SegmentDetail {
  bool? status;
  Segment? segment;
  RouteDetail? from;
  RouteDetail? to;
  List<RouteDetail>? waypoints;

  SegmentDetail(
      {this.status, this.segment, this.from, this.to, this.waypoints});

  SegmentDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    segment =
    json['segment'] != null ? new Segment.fromJson(json['segment']) : null;
    from = json['from'] != null ? new RouteDetail.fromJson(json['from']) : null;
    to = json['to'] != null ? new RouteDetail.fromJson(json['to']) : null;
    if (json['waypoints'] != null) {
      waypoints = <RouteDetail>[];
      json['waypoints'].forEach((v) {
        waypoints!.add(new RouteDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.segment != null) {
      data['segment'] = this.segment!.toJson();
    }
    if (this.from != null) {
      data['from'] = this.from!.toJson();
    }
    if (this.to != null) {
      data['to'] = this.to!.toJson();
    }
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Segment {
  String? segmentId;
  String? segmentTitle;
  String? source;
  String? destination;
  String? driverId;
  String? assignedOn;
  String? expiryDate;
  String? isDeleted;
  String? userId;
  String? createdOn;

  Segment({this.segmentId,
    this.segmentTitle,
    this.source,
    this.destination,
    this.driverId,
    this.assignedOn,
    this.expiryDate,
    this.isDeleted,
    this.userId,
    this.createdOn});

  Segment.fromJson(Map<String, dynamic> json) {
    segmentId = json['SegmentId'];
    segmentTitle = json['SegmentTitle'];
    source = json['Source'];
    destination = json['Destination'];
    driverId = json['DriverId'];
    assignedOn = json['AssignedOn'];
    expiryDate = json['ExpiryDate'];
    isDeleted = json['isDeleted'];
    userId = json['UserId'];
    createdOn = json['CreatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SegmentId'] = this.segmentId;
    data['SegmentTitle'] = this.segmentTitle;
    data['Source'] = this.source;
    data['Destination'] = this.destination;
    data['DriverId'] = this.driverId;
    data['AssignedOn'] = this.assignedOn;
    data['ExpiryDate'] = this.expiryDate;
    data['isDeleted'] = this.isDeleted;
    data['UserId'] = this.userId;
    data['CreatedOn'] = this.createdOn;
    return data;
  }
}

class RouteDetail {
  String? addressId;
  String? segmentId;
  String? address;
  String? latitude;
  String? longitude;
  String? suburb;
  String? publications;
  String? notes;
  String? isCompleted;
  String? imgUploaded;
  String? completedOn;
  String? imgUploadedOn;

  RouteDetail({this.addressId,
    this.segmentId,
    this.address,
    this.latitude,
    this.longitude,
    this.suburb,
    this.publications,
    this.notes,
    this.isCompleted,
    this.imgUploaded,
    this.completedOn,
    this.imgUploadedOn});

  RouteDetail.fromJson(Map<String, dynamic> json) {
    addressId = json['AddressId'];
    segmentId = json['SegmentId'];
    address = json['Address'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    suburb = json['Suburb'];
    publications = json['Publications'];
    notes = json['Notes'];
    isCompleted = json['isCompleted'];
    imgUploaded = json['ImgUploaded'];
    completedOn = json['CompletedOn'];
    imgUploadedOn = json['ImgUploadedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AddressId'] = this.addressId;
    data['SegmentId'] = this.segmentId;
    data['Address'] = this.address;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['Suburb'] = this.suburb;
    data['Publications'] = this.publications;
    data['Notes'] = this.notes;
    data['isCompleted'] = this.isCompleted;
    data['ImgUploaded'] = this.imgUploaded;
    data['CompletedOn'] = this.completedOn;
    data['ImgUploadedOn'] = this.imgUploadedOn;
    return data;
  }
}

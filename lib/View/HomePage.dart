import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:tracking_app/CustomWidget/NameIconBadge.dart';
import 'package:tracking_app/Utils/Controller.dart';
import 'package:tracking_app/View/MapView.dart';
import 'package:tracking_app/View/NotificationPage.dart';

import '../Controller/FCMController.dart';
import '../Controller/HomeController.dart';
import '../Controller/LocationController.dart';
import '../Model/response/LoginResponse.dart';
import '../Model/response/RouteResponse.dart';
import '../NetworkAPI/response/status.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  final LocationController locationController = Get.put(LocationController());
  late Driver driverDetail;
  late StreamSubscription driverStreamListner;
  bool isDriverModeOnline = false;
  int notificationCount = 0;

  @override
  void initState() {
    driverDetail = Get.arguments[0][Controller.DRIVER_DETAIL];
    controller.driverId = driverDetail.id.toString();

    driverStreamListner =
        locationController.getDriverPosition.listen((position) {
      var map = Map<String, String>();
      map['latitude'] = position.latitude.toString();
      map['longitude'] = position.longitude.toString();
      map['driver_id'] = driverDetail.id.toString();
      locationController.updateDriverLocation(map);
    });

    var control = Get.find<FCMController>();
    control.notification.listen((notificationData) {
      setState(() {
        notificationCount = 1;
      });
      refreshData();
    });

    super.initState();
  }

  Future<void> refreshData() async {
    controller.getDriverRoute();
  }

  @override
  void dispose() {
    driverStreamListner.cancel();
    // locationController.onClose();

    Get.delete<LocationController>();
    Get.delete<HomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  //color: Color(0xFFD4E7FE),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFFD4E7FE),
                        Color(0xFFF0F0F0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.6, 0.3])),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 8,
                            )
                          ],
                        ),
                        child: NamedIcon(
                          onTap: () {
                            setState(() {
                              notificationCount = 0;
                            });
                            Get.to(NotificationPage(), arguments: [
                              {Controller.DRIVER_DETAIL: driverDetail}
                            ]);
                          },
                          notificationCount: notificationCount,
                          iconData: Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi,\n${driverDetail.fullName}",
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF343E87),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${driverDetail.email}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                top: 185,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: Get.size.height,
                    width: Get.size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildTitleRow("Driving Mode", 0),
                        Obx(() => SizedBox(
                            height: Get.size.height - 220,
                            child: controller.loginData.value.status ==
                                    Status.LOADING
                                ? SkeletonListView()
                                : controller.listRoutes.value.length > 0
                                    ? RefreshIndicator(
                                        onRefresh: refreshData,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: controller
                                              .listRoutes.value.length,
                                          itemBuilder: ((context, index) {
                                            var item = controller
                                                .listRoutes.value[index];

                                            return routeListItem(item);
                                          }),
                                        ),
                                      )
                                    : SizedBox(
                                        height: Get.size.width,
                                        child: Center(
                                            child: Text("No Route Found")),
                                      )))
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  Row buildTitleRow(String title, int number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0XFF343E87),
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: "", //" ($number)",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ]),
        ),
        Visibility(
          visible: false,
          child: Text(
            "See all",
            style: TextStyle(
                fontSize: 12,
                color: Color(0XFF3E3993),
                fontWeight: FontWeight.bold),
          ),
        ),
        SlidingSwitch(
          value: false,
          width: 120,
          onChanged: (bool isOnline) {
            isDriverModeOnline = isOnline;
            if (isDriverModeOnline) {
              //  controller.startForegroundTrackingService();
              locationController.getLocation();
            } else {
              // controller.stopForegroundService();
              locationController.onClose();
            }
          },
          height: 30,
          animationDuration: const Duration(milliseconds: 200),
          onTap: () {},
          onDoubleTap: () {},
          onSwipe: () {},
          textOff: "Offline",
          textOn: "Online",
          // iconOff: Icons.gps_off,
          // iconOn: Icons.gps_fixed_outlined,
          contentSize: 12,
          colorOn: Colors.green,
          colorOff: Colors.grey,
          background: const Color(0xffe4e5eb),
          buttonColor: const Color(0xfff7f5f7),
          inactiveColor: const Color(0xff636f7b),
        ),
      ],
    );
  }

  Widget routeListItem(SegmentDetail segmentDetail,{bool showBanner = false,Color bannerColor=Colors.redAccent,String bannerText="New"} ) {
    bool isAllRouteCompleted = true;
    for (RouteDetail waypoint  in segmentDetail.waypoints!)
      {
        //1 == completed , 0 == false
       if(waypoint.isCompleted.toString() =="0")
         {
           isAllRouteCompleted = false;
           break;
         }
      }

   if(!showBanner)
     {
       showBanner = isAllRouteCompleted;
       bannerText = isAllRouteCompleted?"Completed":"";
       bannerColor = isAllRouteCompleted?Colors.green.withOpacity(0.7):Colors.redAccent;
     }

    return Stack(children: <Widget>[
      Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: Get.size.width - 100,
                  child: Text(
                    segmentDetail.segment?.segmentTitle ?? "N/A",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w800),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                routeRow("", segmentDetail.from!, Colors.blue),
                segmentDetail.waypoints!.length > 0
                    ? Column(
                        children: [
                          for (RouteDetail waypoint
                              in segmentDetail.waypoints!) ...[
                            routeRow("", waypoint, Colors.red)
                          ],
                        ],
                      )
                    : Container(),
                routeRow("", segmentDetail.to!, Colors.red),
              ],
            )
          ],
        ),
      ),
      showBanner
          ? Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                    right: 20, top: 6, bottom: 6, left: 20),
                decoration: BoxDecoration(
                  color: bannerColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
                alignment: Alignment.center,
                child: Text(
                  bannerText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          : Container(),
    ]);
  }

  Widget routeRow(String path, RouteDetail routeDetail, Color colorIcon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (!isDriverModeOnline) {
            Controller().showToastMessage(
                context, "Please enable Driving Mode Online first");
            return Future.error("Driver mode off");
          }
          bool serviceEnabled;
          LocationPermission permission;
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            return Future.error('Location services are disabled.');
          }
          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              return Future.error('Location permissions are denied');
            }
          }
          if (permission == LocationPermission.deniedForever) {
            return Future.error(
                'Location permissions are permanently denied, we cannot request permissions.');
          }
          if (routeDetail.isCompleted == "0") {
            Get.to(() => MapView(
                  segmentDetail: routeDetail,
                  homeControler: controller,
                  dataUpdatedSuccessful: () {
                    refreshData();
                  },
                ));
          }
        },
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          routeDetail.isCompleted == "1" ? Colors.blue : null),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: routeDetail.isCompleted == "1"
                        ? Icon(
                            Icons.check,
                            size: 10.0,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            size: 15.0,
                            color: Colors.blue,
                          ),
                  ),
                ),
                /* Icon(
                  Icons.location_on,
                  color: colorIcon,
                  size: 20,
                ),*/
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: Get.size.width - 100,
                  child: RichText(
                    text: TextSpan(
                        text: "$path",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text:
                                "${routeDetail.address?.replaceAll("'", "") ?? "N/A"}",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                decoration: routeDetail.isCompleted == "1"
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: routeDetail.isCompleted == "1"
                                    ? Colors.grey.withOpacity(0.5)
                                    : Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.normal),
                          ),
                        ]),
                  ),
                ),
                /* routeDetail.isCompleted == "0"
                    ? Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.black,
                        size: 20,
                      )
                    : Container(),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  Future<bool?> showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => buildExitDialog(context),
    );
  }

  AlertDialog buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    );
  }
}

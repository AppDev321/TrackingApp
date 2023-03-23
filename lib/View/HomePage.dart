import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:tracking_app/CustomWidget/NameIconBadge.dart';
import 'package:tracking_app/Utils/Controller.dart';
import 'package:tracking_app/View/MapView.dart';
import 'package:tracking_app/View/NotificationPage.dart';
import '../Controller/HomeController.dart';
import '../Location/LocationController.dart';
import '../Model/response/LoginResponse.dart';
import '../Model/response/RouteResponse.dart';
import '../NetworkAPI/response/status.dart';
import 'GoogleMap.dart';

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

  @override
  void initState() {


    driverDetail = Get.arguments[0][Controller.DRIVER_DETAIL];
    controller.getDriverRoute(driverDetail.id.toString());


    driverStreamListner= locationController.getDriverPosition.listen((position) {
      var map = Map<String, String>();
      map['latitude'] = position.latitude.toString();
      map['longitude'] = position.longitude.toString();
      map['driver_id']=driverDetail.id.toString();
      locationController.updateDriverLocation(map);
    });

    super.initState();
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
    return Scaffold(
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
                          Get.to(() => NotificationPage());
                        },
                        notificationCount: 12,
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
                        height: Get.size.height-220,
                          child: controller.loginData.value.status ==
                                  Status.LOADING
                              ? SkeletonListView()
                              : controller.listRoutes.value.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.listRoutes.value.length,
                                      itemBuilder: ((context, index) {
                                        var item =
                                            controller.listRoutes.value[index];

                                        return routeListItem(item);
                                      }),
                                    )
                                  : SizedBox(
                                      height: Get.size.width,
                                      child:
                                          Center(child: Text("No Route Found")),
                                    )))
                    ],
                  )))
        ],
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
            if (isOnline) {
              locationController.getLocation();



            } else {
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

  Widget routeListItem(SegmentDetail segmentDetail) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GoogleMapView());//MapView(segmentDetail:segmentDetail));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFF9F9FB),
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
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                routeRow("Start Point",segmentDetail.from!, Colors.blue),
                SizedBox(
                  height: 10,
                ),
                routeRow("End Point",segmentDetail.to!, Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget routeRow(String path,RouteDetail routeDetail, Color colorIcon) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: colorIcon,
          size: 20,
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: Get.size.width - 100,
          child: RichText(
            text: TextSpan(
                text: "$path: ",
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
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                ]),
          ),
        )
      ],
    );
  }
}

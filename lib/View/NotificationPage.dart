import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:tracking_app/Model/response/NotificationHistoryResponse.dart';

import '../Controller/NotificationController.dart';
import '../NetworkAPI/response/status.dart';
import '../Utils/Controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {

    super.initState();

    var driverDetail = Get.arguments[0][Controller.DRIVER_DETAIL];
    controller.driverId = driverDetail.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
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
                InkWell(
                  onTap: () {

                    Get.back();
                  },
                  child: Container(
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
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notifications",
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
                    Obx(()=>Text(
                      "Total Notification: ${controller.listNotification.value.length}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                      ),
                    ),)

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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
             // borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Obx(() => SizedBox(
                    height: Get.size.height - 220,
                    child: controller.loginData.value.status == Status.LOADING
                        ? SkeletonListView()
                        : controller.listNotification.value.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.listNotification.value.length,
                                itemBuilder: ((context, index) {
                                  var item = controller.listNotification.value[index];
                                  return notificationListItem(item);
                                }),
                              )
                            : SizedBox(
                                height: Get.size.width,
                                child: Center(child: Text("No Notification Found")),
                              ))),
              ],
            )),
      )
    ]));
  }

  Widget notificationListItem(NotificationHistory item) {
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFF9F9FB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(Icons.notifications,color: Colors.grey,),
          SizedBox(width: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: Get.size.width - 100,
                child: Text(
                  item.title ?? "N/A",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height:2,
              ),
              Text(
                item.createdAt ?? "N/A",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 10, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                item.message ?? "N/A",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, color: Colors.black.withOpacity(0.7)),
              ),
            ],
          ),
        ]));
  }
}

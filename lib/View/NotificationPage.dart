import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:tracking_app/CustomWidget/NameIconBadge.dart';
import 'package:tracking_app/Utils/Controller.dart';
import 'package:tracking_app/View/MapView.dart';
import '../Controller/HomeController.dart';

//
class NotificationPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
 //   Get.lazyPut(() => HomeController());

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
                        Text(
                          "Unread Count:10",
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  child: true
                      ? SkeletonListView()
                      : Container(child: Center(child: Text("Content"))),
                )),
          )
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
                  color: Colors.black,
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
          onChanged: (bool value) {
            print(value);
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
          colorOn: const Color(0xffdc6c73),
          colorOff: const Color(0xff6682c0),
          background: const Color(0xffe4e5eb),
          buttonColor: const Color(0xfff7f5f7),
          inactiveColor: const Color(0xff636f7b),
        ),
      ],
    );
  }


}

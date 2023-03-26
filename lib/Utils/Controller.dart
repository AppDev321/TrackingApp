import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller {

  static const MAP_API_KEY = 'AIzaSyBuRkKGgS691VvKyAtGb84IMFeaAMAc25Q';
  /* static const MAP_API_KEY = 'AIzaSyCMKV0Yz1tY-tliMVuyd-rstHlvjt6WkGA';*/
  static const DRIVER_DETAIL="DRIVER-DATA";
  printLogs(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  void showToastMessage(BuildContext context, String text) {
    Get.snackbar('Alert', text,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black,
        colorText: Colors.white);
  }

  bool validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(value)) {
        return false;
      } else {
        return true;
      }
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Simple Alert"),
      content: const Text("This is an alert message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  String differenceFormattedString(int minute) {
    try {
      DateTime now = DateTime.now();

      Duration difference = Duration(minutes: minute);

      final today =
          DateTime(now.year).add(difference).subtract(const Duration(days: 1));

      //return '${today.day} Days ${today.hour} Hours ${today.minute} Min';

      if (today.hour > 0) {
        return '${today.hour}h, ${today.minute}min';
      } else {
        return '${today.minute}min';
      }
    } catch (e) {
      return '';
    }
  }
  void showProgressDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [

          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 20),child:Text("Please wait")),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);
}

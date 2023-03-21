import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tracking_app/Location/LocationController.dart';
import 'package:tracking_app/NetworkAPI/response/api_response.dart';
import 'package:tracking_app/View/HomePage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/LoginController.dart';
import '../CustomWidget/BouncingButton.dart';
import '../CustomWidget/ProgressDialog.dart';
import '../Model/response/LoginResponse.dart';
import '../NetworkAPI/response/status.dart';
import '../Utils/Controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  final LocationController locationController = Get.put(LocationController());

  // final FCMController fcmController = Get.put(FCMController());
  late ProgressDialogBuilder progressDialog;

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialogBuilder(context);
    progressDialog.initiateLDialog('Please wait..');

    ever(loginController.loginData, (loginData) {
      loginData as ApiResponse;
      switch (loginData.status) {
        case Status.COMPLETED:
          progressDialog.hideOpenDialog();
          var userDetail = loginData.data as Driver;
          Get.to(()=>HomePage(),arguments:  [
            {Controller.DRIVER_DETAIL: userDetail}

          ]);
          break;
        case Status.NONE:
        case Status.ERROR:
          progressDialog.hideOpenDialog();
          break;
        case Status.LOADING:
     //     progressDialog.showLoadingDialog();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                child: Text('Hello',
                    style:
                        TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                child: Text('There',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                  obscureText: true,
                ),
                SizedBox(height: 5.0),
                Visibility(
                  visible: false,
                  child: Container(
                    alignment: Alignment(1.0, 0.0),
                    padding: EdgeInsets.only(top: 15.0, left: 20.0),
                    child: InkWell(
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                    height: 40.0,
                    child: BouncingButton(
                        text: "LOGIN",
                        btnColor: Colors.green,
                        shadowColor: Colors.greenAccent,
                        callback: () {
                          var map = Map<String, String>();
                          map['username'] = 'faheemakbar18@gmail.com';
                          map['password'] = '12345678';
                          loginController.loginDriver(map);
                        })),
                SizedBox(height: 20.0),
                Obx(
                  () => Text(loginController.loginData.value.message ?? ""),
                ),
                SizedBox(height: 20.0),
              ],
            )),
        SizedBox(height: 15.0),
        Visibility(
          visible: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New to User ?',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}

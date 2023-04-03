import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_app/NetworkAPI/response/api_response.dart';

import '../Controller/BackgroundService.dart';
import '../Controller/FCMController.dart';
import '../Controller/LocationController.dart';
import '../Controller/LoginController.dart';
import '../CustomWidget/BouncingButton.dart';
import '../NetworkAPI/response/status.dart';
import '../Utils/Controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());

  final FCMController fcmController = Get.put(FCMController());


  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();



  @override
  void initState() {
    super.initState();

    BackgroundService().initializeService().then((value) {
      BackgroundService().startService();
    });


    ever(loginController.loginData, (loginData) {

      loginData as ApiResponse;
      switch (loginData.status) {
        case Status.COMPLETED:
          if(mounted) {
            Navigator.pop(context);
          }

          break;
        case Status.NONE:
          break;
        case Status.ERROR:
          if(mounted)
          Navigator.pop(context);
          break;
        case Status.LOADING:
          if(mounted)
          Controller().showProgressDialog(context);

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
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
                  controller: emailTextController,
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
                  controller: passwordTextController,
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
                          map['device_id'] = fcmController.fcmToken.value;

                        //  FocusScope.of(context).requestFocus(FocusNode());

                          if (kDebugMode) {
                            map['username'] = 'faheemakbar18@gmail.com';
                            map['password'] = '12345678';



                          //  loginController.loginDriver(map);
                          } else {
                            if (emailTextController.text.isEmpty) {
                              Controller().showToastMessage(context,"Please enter email");
                              return;
                            }

                            if (!RegExp(r'\S+@\S+\.\S+')
                                .hasMatch(emailTextController.text)) {
                              Controller().showToastMessage(context,"Enter valid Email address");
                              return;
                            }

                            if (passwordTextController.text.isEmpty) {
                              Controller().showToastMessage(context,"Please enter password");
                              return;
                            }

                            map['username'] =
                                emailTextController.text.toString();
                            map['password'] =
                                passwordTextController.text.toString();
                            loginController.loginDriver(map);
                        }


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

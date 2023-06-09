import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracking_app/Notification/PushNotifications.dart';

import '../Utils/Controller.dart';


class FCMController extends GetxController {

  var fcmToken = "".obs;
  var notification = RemoteMessage().obs;


  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    await GetStorage.init();
    PushNotifications().init();
    PushNotifications().token.listen((token) {
      fcmToken.value = token;
      Controller().printLogs("FCM Token received");
    });

    PushNotifications().notification.listen(( message) {
     var data =  message as RemoteMessage;
      notification.value = data;
     Controller().printLogs("FCM Notification Received from GetX controller");
    });


  }

  @override
  void onClose() {
    PushNotifications().dispose();
    super.onClose();
  }
  @override
  void dispose() {
    PushNotifications().dispose();
    super.dispose();
  }

}

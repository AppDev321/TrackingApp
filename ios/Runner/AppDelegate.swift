import UIKit
import Flutter
import GoogleMaps
import flutter_background_service_ios // add this

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "com.app.task.identifier"

    GMSServices.provideAPIKey("AIzaSyBuRkKGgS691VvKyAtGb84IMFeaAMAc25Q")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

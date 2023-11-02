import UIKit
import Flutter
import GoogleMaps

import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GMSServices.provideAPIKey("AIzaSyDT0kQqFx2InNi3bVKsmN0NhkbqyXhFK-Q");
      GeneratedPluginRegistrant.register(with: self);

      if #available(iOS 10.0, *){
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

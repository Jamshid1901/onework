import UIKit
import Flutter
import GoogleMaps
import YandexMapsMobile

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg")
     YMKMapKit.setApiKey("940492e5-a3ea-47ba-b45d-ab99dc4fe04b")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import Flutter
import UIKit
import GoogleMaps

@UIApplicationMain
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
       GMSServices.provideAPIKey("AIzaSyCdKApW08g0q5OrouYvrp512N0tSbV3mGQ")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

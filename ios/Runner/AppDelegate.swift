import UIKit
import Flutter
import Firebase
import Fabric
import Crashlytics
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    Fabric.with([Crashlytics.self])
    GMSServices.provideAPIKey("AIzaSyB7AKTsQNGds2fnkEjpPrV1W7sxiHi3pvE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

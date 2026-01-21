import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // Registrar implementación de la API de Pigeon
    let deviceInfoApi = DeviceInfoApiImpl()
    DeviceInfoApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: deviceInfoApi)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// Implementar la interfaz generada por Pigeon
class DeviceInfoApiImpl: DeviceInfoApi {
     func getDeviceModel() throws -> String {
         return UIDevice.current.model
     }
     
     func getOsVersion() throws -> String {
         return UIDevice.current.systemVersion
     }
     
     func getDeviceId() throws -> String {
         return UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
     }
 }
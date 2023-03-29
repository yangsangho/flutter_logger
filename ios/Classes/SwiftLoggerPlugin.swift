import Flutter
import UIKit

public class SwiftLoggerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "logger.dayugi.kr", binaryMessenger: registrar.messenger())
    let instance = SwiftLoggerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch(call.method) {
      case "logMsg":
        guard let msgList = call.arguments as? [String] else { return }
        for msg in msgList {
          NSLog("(flutter) %@", msg)
        }
        result(nil)
        break;
      default: 
        result(FlutterMethodNotImplemented)
    }
  }
}

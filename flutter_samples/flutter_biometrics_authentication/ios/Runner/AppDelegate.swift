import UIKit
import Flutter
import LocalAuthentication

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var biometricsChannel: FlutterMethodChannel?;
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Get the root controller for the Flutter view.
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // Setup a channel to recieve calls from Flutter.
        biometricsChannel = FlutterMethodChannel(name: "samples.invertase.io/biometrics",
                                                 binaryMessenger: controller.binaryMessenger)
        
        // Set a method handler that is triggered by any call on `samples.invertase.io/biometrics` channel
        biometricsChannel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // This method is invoked on the UI thread.
            // Handle calls to biometrics channel.
            guard call.method == "authenticateWithBiometrics" else {
                // If the requested method is not `authenticate`, throw.
                result(FlutterMethodNotImplemented)
                return
            }
            
            self.callLocalAuthentication(result: result)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func callLocalAuthentication(result: @escaping FlutterResult) -> Void  {
        let context = LAContext()
        
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = "Use Password"
        }
        
        var error: NSError?
        
        // Check for biometric authentication permissions
        let permissions = context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: &error
        )
        
        if permissions {
            let reason = "Log in with Face ID"
            context.evaluatePolicy(
                // .deviceOwnerAuthentication allows biometric or passcode authentication
                .deviceOwnerAuthentication,
                localizedReason: reason
            ) { success, error in
                // Send the authentication result to Flutter, either true or false.
                result(nil)
                self.biometricsChannel?.invokeMethod("authenticationResult", arguments: success)
            }
        } else {
            // If the biometrics permissions failed, throw a PlatformException to Flutter.
            let platformError = FlutterError(code: "AUTHFAILED",
                                             message: "\(error?.localizedDescription ?? "The authentication process has failed for an unknown reason").",
                                             details: nil)
            result(platformError)
        }
        
        return
    }
}

import Flutter
import UIKit
import MoEngageSDK


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      UNUserNotificationCenter.current().delegate = self;
      initializeMoEngage();
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func initializeMoEngage() {
        let sdkConfig = MoEngageSDKConfig(appId: "Q83YHT7HD3405NZ65BEM8LHO", dataCenter : MoEngageDataCenter.data_center_03)

  #if DEBUG
         sdkConfig.enableLogs = true
         MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
  #else
         MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
  #endif
        
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: self)
        
    }

    //Remote notification Registration callback methods
override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  //Call only if MoEngageAppDelegateProxyEnabled is NO
  MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
}

   override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
  //Call only if MoEngageAppDelegateProxyEnabled is NO
  MoEngageSDKMessaging.sharedInstance.didFailToRegisterForPush()
}

@available(iOS 10.0, *)
override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
withCompletionHandler completionHandler: @escaping () -> Void) {
    
    //Call only if MoEngageAppDelegateProxyEnabled is NO
    MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
    
    //Custom Handling of notification if Any
    let pushDictionary = response.notification.request.content.userInfo
    
    completionHandler();
}

    @available(iOS 10.0, *)
override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //This is to only to display Alert and enable notification sound
    completionHandler([.sound,.alert])
}

// MARK:- Remote notification received callback method for iOS versions below iOS10
override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    //Call only if MoEngageAppDelegateProxyEnabled is NO
    MoEngageSDKMessaging.sharedInstance.didReceieveNotification(inApplication: application, withInfo: userInfo)
}
}

import UIKit
import Flutter
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    Messaging.messaging().delegate = self
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

          // With swizzling disabled you must let Messaging know about the message, for Analytics
           Messaging.messaging().appDidReceiveMessage(userInfo)

          // Print message ID.
        print("Firebase1")
        
        let alert = UIAlertController(title: notification.request.content.title, message: notification.request.content.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


        }}))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
       
    }
    
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
         Messaging.messaging().appDidReceiveMessage(userInfo)
        print("Firebase2")

        
        let alert = UIAlertController(title: response.notification.request.content.title, message: response.notification.request.content.body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


        }}))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
       
    }
    
  
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        print("APP_ENTER_IN_FOREGROUND")
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("Firebase3")

        
//
//        let alert = UIAlertController(title: notification.request.content.title, message: notification.request.content.body, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
//              switch action.style{
//              case .default:
//                    print("default")
//
//              case .cancel:
//                    print("cancel")
//
//              case .destructive:
//                    print("destructive")
//
//
//        }}))
//        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE_TOKEN_DATA :: \(deviceToken.description)") // (SWIFT = 3) : TOKEN PARSING
        Messaging.messaging().apnsToken = deviceToken
        
        print("Firebase4")

        
//
//                let alert = UIAlertController(title: notification.request.content.title, message: notification.request.content.body, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
//                      switch action.style{
//                      case .default:
//                            print("default")
//
//                      case .cancel:
//                            print("cancel")
//
//                      case .destructive:
//                            print("destructive")
//
//
//                }}))
//                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

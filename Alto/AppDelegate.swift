//
//  AppDelegate.swift
//  Alto
//
//  Created by Jaypreet on 21/10/21.
//

import UIKit
import IQKeyboardManagerSwift
import PushKit
import CallKit
import OpenTok
import Stripe

var c_uuid = NSUUID()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    let callManager = SpeakerboxCallManager()
    var providerDelegate: ProviderDelegate?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        providerDelegate = ProviderDelegate(callManager: callManager)
        RegisterRemoteNotification(application: application)
       
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        SetNavigation()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func SetNavigation()  {
           
           UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .selected)
           UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.03786076605, green: 0.2756649256, blue: 0.447594285, alpha: 1)], for: .normal)
        UISegmentedControl.appearance().selectedSegmentTintColor = #colorLiteral(red: 0.03786076605, green: 0.2756649256, blue: 0.447594285, alpha: 1)
       
           UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.03786076605, green: 0.2756649256, blue: 0.447594285, alpha: 1)
           UINavigationBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
           UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
           UINavigationBar.appearance().isTranslucent = false
           
           
           
   //        UINavigationBar.appearance().shadowImage = #imageLiteral(resourceName: "ic_check_selected")
           
           
           UINavigationBar.appearance().layer.shadowColor = UIColor.black.cgColor
           UINavigationBar.appearance().layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
           UINavigationBar.appearance().layer.shadowRadius = 4.0
           UINavigationBar.appearance().layer.shadowOpacity = 1.0
           UINavigationBar.appearance().layer.masksToBounds = false
           
           UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
           
           UINavigationBar.appearance().barStyle = .default
           
       }


}

extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("\(#function) voip token: \(credentials.token)")
        
        let deviceToken = credentials.token.reduce("", {$0 + String(format: "%02X", $1) })
        print("\(#function) token is: \(deviceToken)")
        DataManager.Push_device_token = deviceToken
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        
        print("\(#function) incoming voip notfication: \(payload.dictionaryPayload)")
        let aps = payload.dictionaryPayload["aps"] as! [String : Any]
        if let opentoktoken = aps["opentoktoken"] as? String,
           let sessionid =  aps["sessionid"] as? String,
            let uuid = UUID(uuidString: opentoktoken) {
            let name = aps["name"] as? String ?? ""
            let request_id = aps["request_id"] as? String ?? ""

            OTAudioDeviceManager.setAudioDevice(OTDefaultAudioDevice.sharedInstance())
                
            // display incoming call UI when receiving incoming voip notification
            let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            self.displayIncomingCall(uuid: uuid as UUID, name: name, request_id: request_id, opentoktoken : opentoktoken, sessionid: sessionid, hasVideo: true) { _ in
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
        }
        
    }
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("\(#function) incoming voip notfication: \(payload.dictionaryPayload)")
        let aps = payload.dictionaryPayload["aps"] as! [String : Any]
        if let opentoktoken = aps["opentoktoken"] as? String,
           let sessionid =  aps["sessionid"] as? String
            {
            let name = aps["name"] as? String ?? ""
            let request_id = aps["request_id"] as? String ?? ""

            OTAudioDeviceManager.setAudioDevice(OTDefaultAudioDevice.sharedInstance())
                
            // display incoming call UI when receiving incoming voip notification
            let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            self.displayIncomingCall(uuid: c_uuid as UUID, name: name, request_id: request_id, opentoktoken : opentoktoken, sessionid: sessionid, hasVideo: true) { _ in
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
        }
        completion()
    }
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("\(#function) token invalidated")
    }

    /// Display the incoming call to the user
    func displayIncomingCall(uuid: UUID , name : String , request_id : String , opentoktoken : String, sessionid: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
        providerDelegate?.reportIncomingCall(uuid: uuid, name: name , request_id : request_id, token: opentoktoken, sessionID: sessionid, hasVideo: true, completion: completion)
        
        
        
    }
    func EndIncomingCall()  {
        providerDelegate?.EndCall()
    }
    func OutGoingCall()  {
        providerDelegate?.OutGoingCall()

    }
    
}
extension AppDelegate : UNUserNotificationCenterDelegate {
    func RegisterRemoteNotification(application : UIApplication)  {
        let content = UNMutableNotificationContent() // notification content object
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notification.wav"))
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
            
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10, *) {
           UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ granted, error in }
        } else {
           application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        application.registerForRemoteNotifications()
                
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        voipRegistry.delegate = self;
        
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for notifications!")
              let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
                  print(deviceTokenString)
        
                  DataManager.device_token = deviceTokenString
        
                  if #available(iOS 10.0, *) {
                      UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
        
                          switch setttings.soundSetting{
                          case .enabled:
                              print("enabled sound setting")
                          case .disabled:
                              print("setting has been disabled")
                          case .notSupported:
                              print("something vital went wrong here")
                          }
                      }
                  } else {
                      // Fallback on earlier versions
        
        
                  }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
      
    


    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        let aps = response.notification.request.content.userInfo as! [String : Any]
        RemoteNotification(aps: aps)
        
    }
    func RemoteNotification(aps : [String : Any]) {
        if DataManager.CurrentUserData != nil{
            NotificationCenter.default.post(name: NSNotification.Name.init("NotificationgetNoti"), object: [:])

            if aps["type"] is String {
//                if  aps["type"] as! String == "4" {
//                     let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoCallViewController")  as! VideoCallViewController
//                    vc.isIncoming = true
//                    if aps["request_id"] is Int {
//                        vc.Request_id = aps["request_id"] as! Int
//                    }
//                    if aps["request_id"] is String {
//                        vc.Request_id = Int(aps["request_id"] as! String) ?? 0
//                    }
//                    if aps["opentoktoken"] is String {
//                        vc.kToken = aps["opentoktoken"] as! String
//                    }
//                    if aps["sessionid"] is String {
//                        vc.kSessionId = aps["sessionid"] as! String
//                    }
//                    let navi = UINavigationController.init(rootViewController: vc)
//                    navi.isNavigationBarHidden = true
//                    navi.modalPresentationStyle = .overCurrentContext
//                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
//                        while let presentedViewController = topController.presentedViewController {
//                            topController = presentedViewController
//                        }
//                        topController.present(navi, animated: false)
//                    }
//                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        let aps = userInfo as! [String : Any]
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {


        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
        NotificationCenter.default.post(name: NSNotification.Name.init("NotificationgetNoti"), object: [:])
        let aps = notification.request.content.userInfo as! [String : Any]

        RemoteNotification(aps: aps)

        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let message = userInfo as NSDictionary
        print(message)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationReloadScreen"), object: [:])
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a Stripe url – handle the URL normally as you would
        }
        return false
    }

    // This method handles opening universal link URLs (for example, "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool  {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = StripeAPI.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a Stripe url – handle the URL normally as you would
                }
            }
        }
        return false
    }
}

//
//  AppDelegate.swift
//  PushNotificationAppleDMT
//
//  Created by Buzoianu Stefan on 06/08/2018.
//  Copyright © 2018 Buzoianu Stefan. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications

/*
[
AnyHashable("google.c.a.c_l"): test de mesaj - 16:36,
AnyHashable("location"): galati,
AnyHashable("skills"): ios developer,
AnyHashable("name"): buzoianu stefan,
AnyHashable("google.c.a.e"): 1,
AnyHashable("google.c.a.ts"): 1533735433,
AnyHashable("google.c.a.udt"): 0,
AnyHashable("gcm.notification.sound2"): default,
AnyHashable("gcm.n.e"): 1,
AnyHashable("google.c.a.c_id"): 6557527348334929623,
AnyHashable("gcm.message_id"): 0:1533735433406283%a777beb4a777beb4,
 AnyHashable("aps"): {
    alert = "Oferta ta pentru zugraveala este luata!";
    badge = 0;
    sound = default;
 }
]
*/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var instanceIDTokenMessage: String?
    let gcmMessageIDKey = "gcm.message_id"
    let name = "name"
    let location = "location"
    let message = "google.c.a.c_l"
    let aps = "aps"
    let receivedNotification = Notification.Name(rawValue:"NotificationReceived")

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound] ) { (isGranted, error) in
            if error != nil {
                print("Eroare aparuta la autorizare!")
            } else {
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                DispatchQueue.main.async(execute: {
                    application.registerForRemoteNotifications()
                })

            }
            
        }
        FirebaseApp.configure()

        return true
    }

    func connectToFirebase() {
            Messaging.messaging().shouldEstablishDirectChannel = true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        connectToFirebase()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

extension AppDelegate {
   
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if(application.applicationState == UIApplicationState.inactive)
        {
            print("Inactive")
            //Show the view with the content of the push
            completionHandler(.newData)
            
        }else if (application.applicationState == UIApplicationState.background){
            
            print("Background")
            //Refresh the local model
            completionHandler(.newData)
            
        }else{
            
            print("Active")
            //Show an in-app banner
            completionHandler(.newData)
        }
        
        
        if let messageID = userInfo[gcmMessageIDKey],
            let name = userInfo[name],
            let location = userInfo[location],
            let message = userInfo[message]{
            print("Message ID  : \(messageID)")
            print("Message name : \(name)")
            print("Message location : \(location)")
            print("Message  : \(message)")
            
        }
        if let aps = userInfo[aps] {
            print("Message aps  : \(aps)")

        }
        
        print("userInfo = \(userInfo)")
        
        NotificationCenter.default.post(name: receivedNotification, object: nil)
        
    }
    
}


extension AppDelegate:MessagingDelegate {
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("nu avem token!!!")
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print(" --- Remote instance ID token: \(result.token) --- ")
                self.instanceIDTokenMessage  = "Remote InstanceID token: \(result.token)"
            }
        }
        connectToFirebase()
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}


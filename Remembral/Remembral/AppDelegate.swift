//
//  AppDelegate.swift
//  Remembral
//
//Team: Group 2
//  Created by Aayush Malhotra on 9/21/18.
//  Edited: Aayush Malhotra, Alwin Leong, Laurent Gracia
//
//  Set notification settings
//  Known bugs:
//
//

import UIKit
import FirebaseCore
import FirebaseAuth
import UserNotifications
import MessageUI
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MFMessageComposeViewControllerDelegate {
    
    // Set up message compose view controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    

    var window: UIWindow?

    // Handle the notifications on the user's phone. By default should chime and pop up on the screen.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }///will bring user to the reminder view controller of the app
    
    // Handle the notifications on the user's phone. Two options for a notification. Either done or snooze for 5 min.
    // Options should appear after pulling down the notification for options to deal with it.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if (response.actionIdentifier == UNNotificationDismissActionIdentifier){
            let firebaseKey = response.notification.request.content.userInfo["Key"] as! String
            let uid = Auth.auth().currentUser?.uid
            let reminderRef = FirebaseDatabase.sharedInstance.reminderRef.child(uid!).child(firebaseKey)
            let date = response.notification.date.timeIntervalSince1970
            reminderRef.updateChildValues(["status":false, "date": date])
        }
        else if response.actionIdentifier == choices.answer1.identifier{
            let date = response.notification.date.addingTimeInterval(5.0 * 60.0)
            let firebaseKey = response.notification.request.content.userInfo["Key"] as! String
            
            let content = UNMutableNotificationContent()
            ///should be puled from one of the list arrays list[indexPath.row]
            content.title = response.notification.request.content.title
            content.categoryIdentifier = "ReminderNotif"
            content.body = response.notification.request.content.body///should be puled from one of the list arrays
            content.userInfo = ["Key": firebaseKey]
            let calendar = Calendar.current
            content.sound = UNNotificationSound.default
            let dateComponents = calendar.dateComponents(
                [.hour, .minute, .second],
                from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            var id = firebaseKey
            id.append("Snooze")
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
        else if response.actionIdentifier == choices.answer2.identifier {
            let firebaseKey = response.notification.request.content.userInfo["Key"] as! String
            let uid = Auth.auth().currentUser?.uid
            let reminderRef = FirebaseDatabase.sharedInstance.reminderRef.child(uid!).child(firebaseKey)
            let date = response.notification.date.timeIntervalSince1970
            reminderRef.updateChildValues(["status":true, "date": date])
        }
    }

    // Override point for customization after application launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self//when this is un-commented notifications pop up properly
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("granted: (\(granted)")
        }
        GMSServices.provideAPIKey("AIzaSyAdyfrWJKWzTOmriYBxyelkiNsdy8dIG6k")
        FirebaseApp.configure()
        try! Auth.auth().signOut()
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if let user = user {
                print("User is signed in with uid:", user.uid)
            } else {
                print("No user is signed in.")
            }
        }

        let category = UNNotificationCategory(identifier: "ReminderNotif", actions: [choices.answer1, choices.answer2], intentIdentifiers: [], options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

     // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

     // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


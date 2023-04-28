//
//  WhoKnowsBetterApp.swift
//  WhoKnowsBetter
//
//  Created by Guren Icim on 1.03.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import UserNotifications
import FirebaseMessaging


class AppDelegate: NSObject, UIApplicationDelegate {
    @ObservedObject var isQuizReceived: QuizBooleanDelegateSwitch = QuizBooleanDelegateSwitch.shared
    @ObservedObject var quiz: Quiz = Quiz.shared
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .sound]])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let defaults = UserDefaults.standard
        let receivedNotif = response.notification.request.content.userInfo
        #if !targetEnvironment(simulator)
        if receivedNotif["type"] as! String == "QUIZ" {
            let dict = receivedNotif as! Dictionary<String,Any>
            quiz.setQuestionArray(qDict: dict)
            defaults.set(true, forKey: "isNewQuizReceived")
            isQuizReceived.isTodaysQuizReceived = true
        }
        #else
        if let dict = receivedNotif["aps"] as? Dictionary<String,Any> {
            if let dict2 = dict["data"] as? Dictionary<String,Any> {
                if dict2["type"] as? String == "QUIZ" {
                    defaults.set(true, forKey: "isNewQuizReceived")
                    isQuizReceived.isTodaysQuizReceived = true
                }
            }
        }
        #endif
        var options = JSONSerialization.WritingOptions()
        options.insert(.sortedKeys)
        options.insert(.prettyPrinted)
        let jsonData = (try? JSONSerialization.data(withJSONObject: receivedNotif, options: options))!
        let jsonString = String(data: jsonData, encoding: .utf8)
        Messaging.messaging().appDidReceiveMessage(receivedNotif)
        print(jsonString!)
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

@main
struct WhoKnowsBetterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
    }
}

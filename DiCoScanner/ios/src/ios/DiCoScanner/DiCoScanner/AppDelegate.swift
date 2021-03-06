//
//  AppDelegate.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit
import os

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = TabBarViewController()
        self.window!.makeKeyAndVisible()

        registerForPushNotifications()

        SymptomGetRequest().send { result in
            if (result) {
                let all = SymptomDao().findAll()
                let count = all?.count ?? 0
                os_log("Fetched Symptoms count: %d", count)
            }
        }

        return true
    }

    func registerForPushNotifications() {
        #if targetEnvironment(simulator)
        return
        #endif

        let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let pushConfiguration = LDPPushConfiguration.init(
                license: "c0f3c0ab491eae494ef9acd3b73b5aef5caba6f58e6dff99bcadb2b838b44694523c885ee356c2a06adb1b8475065545592aed9f0cc1849ed42b0d47e3bf7478",
                libraryPath: libraryDirectory)

        #if DEBUG
        pushConfiguration?.setSandboxMode(true)
        #endif

        pushConfiguration?.setBaseUrlWith("https://letspush.com/")
        pushConfiguration?.setRestApiKeyWith("011c7b977916e2b7e77d35dce8518f6e6f6c413470c7d6c7b94467ff7457635f")
        LDPPush.sharedInstance()?.setup(withPushConfig: pushConfiguration)

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
            if error == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })

        if LDPPush.sharedInstance().isSuccessfullyRegistered() {
            LDPPushRegistration.sharedInstance().registerAtBackend()
            LDPPush.sharedInstance().handleAppOpening()
        }
    }

    func getPushId(willPresent notification: UNNotification) -> NSNumber? {
        var pushID: NSNumber?

        if let userInfo = notification.request.content.userInfo as? [String: AnyObject] {
            if (userInfo[LDPPush.keyForPushID()] is String) {
                pushID = NSNumber(value: (userInfo[LDPPush.keyForPushID()] as? NSNumber)?.intValue ?? 0)
            } else {
                pushID = userInfo[LDPPush.keyForPushID()] as? NSNumber
            }
        }
        return pushID
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LDPPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        LDPPushRegistration.sharedInstance().registerAtBackend()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        LDPPushRegistration.sharedInstance().didReceiveRemoteNotification(getPushId(willPresent: notification),
                with: UIApplication.shared.applicationState)
        checkForNavigation(notification: notification)
        completionHandler([.badge, .sound, .alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        LDPPushRegistration.sharedInstance().didReceiveRemoteNotification(getPushId(willPresent: response.notification),
                with: UIApplication.shared.applicationState)
        checkForNavigation(notification: response.notification)
        completionHandler()
    }


    func checkForNavigation(notification: UNNotification) {
        var action: String? = nil
        if let userInfo = notification.request.content.userInfo as? [String: AnyObject] {
            action = userInfo["ldpush_action"] as? String
        }

        if let action = action {
            switch (action) {
            case "testDetected":
                navigateToCoronaTest()
            case "dailySymptomsReminder":
                navigateToSymptomTest()
            default:
                os_log("Received unknown action in push, do no navigation: %@", action)
            }
        }
    }

    func navigateToSymptomTest() {
        let symptomsVC = prepareForDeeplink()
        symptomsVC?.startSymptomsTest()
    }

    func navigateToCoronaTest() {
        let symptomsVC = prepareForDeeplink()
        symptomsVC?.startCoronaTest()
    }

    func prepareForDeeplink() -> SymptomsViewController? {
        if (self.window!.rootViewController!.isKind(of: TabBarViewController.self)) {
            let rootViewController = self.window!.rootViewController as! TabBarViewController
            
            if (rootViewController.selectedViewController?.presentedViewController != nil) {
                rootViewController.selectedViewController!.presentedViewController!.dismiss(animated: false, completion: nil)
            }

            let navigationController = rootViewController.selectedViewController as! UINavigationController
            if (!navigationController.viewControllers[0].isKind(of: SymptomsViewController.self)) {
                rootViewController.selectedIndex = 1
            }

            return (rootViewController.selectedViewController as! UINavigationController).viewControllers[0] as! SymptomsViewController
        }

        return nil
    }
}


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
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = TabBarViewController()
        self.window!.makeKeyAndVisible()

        // TODO remove
        os_log("Found number of symptoms: %i", SymptomDao().countAll())
        return true
    }


}


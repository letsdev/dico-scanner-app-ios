//
//  TabBarViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor(named: "AppTabBarTint")

        let markerNavigationController = UINavigationController(rootViewController: MarkerViewController())
        let markerVC = markerNavigationController
        markerNavigationController.tabBarItem.selectedImage = UIImage(named: "ic_tabbar_position_active")
        markerNavigationController.tabBarItem.image = UIImage(named: "ic_tabbar_position_normal")
        markerNavigationController.tabBarItem.title = "Markierungen"

        let symptomsNavigationController = UINavigationController(rootViewController: SymptomsViewController())
        let symptomsVC = symptomsNavigationController
        symptomsNavigationController.tabBarItem.selectedImage = UIImage(named: "ic_tabbar_symptoms_active")
        symptomsNavigationController.tabBarItem.image = UIImage(named: "ic_tabbar_symptoms_normal")
        symptomsNavigationController.tabBarItem.title = "Symptome"

        self.viewControllers = [markerVC, symptomsVC]
    }
}

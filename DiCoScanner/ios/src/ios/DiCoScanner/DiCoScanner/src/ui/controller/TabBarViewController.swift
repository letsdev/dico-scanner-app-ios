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

        let markerVC = UINavigationController(rootViewController: MarkerViewController())
        let symptomsVC = UINavigationController(rootViewController: SymptomsViewController())
        self.viewControllers = [markerVC, symptomsVC]
    }
}

//
//  TabBarViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let userDefaultsSkipOnboardingKey = "skipOnboarding"

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

        let appInfoNavigationController = UINavigationController(rootViewController: AppInfoViewController())
        let appInfoVC = appInfoNavigationController
        appInfoNavigationController.tabBarItem.selectedImage = UIImage(named: "ic_tabbar_info_active")
        appInfoNavigationController.tabBarItem.image = UIImage(named: "ic_tabbar_info_normal")
        appInfoNavigationController.tabBarItem.title = "App-Info"

        self.viewControllers = [markerVC, symptomsVC, appInfoVC]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !UserDefaults.standard.bool(forKey: userDefaultsSkipOnboardingKey) {
            showOnboarding()
        }
    }

    private func showOnboarding() {
        let object = OnboardingViewController()

        object.delegate = self
        self.present(object, animated: true)
    }
}

extension TabBarViewController: OnBoardingDelegate {

    func didClickContinue(_ viewController: UIViewController) {
        viewController.dismiss(animated: true)

        UserDefaults.standard.set(true, forKey: userDefaultsSkipOnboardingKey)
    }
}

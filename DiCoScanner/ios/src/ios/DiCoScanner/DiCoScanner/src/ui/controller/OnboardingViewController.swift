//
//  OnboardingViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 22.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    var delegate: OnBoardingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTouchUpInsideContinue(_ sender: Any) {
        delegate?.didClickContinue(self)
    }

}

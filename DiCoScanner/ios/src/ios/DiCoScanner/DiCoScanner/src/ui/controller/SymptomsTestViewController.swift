//
//  SymptomsTestViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class SymptomsTestViewController: UIViewController {
    public var symptomsTestDelegate: PresentedViewControllerDelegate

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,
         symptomsTestDelegate: PresentedViewControllerDelegate) {
        self.symptomsTestDelegate = symptomsTestDelegate

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Frage 1 von 13"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self,
                action: #selector(cancelTest))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .plain, target: self,
                action: #selector(finishSymptomsTest))
        self.navigationItem.rightBarButtonItem!.isEnabled = false
    }

    @objc func finishSymptomsTest() {
        self.symptomsTestDelegate.didEndPresentation(presentedViewController: self)

        self.dismiss(animated: true, completion: nil)
    }

    @objc func cancelTest() {
        self.dismiss(animated: true, completion: nil)
    }
}

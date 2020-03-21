//
//  CoronaTestViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class CoronaTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SARS-CoV-2-Schnelltest"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(finishCoronaTest))
    }

    @objc func finishCoronaTest() {
        self.dismiss(animated: true, completion: nil)
    }
}

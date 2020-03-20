//
//  SymptomsViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController {
    @IBOutlet var coronaTestResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        

    }

    func setupCoronaTestResults() {
        coronaTestResultLabel.text = "Ausstehend"
        coronaTestResultLabel.textColor = UIColor(named: "AppOrange")
    }
}

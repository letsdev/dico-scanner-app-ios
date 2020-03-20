//
//  MarkerViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class MarkerViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var humanContactLabel: UILabel!
    @IBOutlet weak var humanContactSwitch: UISwitch!
    
    @IBOutlet weak var crowdLabel: UILabel!
    @IBOutlet weak var crowdSwitch: UISwitch!
    
    @IBOutlet weak var touchedFaceLabel: UILabel!
    @IBOutlet weak var touchedFaceSwitch: UISwitch!
    
    @IBOutlet weak var sickContactLabel: UILabel!
    @IBOutlet weak var sickContactSwitch: UISwitch!
    
    @IBOutlet weak var markButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func markButtonTapped(_ sender: Any) {
        let humanContact = humanContactSwitch.isOn
        let crowdContact = crowdSwitch.isOn
        let touchedFace = touchedFaceSwitch.isOn
        let sickContact = sickContactSwitch.isOn
    }
}

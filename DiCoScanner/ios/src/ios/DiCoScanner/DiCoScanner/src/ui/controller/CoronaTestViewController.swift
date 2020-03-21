//
//  CoronaTestViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class CoronaTestViewController: UIViewController {
    @IBOutlet var coronaTestPositiveResultSwitch: UISwitch!
    @IBOutlet var coronaTestPendingResultSwitch: UISwitch!
    @IBOutlet var coronaTestNegativeResultSwitch: UISwitch!
    @IBOutlet var coronaTestDateTextField: UITextField!
    let coronaTestDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SARS-CoV-2-Schnelltest"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(finishCoronaTest))

        setupTestResults()
        setupTestDate()
    }
    
    private func setupTestDate() {
        coronaTestDatePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let selectedDateButton = UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(selectedDate));
        
        toolbar.setItems([spaceButton, selectedDateButton], animated: false)

        coronaTestDateTextField.inputAccessoryView = toolbar
        coronaTestDateTextField.inputView = coronaTestDatePicker
    }
    
    @objc private func selectedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        coronaTestDateTextField.text = formatter.string(from: coronaTestDatePicker.date)
        self.view.endEditing(true)
    }

    private func setupTestResults() {
        coronaTestPositiveResultSwitch.setOn(false, animated: false)
        coronaTestPositiveResultSwitch.addTarget(self, action: Selector(("coronaTestPositiveResultSwitchChanged")), for: UIControl.Event.valueChanged)

        coronaTestNegativeResultSwitch.setOn(false, animated: false)
        coronaTestNegativeResultSwitch.addTarget(self, action: Selector(("coronaTestNegativeResultSwitchChanged")), for: UIControl.Event.valueChanged)

        coronaTestPendingResultSwitch.setOn(false, animated: false)
        coronaTestPendingResultSwitch.addTarget(self, action: Selector(("coronaTestPendingResultSwitchChanged")), for: UIControl.Event.valueChanged)
    }

    @objc func coronaTestPositiveResultSwitchChanged() {
        if (coronaTestPositiveResultSwitch.isOn) {
            coronaTestNegativeResultSwitch.setOn(false, animated: true)
            coronaTestPendingResultSwitch.setOn(false, animated: true)
        }
    }

    @objc func coronaTestNegativeResultSwitchChanged() {
        if (coronaTestNegativeResultSwitch.isOn) {
            coronaTestPositiveResultSwitch.setOn(false, animated: true)
            coronaTestPendingResultSwitch.setOn(false, animated: true)
        }
    }

    @objc func coronaTestPendingResultSwitchChanged() {
        if (coronaTestPendingResultSwitch.isOn) {
            coronaTestNegativeResultSwitch.setOn(false, animated: true)
            coronaTestPositiveResultSwitch.setOn(false, animated: true)
        }
    }

    @objc func finishCoronaTest() {
        self.dismiss(animated: true, completion: nil)
    }
}

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
    var coronaTestResult = CoronaTestResultDao.CoronaTestResultState.pending
    public var coronaTestDelegate: PresentedViewControllerDelegate

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,
         coronaTestDelegate: PresentedViewControllerDelegate) {
        self.coronaTestDelegate = coronaTestDelegate

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SARS-CoV-2-Test"
        
        let leftBarButtonItem = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self,
        action: #selector(cancelTest))
        leftBarButtonItem.tintColor = UIColor(named: "AppDarkBlue")
        let rightBarButtonItem = UIBarButtonItem(title: "Speichern", style: .done, target: self,
        action: #selector(finishCoronaTest))
        rightBarButtonItem.tintColor = UIColor(named: "AppDarkBlue")
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.rightBarButtonItem!.isEnabled = false

        setupTestResults()
        setupTestDate()
    }

    private func setupTestDate() {
        coronaTestDatePicker.datePickerMode = .date

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let selectedDateButton = UIBarButtonItem(title: "Speichern", style: .plain, target: self,
                action: #selector(selectedDate));

        toolbar.setItems([spaceButton, selectedDateButton], animated: false)

        coronaTestDateTextField.inputAccessoryView = toolbar
        coronaTestDateTextField.inputView = coronaTestDatePicker
    }

    @objc private func selectedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        coronaTestDateTextField.text = formatter.string(from: coronaTestDatePicker.date)
        self.view.endEditing(true)

        self.navigationItem.rightBarButtonItem!.isEnabled = true
    }

    private func setupTestResults() {
        coronaTestPositiveResultSwitch.setOn(false, animated: false)
        coronaTestPositiveResultSwitch.addTarget(self, action: Selector(("coronaTestPositiveResultSwitchChanged")),
                for: UIControl.Event.valueChanged)

        coronaTestNegativeResultSwitch.setOn(false, animated: false)
        coronaTestNegativeResultSwitch.addTarget(self, action: Selector(("coronaTestNegativeResultSwitchChanged")),
                for: UIControl.Event.valueChanged)

        coronaTestPendingResultSwitch.setOn(true, animated: false)
        coronaTestPendingResultSwitch.addTarget(self, action: Selector(("coronaTestPendingResultSwitchChanged")),
                for: UIControl.Event.valueChanged)
    }

    @objc func coronaTestPositiveResultSwitchChanged() {
        if (coronaTestPositiveResultSwitch.isOn) {
            coronaTestResult = .positive

            coronaTestNegativeResultSwitch.setOn(false, animated: true)
            coronaTestPendingResultSwitch.setOn(false, animated: true)
        }
    }

    @objc func coronaTestNegativeResultSwitchChanged() {
        if (coronaTestNegativeResultSwitch.isOn) {
            coronaTestResult = .negative

            coronaTestPositiveResultSwitch.setOn(false, animated: true)
            coronaTestPendingResultSwitch.setOn(false, animated: true)
        }
    }

    @objc func coronaTestPendingResultSwitchChanged() {
        if (coronaTestPendingResultSwitch.isOn) {
            coronaTestResult = .pending

            coronaTestNegativeResultSwitch.setOn(false, animated: true)
            coronaTestPositiveResultSwitch.setOn(false, animated: true)
        }
    }

    @objc func finishCoronaTest() {
        storeTestResult()

        self.dismiss(animated: true, completion: nil)
    }

    private func storeTestResult() {
        let dao = CoronaTestResultDao()
        let testResult = dao.newEntity()
        testResult.testDate = coronaTestDatePicker.date
        testResult.result = coronaTestResult.rawValue

        DatabaseManager.shared.saveContext()

        dao.markObjectForSync(object: testResult)

        self.coronaTestDelegate.didEndPresentation(presentedViewController: self)
    }

    @objc func cancelTest() {
       self.dismiss(animated: true, completion: nil)
    }
}

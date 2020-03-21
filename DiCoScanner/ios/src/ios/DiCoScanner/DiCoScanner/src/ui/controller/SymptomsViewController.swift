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
    @IBOutlet var startSymptomsTestButton: UIButton!
    @IBOutlet var symptomsDiaryStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupCoronaTestResults()
        
        setupSymptomsTestButton()

        setupSymptomsDiaryEntries()
    }

    private func setupSymptomsDiaryEntries() {
        let diaryEntryView = DiaryEntryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        symptomsDiaryStackView.addArrangedSubview(diaryEntryView)

        let diaryEntryView2 = DiaryEntryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        symptomsDiaryStackView.addArrangedSubview(diaryEntryView2)
    }

    func setupCoronaTestResults() {
        coronaTestResultLabel.text = "Ausstehend"
        coronaTestResultLabel.textColor = UIColor(named: "AppOrange")
    }
    
    func setupSymptomsTestButton() {
        startSymptomsTestButton.layer.borderColor = UIColor.black.cgColor
    }
}

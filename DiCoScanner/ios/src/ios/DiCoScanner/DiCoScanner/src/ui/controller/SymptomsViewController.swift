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
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Symptome"

        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupCoronaTestResults()
        
        setupSymptomsTestButton()

        setupSymptomsDiaryEntries()
    }

    private func setupSymptomsDiaryEntries() {
        let diaryEntryView = DiaryEntryView()
        let diaryEntryView2 = DiaryEntryView()
        
        let arrangedSubviews = [diaryEntryView, diaryEntryView2]
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
    }

    func setupCoronaTestResults() {
        coronaTestResultLabel.text = "Ausstehend"
        coronaTestResultLabel.textColor = UIColor(named: "AppOrange")
    }
    
    func setupSymptomsTestButton() {
        startSymptomsTestButton.layer.borderColor = UIColor.black.cgColor
    }
}

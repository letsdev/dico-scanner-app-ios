//
//  SymptomsViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController, CoronaTestViewControllerDelegate {

    @IBOutlet var coronaTestResultLabel: UILabel!
    @IBOutlet var startSymptomsTestButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var coronaTestResultContainer: UIView!

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
        diaryEntryView.delegate = self
        let diaryEntryView2 = DiaryEntryView()
        diaryEntryView2.delegate = self

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
        let dao = CoronaTestResultDao()
        let coronaTestResult = dao.findLatest()

        if (coronaTestResult != nil) {
            switch (CoronaTestResultDao.CoronaTestResultState(rawValue: coronaTestResult!.result)) {
            case .positive:
                coronaTestResultLabel.text = "Positiv"
                coronaTestResultLabel.textColor = UIColor(named: "AppGreen")
                break
            case .negative:
                coronaTestResultLabel.text = "Negativ"
                coronaTestResultLabel.textColor = UIColor(named: "AppRed")
                break
            case .pending:
                coronaTestResultLabel.text = "Ausstehend"
                coronaTestResultLabel.textColor = UIColor(named: "AppOrange")
                break
            default:
                break
            }
        } else {
            coronaTestResultLabel.text = "-"
            coronaTestResultLabel.textColor = UIColor.black
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleCoronaTestResultsTap(_:)))
        coronaTestResultContainer.addGestureRecognizer(tapGestureRecognizer)
    }

    func setupSymptomsTestButton() {
        startSymptomsTestButton.layer.borderColor = UIColor.black.cgColor
    }

    @objc func handleCoronaTestResultsTap(_ sender: UITapGestureRecognizer? = nil) {
        startCoronaTest()
    }

    func startCoronaTest() {
        let coronaTestVC = CoronaTestViewController(nibName: String(describing: CoronaTestViewController.self), bundle: nil, coronaTestDelegate: self)
        let navigationController = UINavigationController(rootViewController: coronaTestVC)
        self.present(navigationController, animated: true, completion: nil)
    }

    func didCompleteCoronaTest() {
        self.setupCoronaTestResults()
    }
}

extension SymptomsViewController: DiaryEntryViewDelegate {

    func didClickEntry() {
        self.present(DiaryEntryDetailViewController(), animated: true)
    }

}

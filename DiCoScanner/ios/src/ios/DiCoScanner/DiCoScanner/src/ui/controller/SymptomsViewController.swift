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
    @IBOutlet var coronaTestButton: UIButton!
    @IBOutlet var startSymptomsTestButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var coronaTestResultContainer: UIView!
    @IBOutlet weak var symptomsDiaryContainerView: UIView!

    private let symptomDiaryDao = SymptomDiaryEntryDao()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Symptome"
        navigationController?.navigationBar.prefersLargeTitles = true

        setupCoronaTestButton()
        
        setupCoronaTestResults()

        setupSymptomsTestButton()

        setupSymptomsDiaryEntries()
    }

    private func setupSymptomsDiaryEntries() {
        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }

        var arrangedSubviews: [DiaryEntryView] = []

        symptomDiaryDao.findAllByDate()?.forEach { (diaryEntry: SymptomDiaryEntry) in
            let diaryEntryView = DiaryEntryView()
            diaryEntryView.delegate = self
            diaryEntryView.diaryEntry = diaryEntry
            arrangedSubviews.append(diaryEntryView)
        }

        guard arrangedSubviews.count > 0 else {
            symptomsDiaryContainerView.isHidden = true
            return
        }

        symptomsDiaryContainerView.isHidden = false

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
            switch (CoronaTestResultDao.CoronaTestResultState(rawValue: coronaTestResult!.result!)) {
            case .positive:
                coronaTestResultLabel.text = "Positiv"
                coronaTestResultLabel.textColor = UIColor(named: "AppRed")
                break
            case .negative:
                coronaTestResultLabel.text = "Negativ"
                coronaTestResultLabel.textColor = UIColor(named: "AppGreen")
                break
            case .pending:
                coronaTestResultLabel.text = "Ergebnis ausstehend"
                coronaTestResultLabel.textColor = UIColor(named: "AppOrange")
                break
            default:
                break
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let coronaTestDate = formatter.string(from: coronaTestResult!.testDate!)
            coronaTestResultLabel.text = coronaTestResultLabel.text! + " (\(coronaTestDate))"
        } else {
            coronaTestResultLabel.text = "-"
            coronaTestResultLabel.textColor = UIColor.black
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                action: #selector(self.handleCoronaTestResultsTap(_:)))
        coronaTestResultContainer.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupCoronaTestButton() {
        coronaTestButton.addTarget(self, action: #selector(self.handleCoronaTestButtonTap(_:)), for: .touchUpInside)
    }
    
    func setupSymptomsTestButton() {
        startSymptomsTestButton.layer.borderColor = UIColor(named: "AppDarkBlue")!.cgColor
    }

    @objc func handleSymptomsTestButtonTap(_ sender: UITapGestureRecognizer? = nil) {
       
    }
    
    @objc func handleCoronaTestResultsTap(_ sender: UITapGestureRecognizer? = nil) {
        
    }
    
    @objc func handleCoronaTestButtonTap(_ sender: UITapGestureRecognizer? = nil) {
      startCoronaTest()
    }

    func startCoronaTest() {
        let coronaTestVC = CoronaTestViewController(nibName: String(describing: CoronaTestViewController.self),
                bundle: nil, coronaTestDelegate: self)
        let navigationController = UINavigationController(rootViewController: coronaTestVC)
        self.present(navigationController, animated: true, completion: nil)
    }

    func didCompleteCoronaTest() {
        self.setupCoronaTestResults()
    }
}

extension SymptomsViewController: DiaryEntryViewDelegate {
    func didClick(entry: SymptomDiaryEntry?) {
        let vc = DiaryEntryDetailViewController()
        vc.entry = entry
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

extension SymptomsViewController: DiaryEntryDetailViewControllerDelegate {
    func deleteButtonTapped(_ controller: DiaryEntryDetailViewController, _ entry: SymptomDiaryEntry?) {
        controller.dismiss(animated: true)

        if let entry = entry {
            SymptomDiaryEntryDao().delete(object: entry)
        }

        setupSymptomsDiaryEntries()
    }
}

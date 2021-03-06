//
//  SymptomsViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController, PresentedViewControllerDelegate {

    @IBOutlet var coronaTestResultHeaderLabel: UILabel!
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

        setupSymptomsTestButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupCoronaTestResults()

        setupSymptomsDiaryEntries()
        setupSymptomDiaryEntrySyncObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeSymptomDiaryEntrySyncObserver()
    }

    private func setupSymptomDiaryEntrySyncObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSyncSymptomDiaryEntry(_:)), name: .didSyncSymptomDiaryEntry, object: nil)
    }

    private func removeSymptomDiaryEntrySyncObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onDidSyncSymptomDiaryEntry(_ notification:Notification) {
        DispatchQueue.main.async {
            self.setupSymptomsDiaryEntries()
        }
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
            coronaTestResultContainer.isHidden = false
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

            coronaTestResultHeaderLabel.text = coronaTestResult?.labelWithDate()
        } else {
            coronaTestResultContainer.isHidden = true
        }
    }

    func setupCoronaTestButton() {
        coronaTestButton.addTarget(self, action: #selector(self.handleCoronaTestButtonTap(_:)), for: .touchUpInside)
    }

    func setupSymptomsTestButton() {
        startSymptomsTestButton.layer.borderColor = UIColor(named: "AppDarkBlue")!.cgColor
        startSymptomsTestButton.addTarget(self, action: #selector(self.handleSymptomsTestButtonTap(_:)), for: .touchUpInside)
    }

    @objc func handleCoronaTestButtonTap(_ sender: UITapGestureRecognizer? = nil) {
      startCoronaTest()
    }

    public func startCoronaTest() {
        let coronaTestVC = CoronaTestViewController(nibName: String(describing: CoronaTestViewController.self),
                bundle: nil, coronaTestDelegate: self)
        let navigationController = UINavigationController(rootViewController: coronaTestVC)
        self.present(navigationController, animated: true, completion: nil)
    }

    @objc func handleSymptomsTestButtonTap(_ sender: UITapGestureRecognizer? = nil) {
        startSymptomsTest()
    }

    public func startSymptomsTest() {
        let symptomsTestVC = SymptomsTestViewController(nibName: String(describing: SymptomsTestViewController.self),
                bundle: nil, symptomsTestDelegate: self)
        let navigationController = UINavigationController(rootViewController: symptomsTestVC)
        self.present(navigationController, animated: true, completion: nil)
    }

    func didEndPresentation(presentedViewController: UIViewController) {
        if (presentedViewController.isKind(of: CoronaTestViewController.self)) {
            self.setupCoronaTestResults()
        } else if (presentedViewController.isKind(of: SymptomsTestViewController.self)) {
            self.setupSymptomsDiaryEntries()
        }
    }
}

extension SymptomsViewController: DiaryEntryViewDelegate {
    func didClick(entry: SymptomDiaryEntry?) {
        let vc = DiaryEntryDetailViewController()
        vc.entry = entry
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true)
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

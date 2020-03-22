//
//  DiaryEntryDetailViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

protocol DiaryEntryDetailViewControllerDelegate {

    func deleteButtonTapped(_: DiaryEntryDetailViewController, _: SymptomDiaryEntry?)
}

class DiaryEntryDetailViewController: UIViewController {

    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var symptomsTableView: UITableView!
    @IBOutlet weak var resultLabel: UILabel!

    var entry: SymptomDiaryEntry?

    var delegate: DiaryEntryDetailViewControllerDelegate?

    private let symptomDao = SymptomDao()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        setupTableView()
        setupResultLabel()

        SymptomGetRequest().send { result in
            if (result) {
                self.symptomsTableView.reloadData()
            }
        }
    }

    private func setupResultLabel() {
        resultLabel.text = entry?.resultLabel()
        
        let areYouSickResult = SymptomDiaryEntryDao.DiaryTestResult(rawValue: entry!.areYouSick)
        if (areYouSickResult == .positive) {
            resultLabel.textColor = UIColor(named: "AppGreen")
        } else {
            resultLabel.textColor = UIColor(named: "AppRed")
        }
    }

    private func setupTableView() {
        symptomsTableView.dataSource = self
        symptomsTableView.register(UINib(nibName: "SymptomsTableViewCell", bundle: Bundle.main),
                forCellReuseIdentifier: "SymptomsTableViewCell")
    }

    private func setupHeaderView() {
        let headerView = DiaryEntryView()
        headerView.diaryEntry = entry
        headerContainerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerView.bottomAnchor.constraint(lessThanOrEqualTo: headerContainerView.bottomAnchor)
        ])
    }


    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteButtonTapped(self, entry)
    }
}

extension DiaryEntryDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        symptomDao.countAll()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "SymptomsTableViewCell") as? SymptomsTableViewCell else {
            return UITableViewCell()
        }

        let symptom = symptomDao.findAllSortByName()?[indexPath.row]
        cell.symptomNameLabel.text = symptom?.name

        if (entry?.symptom?.contains(symptom) ?? false) {
            cell.symptomStatusImageView.image = UIImage(named: "ic_selected")
        } else {
            cell.symptomStatusImageView.image = UIImage(named: "ic_not_selected")
        }

        return cell
    }
}

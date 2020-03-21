//
//  DiaryEntryDetailViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class DiaryEntryDetailViewController: UIViewController {

    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var symptomsTableView: UITableView!

    var entry: SymptomDiaryEntry?

    private let symptomDao = SymptomDao()

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerView = DiaryEntryView()
        headerContainerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerView.bottomAnchor.constraint(lessThanOrEqualTo: headerContainerView.bottomAnchor)
        ])

        symptomsTableView.dataSource = self
        symptomsTableView.register(UINib(nibName: "SymptomsTableViewCell", bundle: Bundle.main),
                forCellReuseIdentifier: "SymptomsTableViewCell")
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

        let symptom = symptomDao.findAllSortByName()[indexPath.row]
        cell.symptomNameLabel.text = symptom.name

        if (entry?.symptom?.contains(symptom) ?? false) {
            cell.symptomStatusImageView.image = UIImage(named: "ic_tabbar_symptoms_active")
        } else {
            cell.symptomStatusImageView.image = UIImage(named: "ic_tabbar_symptoms_normal")
        }

        cell.symptomIconImageView.image = UIImage(named: "ic_info")

        return cell
    }
}

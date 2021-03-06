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

    @IBOutlet weak var symptomsTableView: UITableView!
    @IBOutlet weak var resultLabel: UILabel!

    var entry: SymptomDiaryEntry?

    var delegate: DiaryEntryDetailViewControllerDelegate?

    private let symptomDao = SymptomDao()

    private var dataSource: [Symptom]? {
        get {
            let name = symptomDao.findAllSortByName()

            let contained = name?.filter { (symptom: Symptom) in
                (entry?.symptom?.contains(symptom) ?? false)
            } ?? []

            let notcontained = name?.filter { (symptom: Symptom) in
                !(entry?.symptom?.contains(symptom) ?? false)
            } ?? []

            return contained + notcontained
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupResultLabel()
        setupNavigationBar()

        SymptomGetRequest().send { result in
            if (result) {
                self.symptomsTableView.reloadData()
            }
        }
    }

    private func setupNavigationBar() {
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self,
                action: #selector(cancelTest))
        leftBarButtonItem.tintColor = UIColor(named: "AppDarkBlue")
        self.navigationItem.leftBarButtonItem = leftBarButtonItem

        self.title = entry?.dateLabel()
    }

    private func setupResultLabel() {
        resultLabel.text = entry?.resultLabel()
        resultLabel.textColor = entry?.resultLabelColor()
    }

    private func setupTableView() {
        symptomsTableView.dataSource = self
        symptomsTableView.register(UINib(nibName: "SymptomsTableViewCell", bundle: Bundle.main),
                forCellReuseIdentifier: "SymptomsTableViewCell")
    }

    @objc private func cancelTest() {
        self.dismiss(animated: true)
    }


    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteButtonTapped(self, entry)
    }
}

extension DiaryEntryDetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "SymptomsTableViewCell") as? SymptomsTableViewCell else {
            return UITableViewCell()
        }

        let symptom = dataSource?[indexPath.row]

        if let uuid = symptom?.uuid {
            cell.symtpomIconImageView.image = UIImage.image(symptomId: uuid)
        }
        cell.symptomNameLabel.text = symptom?.name

        if (entry?.symptom?.contains(symptom) ?? false) {
            cell.symptomStatusImageView.image = UIImage(named: "ic_selected")
        } else {
            cell.symptomStatusImageView.image = UIImage(named: "ic_not_selected")
        }

        return cell
    }
}

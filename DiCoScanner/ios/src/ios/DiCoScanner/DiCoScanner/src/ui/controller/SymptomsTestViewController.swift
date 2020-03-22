//
//  SymptomsTestViewController.swift
//  DiCoScanner
//
//  Created by Fabian Köbel on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class SymptomsTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var symptomsTableView: UITableView!
    var symptomList: [Symptom]? = []
    
    public var symptomsTestDelegate: PresentedViewControllerDelegate

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,
         symptomsTestDelegate: PresentedViewControllerDelegate) {
        self.symptomsTestDelegate = symptomsTestDelegate

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "aktuelle Symptome"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self,
                action: #selector(cancelTest))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Weiter", style: .plain, target: self,
                action: #selector(finishSymptomsTest))

        setupSymptomsTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SymptomGetRequest().send { result in
            if (result) {
                self.loadSymptomList()
                self.symptomsTableView.reloadData()
            }
        }
    }
    
    func loadSymptomList() {
        symptomList = SymptomDao().findAll()
    }

    func setupSymptomsTableView() {
        loadSymptomList()
        
        symptomsTableView.delegate = self
        symptomsTableView.dataSource = self
        symptomsTableView.tableFooterView = UIView()
    }

    @objc func finishSymptomsTest() {
        self.symptomsTestDelegate.didEndPresentation(presentedViewController: self)

        self.dismiss(animated: true, completion: nil)
    }

    @objc func cancelTest() {
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: String(describing: UITableViewCell.self))
        }

        cell = setupSymptomCell(symptomCell: cell!, symptom: (symptomList?[indexPath.row])!)

        return cell!
    }
    
    func setupSymptomCell(symptomCell: UITableViewCell, symptom: Symptom) -> UITableViewCell {
        symptomCell.preservesSuperviewLayoutMargins = false
        symptomCell.separatorInset = UIEdgeInsets.zero
        symptomCell.layoutMargins = UIEdgeInsets.zero
        symptomCell.selectionStyle = .none
        
        symptomCell.textLabel?.text = symptom.name
        symptomCell.imageView?.image = UIImage(named: "ic_info")
        
        return symptomCell
    }
}

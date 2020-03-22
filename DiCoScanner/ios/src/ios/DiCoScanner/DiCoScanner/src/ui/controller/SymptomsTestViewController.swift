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
    var selectedSymptomList: [Symptom]? = []
    
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

        self.title = "Symptome dokumentieren"
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Abbrechen", style: .plain, target: self,
        action: #selector(cancelTest))
        leftBarButtonItem.tintColor = UIColor(named: "AppDarkBlue")
        let rightBarButtonItem = UIBarButtonItem(title: "Speichern", style: .done, target: self,
        action: #selector(finishSymptomsTest))
        rightBarButtonItem.tintColor = UIColor(named: "AppDarkBlue")
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

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
        symptomList = SymptomDao().findAllSortByName()
    }

    func setupSymptomsTableView() {
        loadSymptomList()
        
        symptomsTableView.delegate = self
        symptomsTableView.dataSource = self
        symptomsTableView.tableFooterView = UIView()
    }

    @objc func finishSymptomsTest() {
        self.navigationItem.rightBarButtonItem!.isEnabled = false
        
        storeSymptomDiaryEntry()
        
        self.symptomsTestDelegate.didEndPresentation(presentedViewController: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    func storeSymptomDiaryEntry() {
        let dao = SymptomDiaryEntryDao()
        let symptomDiaryEntry = dao.newEntity()
        symptomDiaryEntry.entryDate = Date()
        symptomDiaryEntry.areYouSick = SymptomDiaryEntryDao.DiaryTestResult.pending.rawValue
        symptomDiaryEntry.addToSymptom(NSSet(array: selectedSymptomList!))
        
        DatabaseManager.shared.saveContext()
        
        dao.markObjectForSync(object: symptomDiaryEntry)
    }

    @objc func cancelTest() {
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        
        let deselectedSymptom = symptomList?[indexPath.row]
        selectedSymptomList!.removeAll { (currentSymptom: Symptom) -> Bool in
            currentSymptom.uuid == deselectedSymptom!.uuid
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }

        guard let selectedSymptom = symptomList?[indexPath.row] else { return }
        selectedSymptomList?.append(selectedSymptom)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: String(describing: UITableViewCell.self))
        }

        if (tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
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
        symptomCell.imageView?.image = UIImage.image(symptomId: symptom.uuid)
        
        return symptomCell
    }
}

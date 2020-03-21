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

    func setupSymptomsTableView() {
        symptomsTableView.delegate = self
        symptomsTableView.dataSource = self
        symptomsTableView.tableFooterView = UIView()
        symptomsTableView.heightAnchor.constraint(equalToConstant: symptomsTableView.contentSize.height).isActive = true
    }

    @objc func finishSymptomsTest() {
        self.symptomsTestDelegate.didEndPresentation(presentedViewController: self)

        self.dismiss(animated: true, completion: nil)
    }

    @objc func cancelTest() {
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: String(describing: UITableViewCell.self))
        }

        cell = setupSymptomCell(symptomCell: cell!)

        return cell!
    }
    
    func setupSymptomCell(symptomCell: UITableViewCell) -> UITableViewCell {
        symptomCell.preservesSuperviewLayoutMargins = false
        symptomCell.separatorInset = UIEdgeInsets.zero
        symptomCell.layoutMargins = UIEdgeInsets.zero
        
        symptomCell.textLabel?.text = "hi"
        symptomCell.imageView?.image = UIImage(named: "ic_info")
        
        return symptomCell
    }
}

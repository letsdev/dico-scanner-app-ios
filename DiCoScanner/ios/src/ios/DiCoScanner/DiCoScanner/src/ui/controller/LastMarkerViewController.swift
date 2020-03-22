//
//  LastMarkerViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class LastMarkerViewController: UIViewController {

    @IBOutlet weak var lastMarkerHeaderView: UIView!
    @IBOutlet weak var lastMarkerHeader: UILabel!
    @IBOutlet weak var lastMarkerTimestampLabel: UILabel!
    @IBOutlet weak var lastMarkerTableView: UITableView!

    private let dao = MarkerDao()

    override func viewDidLoad() {
        super.viewDidLoad()

        lastMarkerHeader.text = "Meine letzten Markierungen"
        lastMarkerTimestampLabel.text = "Es wurden noch keine Markierungen gesetzt."

        lastMarkerTableView.dataSource = self
        lastMarkerTableView.register(UINib(nibName: "LastMarkerTableViewCell", bundle: Bundle.main),
                forCellReuseIdentifier: "LastMarkerTableViewCell")
    }

}

extension LastMarkerViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dao.countAll()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "LastMarkerTableViewCell") as? LastMarkerTableViewCell else {
            return UITableViewCell()
        }

        let all = dao.findAllByDate();
        if let all = all {
            let marker = all[indexPath.row]
            if let eventDate = marker.eventDate {
                cell.lastMarkerTimeStampLabel.text = DateFormatter.localizedString(for: eventDate)
            }

            cell.lastMarkerCoordinatesLabel.text = marker.coordinatesString()
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let all = dao.findAllByDate();
            if let deleteMarker = all?[indexPath.row] {
                dao.delete(object: deleteMarker)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

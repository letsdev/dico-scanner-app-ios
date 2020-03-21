//
//  LastMarkerViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class LastMarkerViewController: UIViewController {

    @IBOutlet weak var lastMarkerHeader: UILabel!
    @IBOutlet weak var lastMarkerTimestampLabel: UILabel!
    @IBOutlet weak var lastMarkerTableView: UITableView!

    private let dao = MarkerDao()

    override func viewDidLoad() {
        super.viewDidLoad()

        lastMarkerHeader.text = "Meine letzten Markierungen"
        lastMarkerTimestampLabel.text = "Dein Standort wurde zuletzt vor 14 Minuten getrackt"

        lastMarkerTableView.dataSource = self
        lastMarkerTableView.register(UINib(nibName: "LastMarkerTableViewCell", bundle: Bundle.main),
                forCellReuseIdentifier: "LastMarkerTableViewCell")
    }

}

extension LastMarkerViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let all2 = dao.countAll()
        return all2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "LastMarkerTableViewCell") as? LastMarkerTableViewCell else {
            return UITableViewCell()
        }

        let all = dao.findAll();
        if let all = all {
            let marker = all[indexPath.row]
            if let eventDate = marker.eventDate {
                cell.lastMarkerTimeStampLabel.text = DateFormatter.localizedString(for: eventDate)
            }

            cell.lastMarkerCoordinatesLabel.text = marker.coordinatesString()
        }
        return cell
    }
}

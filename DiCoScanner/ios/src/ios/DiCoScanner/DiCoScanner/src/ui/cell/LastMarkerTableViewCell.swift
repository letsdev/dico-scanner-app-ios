//
//  LastMarkerTableViewCell.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class LastMarkerTableViewCell: UITableViewCell {

    @IBOutlet weak var lastMarkerTimeStampLabel: UILabel!
    @IBOutlet weak var lastMarkerCoordinatesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

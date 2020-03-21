//
//  SymptomsTableViewCell.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class SymptomsTableViewCell: UITableViewCell {

    @IBOutlet weak var symptomIconImageView: UIImageView!
    @IBOutlet weak var symptomNameLabel: UILabel!
    @IBOutlet weak var symptomStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        symptomIconImageView.image = UIImage(named: "AppIcon")
        symptomNameLabel.text = "Abgeschlagenheit"
        symptomStatusImageView.image = UIImage(named: "AppIcon")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

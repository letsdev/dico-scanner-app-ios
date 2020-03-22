//
//  SymptomsTableViewCell.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit

class SymptomsTableViewCell: UITableViewCell {

    @IBOutlet weak var symtpomIconImageView: UIImageView!
    @IBOutlet weak var symptomNameLabel: UILabel!
    @IBOutlet weak var symptomStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        symptomNameLabel.text = "Symptom"
        symptomStatusImageView.image = UIImage(named: "ic_symptoms")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        symptomNameLabel.text = nil
        symptomStatusImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

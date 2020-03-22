//
//  UIImage+SymptomImage.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 22.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

extension UIImage {
    
    static func image(symptomId: String?)-> UIImage? {
        if let id = symptomId, let image = UIImage(named: "ic_symptom_\(id)") {
            return image
        } else {
            return UIImage(named: "ic_symptom_default")
        }
    }
    
}

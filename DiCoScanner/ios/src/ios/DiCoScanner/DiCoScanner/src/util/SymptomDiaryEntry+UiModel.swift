//
//  SymptomDiaryEntry+UiModel.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

extension SymptomDiaryEntry {
    func dateLabel() -> String {
        guard let date = self.entryDate else {
            return ""
        }
        
        return DateFormatter.localizedString(for: date)
    }
}

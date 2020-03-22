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
        
        return "Test vom \(DateFormatter.localizedString(for: date))"
    }
    
    func resultLabel() -> String {

        switch (SymptomDiaryEntryDao.DiaryTestResult(rawValue: self.areYouSick)) {
        case .positive:
            return "Anzeichen für COVID-19*"
        case .negative:
            return "Keine COVID-19 Anzeichen*"
        case .pending:
            return "Ergebnis wird ermittelt..."
        default:
            return ""
        }
    }
}

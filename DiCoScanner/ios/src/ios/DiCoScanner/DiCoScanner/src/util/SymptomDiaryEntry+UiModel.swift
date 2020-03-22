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
            return self.hintText ?? "Anzeichen für COVID-19*"
        case .negative:
            return self.hintText ?? "Keine COVID-19 Anzeichen*"
        case .pending:
            return "Ergebnis wird ermittelt..."
        default:
            return ""
        }
    }

    func resultLabelColor() -> UIColor {
        let areYouSickResult = SymptomDiaryEntryDao.DiaryTestResult(rawValue: self.areYouSick)
        if (areYouSickResult == .positive) {
            return UIColor(named: "AppRed")!
        } else if (areYouSickResult == .negative) {
            return UIColor(named: "AppGreen")!
        }

        return UIColor.black
    }
}

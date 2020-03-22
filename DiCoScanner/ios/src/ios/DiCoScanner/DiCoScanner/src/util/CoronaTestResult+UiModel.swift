//
//  CoronaTestResult+UiModel.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 22.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

extension CoronaTestResult {

    func labelWithDate() -> String {
        guard let testDate = self.testDate else {
            return "SARS-CoV-2 Test"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return "SARS-CoV-2 Test am \(formatter.string(from: testDate))"
    }

}

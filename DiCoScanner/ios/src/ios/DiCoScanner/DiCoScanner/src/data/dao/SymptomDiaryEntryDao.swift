//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

class SymptomDiaryEntryDao: BaseDao<SymptomDiaryEntry> {
    enum DiaryTestResult : Int32 {
        case positive
        case negative
        case pending
    }


    func findAllByDate() -> [SymptomDiaryEntry]? {
        findAll(sortBy: NSSortDescriptor(key: "entryDate", ascending: false))
    }
}

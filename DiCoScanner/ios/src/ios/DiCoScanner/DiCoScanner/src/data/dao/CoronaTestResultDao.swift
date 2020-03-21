//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

class CoronaTestResultDao : BaseDao<CoronaTestResult> {
    enum CoronaTestResultState: String {
        case positive = "positive"
        case negative = "negative"
        case pending = "initialized"
    }

    func findLatest() -> CoronaTestResult? {
        findBy(predicate: nil, sortBy: NSSortDescriptor(key: "testDate", ascending: false))
    }
}

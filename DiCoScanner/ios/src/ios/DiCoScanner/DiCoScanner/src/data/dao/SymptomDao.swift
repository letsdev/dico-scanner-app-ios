//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreData

class SymptomDao: BaseDao<Symptom> {

    internal func findAllSortByName() -> [Symptom] {
        findAll(sortBy: NSSortDescriptor(key: "name", ascending: true))
    }

}

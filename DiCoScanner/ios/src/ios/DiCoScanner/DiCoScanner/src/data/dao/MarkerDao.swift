//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreData

class MarkerDao: BaseDao<Marker> {

    func findAllByDate() -> [Marker]? {
        findAll(sortBy: NSSortDescriptor(key: "eventDate", ascending: false))
    }

    func findLatest() -> Marker? {
        findBy(predicate: nil, sortBy: NSSortDescriptor(key: "eventDate", ascending: false))
    }

}

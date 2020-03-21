//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import CoreData

class SyncDao: BaseDao<Sync> {

    func findAllNotSynced() -> [Sync]? {
        findAll(predicate: NSPredicate(format: "syncState == %i", SyncState.pending.rawValue),
                sortBy: NSSortDescriptor(key: "createdDate", ascending: true))
    }

}

//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import CoreData


class SyncManager {
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveContext),
                name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    @objc func didSaveContext(context: NSManagedObjectContext) {

        let objectsToSync = SyncDao().findAllNotSynced();
        if let objectsToSync = objectsToSync {
            for object in objectsToSync {
                object.syncState = SyncState.inProgress.rawValue

            }
        }
    }
}

enum SyncState: Int32 {
    case pending = 0
    case inProgress = 1
    case done = 2
}
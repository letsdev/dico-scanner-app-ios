//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import CoreData
import os

class SyncManager {

    func register(){
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveContext),
                name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didSaveContext(context: NSManagedObjectContext) {

        let objectsToSync = SyncDao().findAllNotSynced();
        if let objectsToSync = objectsToSync {
            for object in objectsToSync {
                object.syncState = SyncState.inProgress.rawValue
                if let uri = object.refObjectId {
                    let objectId = DatabaseManager.shared.persistentContainer.persistentStoreCoordinator.managedObjectID(
                            forURIRepresentation: uri)
                    if let request = convertToRequest(objectId: objectId) {
                        os_log("Sending request")
                        request.send { result in
                            os_log("Did send request with result: %i", result)
                        }
                    }
                }
            }
        }
    }

    func convertToRequest(objectId: NSManagedObjectID?) -> BaseRequest? {
        guard let objectId = objectId else {
            return nil
        }

        var request: BaseRequest? = nil
        if let name = objectId.entity.name {

            switch name {
            case "Marker":
                if let marker = MarkerDao().findByObjectId(objectId: objectId) {
                    request = MarkerPostRequest(marker: marker)
                }
            default:
                request = nil
            }
        }
        return request
    }

}

enum SyncState: Int32 {
    case pending = 0
    case inProgress = 1
    case done = 2
}
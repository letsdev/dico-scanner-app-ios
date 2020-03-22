//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import CoreData
import os

class SyncManager {

    private var ignoreSave = false;

    func register() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveContext),
                name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didSaveContext(context: NSManagedObjectContext) {

        guard !ignoreSave else {
            ignoreSave = false
            return
        }

        let objectsToSync = SyncDao().findAllNotSynced();
        if let objectsToSync = objectsToSync {
            for object in objectsToSync {
                object.syncState = SyncState.inProgress.rawValue
                if let uri = object.refObjectId {
                    let objectId = DatabaseManager.shared.persistentContainer.persistentStoreCoordinator.managedObjectID(
                            forURIRepresentation: uri)
                    if let request = convertToRequest(objectId: objectId) {
                        os_log("Sending request")
                        request.send { [weak self] result in
                            if let strongSelf = self {
                                SyncDao().delete(object: object)
                                strongSelf.ignoreSave = true;
                                DatabaseManager.shared.saveContext()
                            }
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
            case "CoronaTestResult":
                if let testResult = CoronaTestResultDao().findByObjectId(objectId: objectId) {
                    request = CoronaTestPostRequest(testResult: testResult)
                }
            case "SymptomDiaryEntry":
                if let entry = SymptomDiaryEntryDao().findByObjectId(objectId: objectId) {
                    request = SymptomDiaryPostRequest(symptomDiary: entry)
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
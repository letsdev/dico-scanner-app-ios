//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreData

class BaseDao<T> where T: NSManagedObject {

    let entityName: String = "\(T.self)"

    internal func countAll() -> Int {
        let request = NSFetchRequest<T>(entityName: entityName)
        let result = execute {
            try DatabaseManager.shared.persistentContainer.viewContext.count(for: request)
        } as! Int
        return result;
    }

    internal func findAll(sortBy: NSSortDescriptor?) -> [T]? {
        findAll(predicate: nil, sortBy: sortBy)
    }

    internal func findAll(predicate: NSPredicate?, sortBy: NSSortDescriptor?) -> [T]? {
        let request = NSFetchRequest<T>(entityName: entityName)
        configureRequest(request: request, predicate: predicate, sortBy: sortBy)
        let result = execute {
            try DatabaseManager.shared.persistentContainer.viewContext.fetch(request)
        } as? [T]
        return result
    }

    internal func findAll() -> [T]? {
        findAll(sortBy: nil)
    }

    internal func findBy(predicate: NSPredicate?) -> T? {
        findBy(predicate: predicate, sortBy: nil)
    }

    internal func findBy(predicate: NSPredicate?, sortBy: NSSortDescriptor?) -> T? {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.fetchLimit = 1
        configureRequest(request: request, predicate: predicate, sortBy: sortBy)
        let result = (execute {
            try DatabaseManager.shared.persistentContainer.viewContext.fetch(request)
        } as? T)
        return result
    }

    internal func findByUUID(uuid: String?) -> T? {
        var result: T? = nil
        if let uuid = uuid {
            result = findBy(predicate: NSPredicate(format: "uuid == %@", uuid))
        }
        return result
    }

    internal func newEntity() -> T {
        NSEntityDescription.insertNewObject(forEntityName: entityName,
                into: DatabaseManager.shared.persistentContainer.viewContext) as! T
    }

    internal func delete(object: T) {
        DatabaseManager.shared.persistentContainer.viewContext.delete(object)
    }

    internal func findByObjectId(objectId: NSManagedObjectID) -> T? {
        let result = execute {
            try DatabaseManager.shared.persistentContainer.viewContext.existingObject(with: objectId)
        } as? T
        return result
    }

    internal func markObjectForSync(object: T) {

        if (object.objectID.isTemporaryID) {
            DatabaseManager.shared.saveContext()
        }

        guard !object.objectID.isTemporaryID else {
            fatalError("Tried to sync object with temp id.")
        }

        let syncDao = SyncDao()
        let entity = syncDao.newEntity()
        entity.refObjectId = object.objectID.uriRepresentation()
        entity.createdDate = Date()
        entity.syncState = SyncState.pending.rawValue;
    }

    private func execute(statement: () throws -> Any) -> Any {
        do {
            return try statement()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    private func execute(statement: () throws -> [Any]) -> [Any] {
        do {
            return try statement()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    private func configureRequest(request: NSFetchRequest<T>, predicate: NSPredicate?, sortBy: NSSortDescriptor?) {
        if let predicate = predicate {
            request.predicate = predicate
        }
        if let sortBy = sortBy {
            request.sortDescriptors = [sortBy];
        }
    }

}

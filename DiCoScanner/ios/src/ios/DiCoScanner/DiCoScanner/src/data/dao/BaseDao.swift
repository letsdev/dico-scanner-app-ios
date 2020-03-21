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

    internal func findAll() -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        let result = execute {
            try DatabaseManager.shared.persistentContainer.viewContext.fetch(request)
        } as! [T]
        return result
    }

    internal func findByUUID(uuid: String?) -> T? {
        var result: T? = nil
        if let uuid = uuid {
            let request = NSFetchRequest<T>(entityName: entityName)
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "uuid == %@", uuid)
            result = (execute {
                try DatabaseManager.shared.persistentContainer.viewContext.fetch(request)
            } as! T)
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

}

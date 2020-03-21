//
// Copyright © 2020 MBition GmbH. All rights reserved.
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

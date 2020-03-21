//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import CoreData

class SymptomDao: BaseDao {

    internal func countAll() -> Int {
        let request = NSFetchRequest<Symptom>(entityName: "Symptom")
        var result = 0;
        do {
            result = try DatabaseManager.shared.persistentContainer.viewContext.count(for: request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return result;
    }
}

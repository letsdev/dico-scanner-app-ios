//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreData
import os

internal class DatabaseManager {

    internal static let shared = DatabaseManager()

    private init() {
    }

    internal func insertDummyData() {
        // TODO update

        if (SymptomDao().countAll() <= 0) {
            let symptoms = ["symptom1", "symptom2", "symptom3"]

            for symptom in symptoms {
                let object = NSEntityDescription.insertNewObject(forEntityName: "Symptom",
                        into: persistentContainer.viewContext) as! Symptom
                object.name = symptom
            }

            saveContext()
        }

        if (MarkerDao().countAll() <= 0) {
            let marker = NSEntityDescription.insertNewObject(forEntityName: "Marker",
                    into: persistentContainer.viewContext) as! Marker
            marker.altitude = 53.53
            marker.lat = 7575.543
            marker.lon = 75.53
            marker.eventDate = Date()
            marker.verticalAccuracy = 535353.535
            marker.horizontalAccuracy = 535353.535

            saveContext()
        }
    }

    // MARK: - Core Data stack
    internal lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DiCoScanner")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    internal func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

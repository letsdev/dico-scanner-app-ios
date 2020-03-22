//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import os
import CoreData

class SymptomGetRequest: BaseRequest, Request {

    func url() -> URL {
        URL(string: "\(baseUrl)/rest/symptom")!
    }

    func httpMethod() -> String {
        "GET"
    }

    func body() -> [String: Any]? {
        nil
    }

    func additionalHeader() -> [String: String]? {
        nil
    }

    func receivedData(data: Data) {
        do {
            if let symptoms = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                let dao = SymptomDao()
                for symptom in symptoms {
                    var object: Symptom? = nil
                    if let id = symptom["id"] as? Int {
                        let uuid = String(id)
                        object = dao.findByUUID(uuid: uuid)

                        if object == nil {
                            object = dao.newEntity()
                        }
                        object?.uuid = uuid
                        object?.name = symptom["nameDe"] as? String
                    }
                }
                DatabaseManager.shared.saveContext()
            } else {
                os_log("Can't parse json data.")
            }
        } catch {
            let nserror = error as NSError
            fatalError("Can't parso to json: Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    override init() {
        super.init()
        setDelegate(delegate: self)
    }
}

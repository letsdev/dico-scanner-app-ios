//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import CoreData

class MarkerRequest: BaseRequest, Request {

    let marker: Marker

    init(marker: Marker) {
        self.marker = marker
        super.init()
        setDelegate(delegate: self)
    }

    func url() -> URL {
        // TODO device identI I
        URL(string: "http://auou.aou/")!
    }

    func httpMethod() -> String {
        "POST"
    }

    func body() -> [String: Any]? {
        convertToJSON(managedObject: marker)
    }

    func convertToJSON(managedObject: NSManagedObject) -> [String: Any] {
        var jsonDict: [String: Any] = [:]
        for attribute in managedObject.entity.attributesByName {
            if let value = managedObject.value(forKey: attribute.key) {
                if let value = value as? Date {
                    jsonDict[attribute.key] = value.timeIntervalSince1970
                } else {
                    jsonDict[attribute.key] = value
                }
            }
        }
        return jsonDict
    }
}

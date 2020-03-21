//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreData

class MarkerRequest: BaseRequest, Request {

    private let marker: Marker

    init(marker: Marker) {
        self.marker = marker
        super.init()
        setDelegate(delegate: self)
    }

    func url() -> URL {
        URL(string: "\(baseUrl)/position")!
    }

    func httpMethod() -> String {
        "POST"
    }

    func body() -> [String: Any]? {
        convertToJSON(managedObject: marker, keyReplacer: ["horizontalAccuracy": "accuracy", "eventDate": "timestamp"])
    }

    func receivedData(data: Data) {
        // nothing to do here
    }

    func additionalHeader() -> [String: String]? {
        guard let deviceId = deviceId else {
            return nil
        }
        return ["X-ATT-DeviceId": deviceId, "Content-Type": "application/json"]
    }
}

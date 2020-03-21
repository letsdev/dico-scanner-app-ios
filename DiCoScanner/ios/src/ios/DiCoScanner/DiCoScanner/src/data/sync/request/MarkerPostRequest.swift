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
        convertToJSON(managedObject: marker, keyReplacer: ["horizontalAlignment": "alignment"])
    }

    func receivedData(data: Data) {
        // nothing to do here
    }
    override func modifyRequest(request: URLRequest) {
        var mutableRequest = request;
        super.modifyRequest(request: mutableRequest)
        if let deviceId = deviceId {
            mutableRequest.addValue(deviceId, forHTTPHeaderField: "X-ATT-DeviceId")
        }
    }


}

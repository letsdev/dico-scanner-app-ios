//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

class CoronaTestPostRequest: BaseRequest, Request {

    private let testResult: CoronaTestResult

    init(testResult: CoronaTestResult) {
        self.testResult = testResult
        super.init()
        setDelegate(delegate: self)
    }

    func url() -> URL {
        URL(string: "\(baseUrl)/test")!
    }

    func httpMethod() -> String {
        "POST"
    }

    func body() -> [String: Any]? {
        convertToJSON(managedObject: testResult)
    }

    func receivedData(data: Data) {
        // nothing to do
    }

    override func modifyRequest(request: URLRequest) {
        var mutableRequest = request;
        super.modifyRequest(request: mutableRequest)
        if let deviceId = deviceId {
            mutableRequest.addValue(deviceId, forHTTPHeaderField: "X-ATT-DeviceId")
        }
    }

}

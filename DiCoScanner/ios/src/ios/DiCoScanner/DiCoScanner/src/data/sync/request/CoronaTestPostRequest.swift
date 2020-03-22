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
        URL(string: "\(baseUrl)/test/sendResult")!
    }

    func httpMethod() -> String {
        "POST"
    }

    func body() -> [String: Any]? {
        convertToJSON(managedObject: testResult, keyReplacer: ["testDate": "timestamp"])
    }

    func receivedData(data: Data) {
        // nothing to do
    }

    func additionalHeader() -> [String: String]? {
        guard let deviceId = deviceId else {
            return nil
        }
        return ["X-ATT-DeviceId": deviceId, "Content-Type": "application/json"]
    }
}

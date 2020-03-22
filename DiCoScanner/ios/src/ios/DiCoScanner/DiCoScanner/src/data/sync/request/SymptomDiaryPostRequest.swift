//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import os

class SymptomDiaryPostRequest: BaseRequest, Request {

    private let symptomDiary: SymptomDiaryEntry

    init(symptomDiary: SymptomDiaryEntry) {
        self.symptomDiary = symptomDiary
        super.init()
        setDelegate(delegate: self)
    }

    func url() -> URL {
        URL(string: "\(baseUrl)/rest/symptomDiary")!
    }

    func httpMethod() -> String {
        "POST"
    }

    func body() -> [String: Any]? {
        convertToJSON(managedObject: symptomDiary,
                keyReplacer: ["entryDate": "timestamp", "name": "nameDe"], keyInjector: { key, value in
            if (key == "uuid") {
                var dict: [String: Any] = [:]
                if let id = value as? String {
                    dict["id"] = Int(id)
                }
                return dict
            }
            return nil
        })
    }

    func additionalHeader() -> [String: String]? {
        guard let deviceId = deviceId else {
            return nil
        }
        return ["X-ATT-DeviceId": deviceId, "Content-Type": "application/json"]
    }

    func receivedData(data: Data) {
        os_log("Received Data: %@", String(data: data, encoding: .utf8)!)
    }
}

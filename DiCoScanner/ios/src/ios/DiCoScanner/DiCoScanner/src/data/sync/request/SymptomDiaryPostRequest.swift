//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

class SymptomDiaryPostRequest: BaseRequest, Request {

    private let symptomDiary: SymptomDiaryEntry

    init(symptomDiary: SymptomDiaryEntry) {
        self.symptomDiary = symptomDiary
        super.init()
    }

    func url() -> URL {
        URL(string: "\(baseUrl)/rest/symptoms")!
    }

    func httpMethod() -> String {
        "POST"
    }

    func body() -> [String: Any]? {
        convertToJSON(managedObject: symptomDiary,
                keyReplacer: ["entryDate": "timestamp", "name": "name_de", "uuid": "id"])
    }

    func additionalHeader() -> [String: String]? {
        guard let deviceId = deviceId else {
            return nil
        }
        return ["X-ATT-DeviceId": deviceId]
    }

    func receivedData(data: Data) {
    }
}

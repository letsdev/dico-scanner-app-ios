//
//  DiCoScanner
//
//  Created by Arne Fischer on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreData
import CFNetwork
import os

protocol Request {
    func url() -> URL
    func httpMethod() -> String
    func body() -> [String: Any]?
    func receivedData(data: Data)
}

let baseUrl = "http://extern-server1.letsdev.de/coscan"

let defaultRequestSession: URLSession = {
    let urlSession = URLSession(configuration: .default)
    // TODO session config
    return urlSession
}()

class BaseRequest {

    internal lazy var deviceId: String? = {
        #if targetEnvironment(simulator)
        return UUID().uuidString
        #else
        return LDPPush.sharedInstance().currentPushConfig.getDeviceId()
        #endif
    }()

    private var requestDelegate: Request!
    private var dataTask: URLSessionDataTask? = nil
    private lazy var request: URLRequest = URLRequest(url: requestDelegate.url())

    internal func setDelegate(delegate: Request) {
        requestDelegate = delegate
    }

    var data: NSMutableData = NSMutableData()

    internal func modifyRequest(request: URLRequest) {
    }

    internal func send(completion: @escaping (Bool) -> Void) {

        request.httpMethod = requestDelegate.httpMethod()

        if let body = requestDelegate.body() {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                let nserror = error as NSError
                fatalError("Can't parso to json: Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }

        modifyRequest(request: request)

        dataTask = defaultRequestSession.dataTask(with: request) { [weak self] data, response, error in
            let success = error == nil
            if let error = error {
                os_log("Error in request: %@", error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                os_log("Successful %i request: %@", response.statusCode, response)
            }
            if let data = data, let strongSelf = self {
                strongSelf.requestDelegate.receivedData(data: data)
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
        dataTask?.resume()
    }

    // todo move into util
    internal func convertToJSON(managedObject: NSManagedObject) -> [String: Any] {
        convertToJSON(managedObject: managedObject, keyReplacer: nil)
    }

    internal func convertToJSON(managedObject: NSManagedObject, keyReplacer: [String: String]?) -> [String: Any] {
        var jsonDict: [String: Any] = [:]
        for attribute in managedObject.entity.attributesByName {
            if let value = managedObject.value(forKey: attribute.key) {
                var key = attribute.key

                // replace the attribute key name with a different key in json
                if keyReplacer != nil && keyReplacer?.keys.contains(key) ?? false {
                    key = keyReplacer![key]!
                }

                if let value = value as? Date {
                    let formatter = ISO8601DateFormatter()
                    let string = formatter.string(from: value)
                    jsonDict[key] = string
                } else {
                    jsonDict[key] = value
                }
            }
        }
        return jsonDict
    }
}

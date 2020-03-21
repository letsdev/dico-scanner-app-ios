//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import CoreData
import CFNetwork
import os

protocol Request {
    func url() -> URL
    func httpMethod() -> String
    func body() -> [String: Any]?
}

let defaultRequestSession: URLSession = {
    let urlSession = URLSession(configuration: .default)
    // TODO session config
    return urlSession
}()

class BaseRequest {

    var requestDelegate: Request!
    var dataTask: URLSessionDataTask? = nil
    lazy var request: URLRequest = URLRequest(url: requestDelegate.url())

    internal func setDelegate(delegate: Request) {
        requestDelegate = delegate
    }

    var data: NSMutableData = NSMutableData()

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

        dataTask = defaultRequestSession.dataTask(with: request) { data, response, error in
            let success = error == nil
            if let error = error {
                os_log("Error in request: %@", error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                os_log("Successful %i request: %@", response.statusCode, response)
            }
            DispatchQueue.main.async {
                completion(success)
            }
        }
        dataTask?.resume()
    }
}

//
// Created by Sebastian Ruf on 20.03.20.
// Copyright (c) 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreLocation
import os

class LocationProvider: NSObject {

    private let manager = CLLocationManager()
    var delegate: LocationProviderDelegate?

    override init() {
        super.init()
        manager.delegate = self
    }

    func currentLocation() {
        guard CLLocationManager.authorizationStatus() != .authorizedWhenInUse else {
            manager.requestWhenInUseAuthorization()
            return
        }

        manager.requestLocation()
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            os_log("No location received")
            return
        }

        delegate?.received(location: lastLocation)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("Did fail with error: %@", error.localizedDescription)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied {
            manager.requestLocation()
        }
    }
}

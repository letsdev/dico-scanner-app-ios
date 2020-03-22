//
// Created by Sebastian Ruf on 20.03.20.
// Copyright (c) 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreLocation
import os

class LocationProvider: NSObject {

    public enum LocationMode {
        case undefined
        case marker
        case map
    }

    private let manager = CLLocationManager()
    var delegate: LocationProviderDelegate?

    private var locationMode: LocationMode = .undefined

    override init() {
        super.init()
        manager.delegate = self
    }

    func fetchLocation(mode: LocationMode) {
        locationMode = mode
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            manager.requestWhenInUseAuthorization()
            return
        }

        manager.requestLocation()
        delegate?.didStartLocationUpdate(locationMode: locationMode)
    }
}

extension LocationProvider: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            os_log("No location received")
            return
        }

        delegate?.didReceiveLocationUpdate(location: lastLocation, locationMode: locationMode)
        locationMode = .undefined
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("Did fail with error: %@", error.localizedDescription)
        delegate?.didFailLocationUpdate(error, locationMode: locationMode)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied {
            delegate?.didGrantAuthorization(locationMode: locationMode)
        }
    }
}

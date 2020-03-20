//
//  MarkerViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 20.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit
import CoreLocation
import os

class MarkerViewController: UIViewController {

    @IBOutlet weak var markButton: UIButton!

    private let locationProvider = LocationProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Markierungen"

        locationProvider.delegate = self

        markButton.titleLabel?.text = "Markierung setzen"
    }

    @IBAction func markButtonTapped(_ sender: Any) {
        locationProvider.currentLocation()
    }
}

extension MarkerViewController: LocationProviderDelegate {
    func received(location: CLLocation) {
        os_log("Received location long/lat: %d / %d", location.coordinate.latitude.description,
                location.coordinate.longitude.binade.description)
    }
}

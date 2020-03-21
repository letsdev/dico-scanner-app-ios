//
// Created by Sebastian Ruf on 20.03.20.
// Copyright (c) 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProviderDelegate {
    func received(location: CLLocation)
}

//
//  Marker+UiModel.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 21.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

extension Marker {

    func coordinatesString() -> String {
        coordinateToDMS(latitude: self.lat, longitude: self.lon)
    }

    private func coordinateToDMS(latitude: Double, longitude: Double) -> String {
        let latDegrees = abs(Int(latitude))
        let latMinutes = abs(Int((latitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let latSeconds = Double(
                abs((latitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))

        let lonDegrees = abs(Int(longitude))
        let lonMinutes = abs(Int((longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60))
        let lonSeconds = Double(
                abs((longitude * 3600).truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))

        return (String(format: "%@%d° %d' %.4f\"", latitude >= 0 ? "N" : "S", latDegrees, latMinutes, latSeconds) + " " +
                String(format: "%@%d° %d' %.4f\"", longitude >= 0 ? "E" : "W", lonDegrees, lonMinutes, lonSeconds))
    }
}

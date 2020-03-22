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
    
    func lastUpdateString() -> String {
        if let date = self.eventDate {
            switch (-date.timeIntervalSinceNow) {
            case 0...120:
                return "Dein Standort wurde gerade getrackt."
            case 121...(60*60):
                let minutes = String(format: "%.0f", -date.timeIntervalSinceNow / 60)
                return "Dein Standort wurde vor \(minutes) Minuten getrackt."
            default:
                return "Dein Standort wurde zuletzt am \(DateFormatter.localizedString(for: date)) getrackt."
            }
        } else {
            return "Dein Standort wurde noch nicht getrackt."
        }
    }
}

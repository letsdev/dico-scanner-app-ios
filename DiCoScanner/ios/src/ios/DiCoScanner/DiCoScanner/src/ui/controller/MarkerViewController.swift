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
import MapKit

class MarkerViewController: UIViewController {

    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var markButtonContainerView: UIView!
    @IBOutlet weak var lastMarkerView: UIView!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var lastMakerViewHeightConstraint: NSLayoutConstraint!

    private var buttonStateController: ButtonStateController?

    private let lastMarkVC = LastMarkerViewController()

    private var minHeightMarkButton: CGFloat {
        get {
            markButton.frame.height + 40
        }
    }
    private var minHeightLastMarkerView: CGFloat {
        get {
            lastMarkVC.lastMarkerHeaderView.frame.height
        }
    }
    private static let animationDuration: TimeInterval = 0.2

    private var locationProvider: LocationProvider?

    private let markerDao = MarkerDao()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Markierungen"

        locationProvider = LocationProvider()
        locationProvider?.delegate = self

        locationProvider?.fetchLocation(mode: .map)

        mapKitView.setVisibleMapRect(MKMapRect(x: 0, y: 0, width: 25000, height: 25000), animated: true)

        lastMarkVC.view.frame = lastMarkerView.bounds
        lastMarkerView.addSubview(lastMarkVC.view)
        NSLayoutConstraint.activate([
            lastMarkVC.view.leadingAnchor.constraint(equalTo: lastMarkerView.leadingAnchor),
            lastMarkVC.view.trailingAnchor.constraint(equalTo: lastMarkerView.trailingAnchor),
            lastMarkVC.view.topAnchor.constraint(equalTo: lastMarkerView.topAnchor),
            lastMarkVC.view.bottomAnchor.constraint(lessThanOrEqualTo: lastMarkerView.bottomAnchor)
        ])

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MarkerViewController.draggedView(_:)))
        lastMarkVC.lastMarkerHeaderView.isUserInteractionEnabled = true
        lastMarkVC.lastMarkerHeaderView.addGestureRecognizer(panGesture)

        buttonStateController = ButtonStateController(button: markButton)
    }

    @IBAction func markButtonTapped(_ sender: Any) {
        locationProvider?.fetchLocation(mode: .marker)
    }

    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        handleViewDragging(sender: sender)
    }

    private func saveAndSyncLocation(location: CLLocation) {
        let marker = markerDao.newEntity()
        marker.eventDate = Date()
        marker.lat = location.coordinate.latitude
        marker.lon = location.coordinate.longitude
        marker.altitude = location.altitude
        marker.horizontalAccuracy = location.horizontalAccuracy
        marker.verticalAccuracy = location.verticalAccuracy

        DatabaseManager.shared.saveContext()
        markerDao.markObjectForSync(object: marker)
    }
}

extension MarkerViewController: LocationProviderDelegate {
    func didReceiveLocationUpdate(location: CLLocation, locationMode: LocationProvider.LocationMode) {
        if locationMode == .marker {
            saveAndSyncLocation(location: location)
            lastMarkVC.reloadData()
            buttonStateController?.setButtonAnimation(state: .success)
        } else if locationMode == .map {
            mapKitView.setCenter(location.coordinate, animated: true)
        }
    }

    func didGrantAuthorization(locationMode: LocationProvider.LocationMode) {
        buttonStateController?.setButtonAnimation(state: .normal)
        locationProvider?.fetchLocation(mode: .map)
    }

    func didStartLocationUpdate(locationMode: LocationProvider.LocationMode) {
        if locationMode == .marker {
            buttonStateController?.setButtonAnimation(state: .progress)
        }
    }

    func didFailLocationUpdate(_: Error, locationMode: LocationProvider.LocationMode) {
        if locationMode == .marker {
            buttonStateController?.setButtonAnimation(state: .failure)
        }
    }
}

extension MarkerViewController {
    private func handleViewDragging(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let newHeightMakerView = lastMakerViewHeightConstraint.constant - translation.y
        let newHeightMarkButton = markButtonContainerView.frame.height + translation.y

        if newHeightMarkButton >= minHeightMarkButton && newHeightMakerView >= lastMarkVC.lastMarkerHeaderView.frame.height {
            lastMakerViewHeightConstraint.constant -= translation.y
        }

        sender.setTranslation(CGPoint.zero, in: self.view)

        if sender.state == .ended {
            scrollToRestingPosition(sender: sender)
        }
    }

    private func scrollToRestingPosition(sender: UIPanGestureRecognizer) {
        let velocity: CGPoint = sender.velocity(in: self.view)
        let scrollingHeight = determineRestingPosition(velocity: velocity)
        self.lastMakerViewHeightConstraint.constant = scrollingHeight
        UIView.animate(withDuration: MarkerViewController.animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }

    private func determineRestingPosition(velocity: CGPoint) -> CGFloat {
        if velocity.y > 0 {
            return lastMarkVC.lastMarkerHeaderView.bounds.height
        } else {
            return self.view.safeAreaLayoutGuide.layoutFrame.height - minHeightMarkButton
        }
    }
}
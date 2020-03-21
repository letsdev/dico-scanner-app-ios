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
    @IBOutlet weak var lastMarkerView: UIView!
    @IBOutlet weak var mapKitView: MKMapView!

    @IBOutlet weak var lastMakerViewHeightConstraint: NSLayoutConstraint!

    private let lastMarkVC = LastMarkerViewController()

    private let minHeightMarkButton: CGFloat = 250
    private let minHeightLastMarkerView: CGFloat = 100 // TODO: Fix it
    private static let animationDuration: TimeInterval = 0.2
    private static let animationDurationButton: TimeInterval = 0.5

    private let locationProvider = LocationProvider()

    private let markerDao = MarkerDao()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Markierungen"

        locationProvider.delegate = self

        mapKitView.setVisibleMapRect(MKMapRect(x: 0, y: 0, width: 25000, height: 25000), animated: true)

        markButton.titleLabel?.text = "Markierung setzen"

        lastMarkerView.addSubview(lastMarkVC.view)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MarkerViewController.draggedView(_:)))
        lastMarkerView.isUserInteractionEnabled = true
        lastMarkerView.addGestureRecognizer(panGesture)

        self.markButton.tintColor = UIColor(named: "AppGreyBackground")
        self.markButton.layer.cornerRadius = 30

        setButtonAnimation(state: .normal)
    }

    @IBAction func markButtonTapped(_ sender: Any) {
        locationProvider.currentLocation()
        self.setButtonAnimation(state: .progress)
    }

    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        handleViewDragging(sender: sender)
    }
}

extension MarkerViewController: LocationProviderDelegate {
    func received(location: CLLocation) {
        mapKitView.setCenter(location.coordinate, animated: true)

        let marker = markerDao.newEntity()
        marker.eventDate = Date()
        marker.lat = location.coordinate.latitude
        marker.lon = location.coordinate.longitude
        marker.altitude = location.altitude
        marker.horizontalAccuracy = location.horizontalAccuracy
        marker.verticalAccuracy = location.verticalAccuracy

        DatabaseManager.shared.saveContext()

        lastMarkVC.lastMarkerTableView.reloadData()

        self.setButtonAnimation(state: .success)
        os_log("Received location long/lat: %d / %d", location.coordinate.latitude.description,
                location.coordinate.longitude.binade.description)
    }
}

extension MarkerViewController {
    private func handleViewDragging(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let newHeightMakerView = lastMakerViewHeightConstraint.constant - translation.y
        let newHeightMarkButton = self.view.bounds.height - newHeightMakerView

        if newHeightMarkButton >= minHeightMarkButton && newHeightMakerView >= minHeightLastMarkerView {
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
            return minHeightLastMarkerView
        } else {
            return self.view.bounds.height - minHeightMarkButton
        }
    }
}

extension MarkerViewController {

    enum ButtonState {
        case normal
        case progress
        case failure
        case success
    }

    private func setButtonAnimation(state: ButtonState) {
        self.markButton.layer.removeAllAnimations()
        switch (state) {
        case .normal:
            buttonNormal()
        case .progress:
            buttonProgress()
        case .success:
            buttonSuccess()
        case .failure:
            buttonFailure()
        }
    }

    private func buttonNormal() {
        self.markButton.alpha = 1
        animateToColor(colorName: "AppDarkBlue")
    }

    private func buttonProgress() {
        // TODO: Use method animateToColor with optional options and completion
        UIView.animate(withDuration: MarkerViewController.animationDurationButton, delay: 0.0,
                animations: {
                    self.markButton.backgroundColor = UIColor(named: "AppOrange")
                }, completion: { b in
            UIView.animate(withDuration: MarkerViewController.animationDurationButton + 0.25, delay: 0.0,
                    options: [.autoreverse, .repeat, .curveEaseInOut, .allowUserInteraction],
                    animations: {
                        self.markButton.alpha = 0.75
                    })
        })
    }

    private func buttonSuccess() {
        self.markButton.alpha = 1
        UIView.animate(withDuration: MarkerViewController.animationDurationButton, delay: 0.0,
                options: [.allowUserInteraction],
                animations: {
                    self.markButton.backgroundColor = UIColor(named: "AppGreen")
                }, completion: { b in

        })
    }

    private func buttonFailure() {
        self.markButton.alpha = 1
        animateToColor(colorName: "AppRed")
    }

    private func animateToColor(colorName: String) {
        UIView.animate(withDuration: MarkerViewController.animationDurationButton, delay: 0.0,
                options: .allowUserInteraction,
                animations: { () -> Void in
                    self.markButton.backgroundColor = UIColor(named: colorName)
                })
    }
}

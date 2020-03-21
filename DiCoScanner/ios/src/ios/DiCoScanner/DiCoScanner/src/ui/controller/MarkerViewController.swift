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
    @IBOutlet weak var lastMarkerView: UIView!

    @IBOutlet weak var lastMakerViewHeightConstraint: NSLayoutConstraint!

    private let lastMarkVC = LastMarkerViewController()

    private let minHeightMarkButton: CGFloat = 250
    private let minHeightLastMarkerView: CGFloat = 100 // TODO: Fix it
    private static let animationDuration: TimeInterval = 0.2

    private let locationProvider = LocationProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Markierungen"

        locationProvider.delegate = self

        markButton.titleLabel?.text = "Markierung setzen"

        lastMarkerView.addSubview(lastMarkVC.view)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MarkerViewController.draggedView(_:)))
        lastMarkerView.isUserInteractionEnabled = true
        lastMarkerView.addGestureRecognizer(panGesture)
    }

    @IBAction func markButtonTapped(_ sender: Any) {
        locationProvider.currentLocation()
    }

    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
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

extension MarkerViewController: LocationProviderDelegate {
    func received(location: CLLocation) {
        os_log("Received location long/lat: %d / %d", location.coordinate.latitude.description,
                location.coordinate.longitude.binade.description)
    }
}

//
// Created by Sebastian Ruf on 22.03.20.
// Copyright (c) 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

class ButtonStateController {

    private static let animationDurationButton: TimeInterval = 0.5

    private let normalColor = "AppDarkBlue45"
    private let progressColor = "AppOrange45"
    private let successColor = "AppGreen45"
    private let failureColor = "AppRed45"
    private let inactiveColor = "AppGreyBackground45"

    private let normalText = "Markierung setzen"
    private let progressText = "Markierung wird gesetzt..."
    private let successText = "Markierung gesetzt"
    private let failureText = "Markierung fehlgeschlagen"
    private let inactiveText = "Ortungsdienst nicht verfügbar"

    enum ButtonState {
        case normal
        case progress
        case failure
        case success
        case inactive
    }

    let markButton: UIButton

    init(button: UIButton) {
        self.markButton = button
        setButtonAnimation(state: .inactive)
    }


    func setButtonAnimation(state: ButtonState) {
        switch (state) {
        case .normal:
            setButtonNormal()
        case .progress:
            setButtonProgress()
        case .success:
            setButtonSuccess()
        case .failure:
            setButtonFailure()
        case .inactive:
            setButtonInactive()
        }
    }

    private func setButtonInactive() {
        self.markButton.isEnabled = false

        animate(colorName: inactiveColor, text: inactiveText)
    }

    private func setButtonNormal() {
        self.markButton.isEnabled = true

        animate(colorName: normalColor, text: normalText)
    }

    private func setButtonProgress() {
        self.markButton.isEnabled = false

        animate(colorName: progressColor, text: progressText)
    }

    private func setButtonSuccess() {
        self.markButton.isEnabled = false

        animate(colorName: successColor, text: successText) { b in
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                self.setButtonAnimation(state: .normal)
            }
        }
    }

    private func setButtonFailure() {
        self.markButton.isEnabled = false

        animate(colorName: failureColor, text: failureText) { b in
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                self.setButtonAnimation(state: .normal)
            }
        }
    }

    private func animate(colorName: String, text: String, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: ButtonStateController.animationDurationButton, delay: 0.0,
                options: .allowUserInteraction, animations: { () -> Void in
            self.markButton.setTitle(text, for: .normal)
            self.markButton.backgroundColor = UIColor(named: colorName)
            self.markButton.layer.borderColor = UIColor(named: colorName)?.cgColor
        }, completion: completion)
    }
}

//
// Created by Fabian Köbel on 21.03.20.
// Copyright (c) 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

protocol PresentedViewControllerDelegate: class {
    func didEndPresentation(presentedViewController: UIViewController)
}
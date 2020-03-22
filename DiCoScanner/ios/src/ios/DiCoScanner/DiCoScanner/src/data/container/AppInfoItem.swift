//
// Created by Fabian Köbel on 22.03.20.
// Copyright (c) 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

class AppInfoItem {
    var identifier: String
    var displayName: String

    init(identifier: String, displayName: String) {
        self.identifier = identifier
        self.displayName = displayName
    }
}

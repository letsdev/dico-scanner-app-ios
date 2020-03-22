//
// Created by Fabian Köbel on 22.03.20.
// Copyright (c) 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import Foundation

class AppInfoItem {
    var identifier: String
    var displayName: String
    var url: String?

    init(identifier: String, displayName: String, url: String? = nil) {
        self.identifier = identifier
        self.displayName = displayName
        self.url = url
    }
}

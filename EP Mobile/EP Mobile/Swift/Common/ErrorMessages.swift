//
//  ErrorMessages.swift
//  EP Mobile
//
//  Created by David Mann on 5/2/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct ErrorMessages {
    static let invalidEntry = "INVALID ENTRY"
    static let outOfRange = "Heart rate or QT interval out of range.\nAllowed heart rates 20-250 bpm.\nAllowed QT intervals 200-800 msec."
    static let shortQrsError = "QRS duration must be at least 120 msec."
    static let calculationError = "CALCULATION ERROR"
}

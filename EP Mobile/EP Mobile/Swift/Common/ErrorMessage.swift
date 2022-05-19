//
//  ErrorMessages.swift
//  EP Mobile
//
//  Created by David Mann on 5/2/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct ErrorMessage {
    static let invalidEntry = "INVALID ENTRY"
    static let outOfRange = "Heart rate or QT interval out of range.\nAllowed heart rates 20-250 bpm.\nAllowed QT intervals 200-800 msec."
    static let shortQrsError = "QRS duration must be at least 120 msec."
    static let longQrsError = "QRS duration must be less than QT duration."
    static let calculationError = "CALCULATION ERROR"
    static let inputError = "One or more values are incorrect or missing."
    static let unknownError = "UNKNOWN ERROR"
    static let ppiTooShort = "PPI less than TCL"
    static let invalidSQrs = "Invalid S-QRS (<TCL) ignored!"
}

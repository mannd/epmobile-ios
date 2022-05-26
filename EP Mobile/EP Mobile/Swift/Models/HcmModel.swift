//
//  HcmModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/23/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum HcmError: Error {
    case invalidEntry
    case ageOutOfRange
    case thicknessOutOfRange
    case laDiameterOutOfRange
    case gradientOutOfRange

    var description: String {
        switch self {
        case .invalidEntry:
            return ErrorMessage.invalidEntry
        case .ageOutOfRange:
            return "Age must be between 16 and 115 years."
        case .thicknessOutOfRange:
            return "Maximum LV wall thickness must be between 10 and 35 mm."
        case .laDiameterOutOfRange:
            return "Maximum LA diameter must be between 28 and 67 mm."
        case .gradientOutOfRange:
            return "Maximum LV outflow tract gradient must be between 2 and 15.4 mmHg"
        }
    }
}

struct HcmModel {
    var age: Double
    var thickness: Double
    var laDiameter: Double
    var gradient: Double
    var familyHxScd: Bool
    var hxNsvt: Bool
    var hxSyncope: Bool

    func calculate() throws -> Double {
        guard age > 0 && thickness > 0 && laDiameter > 0 && gradient > 0 else {
            throw HcmError.invalidEntry
        }
        guard age <= 115 && age >= 16 else {
            throw HcmError.ageOutOfRange
        }
        guard thickness >= 10 && thickness <= 35 else {
            throw HcmError.thicknessOutOfRange
        }
        guard laDiameter >= 28 && laDiameter <= 67 else {
            throw HcmError.laDiameterOutOfRange
        }
        guard gradient >= 2 && gradient <= 154 else {
            throw HcmError.gradientOutOfRange
        }

        // Also, this expression is broken up to avoid parsing errors from the compiler.
        // When the expression was a single line, build would get stuck.
        let coefficient = 0.998
        var prognosticIndex = (0.15939858 * thickness) - (0.00294271 * thickness * thickness)
        prognosticIndex +=  (0.0259082 * laDiameter) + (0.00446131 * gradient)
        prognosticIndex += (familyHxScd ? 0.4583082 : 0.0)
        prognosticIndex += (hxNsvt ? 0.82639195 : 0.0)
        prognosticIndex += (hxSyncope ? 0.71650361 : 0.0) - 0.01799934 * age
        let scdProb = 1 - pow(coefficient, exp(prognosticIndex))
        return scdProb
    }
}

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
}

struct HcmModel {
    var age: Int
    var thickness: Int
    var laDiameter: Int
    var gradient: Int
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
        guard thickness >= 10 && thickness < 35 else {
            throw HcmError.thicknessOutOfRange
        }
        guard laDiameter >= 28 && laDiameter <= 67 else {
            throw HcmError.laDiameterOutOfRange
        }
        guard gradient >= 2 && gradient <= 154 else {
            throw HcmError.gradientOutOfRange
        }

        let coefficient = 0.998
        let prognosticIndex = 0.15939858 * thickness
            - 0.00294271 * thickness * thickness
            + 0.0259082 * laDiameter
            + 0.00446131 * gradient
            + (familyHxScd ? 0.4583082 : 0.0)
            + (hxNsvt ? 0.82639195 : 0.0)
            + (hxSyncope ? 0.71650361 : 0.0)
            - 0.01799934 * age
        let scdProb = 1 - pow(coefficient, exp(prognosticIndex));
        return scdProb
    }
}

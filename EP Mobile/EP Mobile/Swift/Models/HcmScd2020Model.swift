//
//  HcmScd2020Model.swift
//  EP Mobile
//
//  Created by David Mann on 10/19/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

enum HcmScd2020Error: Error {
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
            return "Maximum LV outflow tract gradient must be between 2 and 154 mmHg"
        }
    }
}

struct HcmScd2020Model: InformationProvider {
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

    static func getReferences() -> [Reference] {
        return [
            Reference("O’Mahony C, Jichi F, Pavlou M, et al. A novel clinical risk prediction model for sudden cardiac death in hypertrophic cardiomyopathy (HCM Risk-SCD). European Heart Journal. 2014;35(30):2010-2020. doi:10.1093/eurheartj/eht439"),
            Reference("2014 ESC Guidelines on diagnosis and management of hypertrophic cardiomyopathy: The Task Force for the Diagnosis and Management of Hypertrophic Cardiomyopathy of the European Society of Cardiology (ESC). Eur Heart J. 2014;35(39):2733-2779. doi:10.1093/eurheartj/ehu284")]
    }

    static func getInstructions() -> String? {
        return "Do not use this risk calculator for pediatric patients (<16), elite competitive athletes, HCM associated with metabolic syndromes, or patients with aborted SCD or sustained ventricular arrhythmias."
    }

    static func getKey() -> String? {
        return "HCM = hypertrophic cardiomyopathy.\n\nAge = age at evaluation.\n\nWall thickness = maximum left ventricular wall thickness. Note all echo measurements via transthoracic echo.\n\nLA (left atrial) diameter measured in parasternal long axis.\n\nGradient = maximum left ventricular outflow tract gradient determined at rest and with Valsalva using pulsed and continuous wave Doppler from the apical 3 and 5 chamber views. Peak outflow gradients determined by the modified Bernoulli equation:"

    }

}

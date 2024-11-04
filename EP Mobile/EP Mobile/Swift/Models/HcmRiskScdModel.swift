//
//  HcmRiskScdModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/23/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum HcmRiskScdError: Error {
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

struct HcmRiskScdModel: InformationProvider {
    var age: Double
    var thickness: Double
    var laDiameter: Double
    var gradient: Double
    var familyHxScd: Bool
    var hxNsvt: Bool
    var hxSyncope: Bool

    static let ageDescription: String = "Age at evaluation."
    static let thicknessDescription: String = "The greatest thickness in the anterior septum, posterior septum, lateral wall, and posterior wall of the LV, measured at the level of the mitral valve, papillary muscles, and apex using parasternal short-axis plane using 2-D echocardiography at time of evaluation."
    static let laDiameterDescription: String = "Left atrial diameter determined by M-Mode or 2D echocardiography in the parasternal long axis plane at time of evaluation."
    static let gradientDescription: String = "The maximum LV outflow gradient determined at rest and with Valsalva provocation (irrespective of concurrent medical treatment) using pulsed and continuous wave Doppler from the apical three- and five-chamber views."
    static let familyHxScdDescription: String = "History of sudden cardiac death in 1 or more first degree relatives under 40 years of age or SCD in a first degree relative with confirmed HCM at any age (post- or ante-mortem diagnosis)."
    static let hxNsvtDescription: String = "≥3 consecutive ventricular beats at a rate of ≥120 bpm and ,30 s in duration on Holter monitoring (minimum duration 24 hours) at or prior to evaluation."
    static let hxSyncopeDescription: String = "History of unexplained syncope at or prior to evaluation."


    func calculate() throws -> Double {
        guard age > 0 && thickness > 0 && laDiameter > 0 && gradient > 0 else {
            throw HcmRiskScdError.invalidEntry
        }
        guard age <= 115 && age >= 16 else {
            throw HcmRiskScdError.ageOutOfRange
        }
        guard thickness >= 10 && thickness <= 35 else {
            throw HcmRiskScdError.thicknessOutOfRange
        }
        guard laDiameter >= 28 && laDiameter <= 67 else {
            throw HcmRiskScdError.laDiameterOutOfRange
        }
        guard gradient >= 2 && gradient <= 154 else {
            throw HcmRiskScdError.gradientOutOfRange
        }
        // Note, this expression is broken up to avoid parsing errors from the compiler.
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
        return "Do not use this risk calculator for pediatric patients (<16), elite competitive athletes, HCM associated with metabolic syndromes, or patients with aborted SCD or sustained ventricular arrhythmias.\n\nNote that the ICD implantation recommendations of this risk calculator have been supplanted by more recent guidelines.  See the HCM SCD calculators from 2022 and 2024 included in this app."
    }

    static func getKey() -> String? {
        return "HCM = hypertrophic cardiomyopathy.\n\nHx = history\n\nICD = implantable cardioverter defibrillator.\n\nLA = left atrium.\n\nLV = left ventricle.\n\nNSVT = nonsustained ventricular tachycardia.\n\nSCD = sudden cardiac death."

    }

}

//
//  DoseMath.swift
//  EP Mobile
//
//  Created by David Mann on 4/25/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum Sex: Int, CaseIterable, Identifiable, Equatable {
    case male
    case female

    var id: Sex { self }
    var description: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}

enum Race: Int, CaseIterable, Identifiable, Equatable {
    case nonblack
    case black

    var id: Race { self }
    var description: String {
        switch self {
        case .black:
            return "Black"
        case .nonblack:
            return "Non-black"
        }
    }
}

enum CrClFormula: Int, CaseIterable, Identifiable, Equatable {
    case cockcroftGault
    case ckdEpi
    // consider add other formulas in future

    var id: CrClFormula { self }
    var description: String {
        switch self {
        case .cockcroftGault:
            return "Cockcroft-Gault"
        case .ckdEpi:
            return "CKD-EPI"
        }
    }
}

enum DoseError: Error {
    case ageTooLow
    case weightTooLow
    case creatinineTooLow
    case pediatricAge
}


final class Patient {
    var age: Int
    var sex: Sex
    var race: Race
    var weightKg: Double
    var creatinineMgDL: Double


    /// Ages **below** this cutoff are considered pediatric age group.  Cockcroft-Gault formula valid for age >= 12.
    static let pediatricAgeCutoff = 12

    static let crClNotes = "This calculator uses the Cockcroft-Gault formula, which is the recommended formula for calculating creatinine clearance for determining drug doses.  You can consider using the Weight Calculator to adjust body weight for determining creatinine clearance.\n\nIf you wish to calculate a normalized GFR to estimate renal function, use the GFR Calculator instead"

    static let gfrNotes = "Use this calculator to estimate glomerular filtration rate normalized for estimated body surface area.  If you want to estimate creatinine clearance for determining drug dosing, use the Creatinine Clearance Calculator. \n\nThis calculator uses the CKD-EPI equation."

    static func getCrClReferences() -> [Reference] {
        let reference = Reference("Cockcroft DW, Gault H. Prediction of Creatinine Clearance from Serum Creatinine. NEF. 1976;16(1):31-41.\ndoi:10.1159/000180580")
        return [reference]
    }

    static func getGfrReferences() -> [Reference] {
        let reference = Reference("Levey AS, Stevens LA, Schmid CH, et al. A new equation to estimate glomerular filtration rate. Ann Intern Med. 2009;150(9):604-612. doi:10.7326/0003-4819-150-9-200905050-00006")
        return [reference]
    }

    static func getGfrInstructions() -> String {
        return "Use this calculator to estimate glomerular filtration rate normalized for estimated body surface area.  If you want to estimate creatinine clearance for determining drug dosing, use the Creatinine Clearance Calculator. \n\nThis calculator uses the CKD-EPI equation."
    }

    init(
        age: Int,
        sex: Sex,
        race: Race = .nonblack,
        weightKg: Double,
        creatinineMgDL: Double,
        requireWeight: Bool
    ) throws {
        guard age > 0 else {
            throw DoseError.ageTooLow
        }
        if requireWeight {
            guard weightKg > 10 else {
                throw DoseError.weightTooLow
            }
        }
        guard creatinineMgDL > 0 else {
            throw DoseError.creatinineTooLow
        }
        guard age >= Self.pediatricAgeCutoff else {
            throw DoseError.pediatricAge
        }
        self.age = age
        self.sex = sex
        self.race = race
        self.weightKg = weightKg
        self.creatinineMgDL = creatinineMgDL
    }

    convenience init(
        age: Int,
        sex: Sex,
        race: Race = .nonblack,
        weight: Double,
        massUnits: MassUnit,
        creatinine: Double,
        concentrationUnits: ConcentrationUnit,
        requiresWeight: Bool = true
    ) throws {
        var convertedWeight = weight
        if massUnits == .lb {
            convertedWeight = MassUnit.lbToKg(weight)
        }
        var convertedCr = creatinine
        if concentrationUnits == .mmolL {
            convertedCr = ConcentrationUnit.mmolLToMgDL(convertedCr)
        }
        try self.init(age: age, sex: sex, race: race, weightKg: convertedWeight, creatinineMgDL: convertedCr, requireWeight: requiresWeight)
    }

    // Cockcroft-Gault formula
    // CrCl = (140−Age) * WeightKg [* 0.85(if female)] / 72 * SCr
    lazy var crCl: Double = {
        var crCl = ((140.0 - Double(age)) * weightKg) / (72.0 * creatinineMgDL)
        if sex == .female {
            crCl *= 0.85
        }
        return crCl
    }()

    // GFR CKD-EPI
    // GFR = 141 * min(Scr/kappa,1)^alpha  * max(Scr/kappa,1)^-1.209
    //  * 0.993^Age * 1.018 [if female] * 1.159 [if black],
    //  where Scr is serum creatinine, kappa is 0.7 for females and 0.9 for males,
    //  alpha is -0.329 for females and -0.411 for males, min indicates the minimum of Scr/kappa or 1,
    //  and max indicates the maximum of Scr/kappa or 1.
    lazy var gfr: Double = {
        let isMale = (sex == .male)
        let kappa: Double = isMale ? 0.9 : 0.7
        let alpha: Double = isMale ? -0.411 : -0.329
        let minCr: Double = min(creatinineMgDL / kappa, 1.0)
        let maxCr: Double = max(creatinineMgDL / kappa, 1.0)
        var gfr: Double = 141.0 * pow(minCr, alpha) * pow(maxCr, -1.209) * pow(0.993, Double(age))
        if (!isMale) {
            gfr *= 1.018
        }
        if (race == .black) {
            gfr *= 1.159;
        }
        return gfr;
    }()

    func crClResult() -> String {
        let roundedCrCl = Int(round(crCl))
        return  "Creatinine clearance = \(roundedCrCl) mL/min"
    }

    func gfrResult() -> String {
        let roundedGfr = Int(round(gfr))
        return  "GFR = \(roundedGfr) ml/min/1.73m\u{00b2}"
    }
}

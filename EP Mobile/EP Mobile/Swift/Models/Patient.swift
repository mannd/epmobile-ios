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


enum CrClFormula: Int, CaseIterable, Identifiable, Equatable {
    case cockcroftGault
    // consider add other formulas in future
    var id: CrClFormula { self }
    var description: String {
        switch self {
        case .cockcroftGault:
            return "Cockcroft-Gault"
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
    var weightKg: Double
    var creatinineMgDL: Double

    /// Ages **below** this cutoff are considered pediatric age group.  Cockcroft-Gault formula valid for age >= 12.
    static let pediatricAgeCutoff = 12

    static let crClNotes = "This calculator uses the Cockcroft-Gault formula, which is the recommended formula for calculating creatinine clearance for determining drug doses.  You can consider using the Weight Calculator to adjust body weight for determining creatinine clearance.\n\nIf you wish to calculate a normalized GFR to estimate renal function, use the GFR Calculator instead"

    static func getCrClReferences() -> [Reference] {
        let reference = Reference("Cockcroft DW, Gault H. Prediction of Creatinine Clearance from Serum Creatinine. NEF. 1976;16(1):31-41.\ndoi:10.1159/000180580")
        return [reference]
    }

    init(
        age: Int,
        sex: Sex,
        weightKg: Double,
        creatinineMgDL: Double
    ) throws {
        guard age > 0 else {
            throw DoseError.ageTooLow
        }
        guard weightKg > 10 else {
            throw DoseError.weightTooLow
        }
        guard creatinineMgDL > 0 else {
            throw DoseError.creatinineTooLow
        }
        guard age >= Self.pediatricAgeCutoff else {
            throw DoseError.pediatricAge
        }
        self.age = age
        self.sex = sex
        self.weightKg = weightKg
        self.creatinineMgDL = creatinineMgDL
    }

    convenience init(
        age: Int,
        sex: Sex,
        weight: Double,
        massUnits: MassUnit,
        creatinine: Double,
        concentrationUnits: ConcentrationUnit
    ) throws {
        var convertedWeight = weight
        if massUnits == .lb {
            convertedWeight = MassUnit.lbToKg(weight)
        }
        var convertedCr = creatinine
        if concentrationUnits == .mmolL {
            convertedCr = ConcentrationUnit.mmolLToMgDL(convertedCr)
        }
        try self.init(age: age, sex: sex, weightKg: convertedWeight, creatinineMgDL: convertedCr)
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

    func crCl(concentrationUnit: ConcentrationUnit) -> Double {
        switch concentrationUnit {
        case .mgDL:
            return crCl
        case .mmolL:
            return ConcentrationUnit.mgDLToMmolL(crCl)
        }
    }

    func crClResult(concentrationUnit: ConcentrationUnit) -> String {
        let roundedCrCl = Int(round(crCl(concentrationUnit: concentrationUnit)))
        return  "Creatinine clearance = \(roundedCrCl) mL/min"
    }
}

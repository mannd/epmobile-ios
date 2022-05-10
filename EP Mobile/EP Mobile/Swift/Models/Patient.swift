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
    case creatinineIsZero
    case weightTooLow
    case creatinineTooLow
    case pediatricAge
}


final class Patient {
    var age: Int
    var sex: Sex
    var weightKg: Double
    var creatinineMgDL: Double

    // ? throwable init or init?()
    init(
        age: Int,
        sex: Sex,
        weightKg: Double,
        creatinineMgDL: Double
    ) throws {
        guard age > 0 else {
            throw DoseError.ageTooLow
        }
        guard creatinineMgDL > 0 else {
            throw DoseError.creatinineIsZero
        }
        guard weightKg > 10 else {
            throw DoseError.weightTooLow
        }
        guard creatinineMgDL > 0 else {
            throw DoseError.creatinineTooLow
        }
        // TODO: original EP Mobile drug calculator was for 18 and over.
        guard age > 12 else {
            throw DoseError.pediatricAge
        }
        self.age = age
        self.sex = sex
        self.weightKg = weightKg
        self.creatinineMgDL = creatinineMgDL
    }

    // failable init -- might be all needed for error handling
    // rather than throwing errors.
    //    init?(
//        age: Double,
//        sex: Sex,
//        weightKg: Double,
//        creatinineMgDL: Double
//    ) {
//        guard creatinineMgDL > 0 else {
//            return nil
//        }
//        self.age = age
//        self.sex = sex
//        self.weightKg = weightKg
//        self.creatinineMgDL = creatinineMgDL
//    }

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

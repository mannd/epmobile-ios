//
//  DoseMath.swift
//  EP Mobile
//
//  Created by David Mann on 4/25/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum Sex {
    case male
    case female
}

enum MassUnits {
    case kg
    case lb

    private static let lbToKgConversionFactor = 0.45359237

    static func lbToKg(_ weightInLb: Double) -> Double {
        return weightInLb * Self.lbToKgConversionFactor
    }

    static func kgToLb(_ weightInKg: Double) -> Double {
        return weightInKg / Self.lbToKgConversionFactor
    }
}

enum ConcentrationUnits {
    case mgDL
    case mmolL

    private static let conversionFactor = 88.42

    static func mgDLToMmolL(_ mgDL: Double) -> Double {
        return mgDL * conversionFactor
    }

    static func mmolLToMgDL(_ mmolL: Double) -> Double {
        return mmolL / conversionFactor
    }
}

enum CrClFormula {
    case cockcroftGault
    // consider add other formulas in future
}

enum DoseError: Error {
    case creatinineIsZero
}

final class DoseMath {
    var age: Double
    var sex: Sex
    var weightKg: Double
    var creatinineMgDL: Double

    // ? throwable init or init?()
    init(
        age: Double,
        sex: Sex,
        weightKg: Double,
        creatinineMgDL: Double
    ) throws {
        guard creatinineMgDL > 0 else {
            throw DoseError.creatinineIsZero
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
        age: Double,
        sex: Sex,
        weight: Double,
        massUnits: MassUnits,
        creatinine: Double,
        concentrationUnits: ConcentrationUnits
    ) throws {
        var convertedWeight = weight
        if massUnits == .lb {
            convertedWeight = MassUnits.lbToKg(weight)
        }
        var convertedCr = creatinine
        if concentrationUnits == .mmolL {
            convertedCr = ConcentrationUnits.mmolLToMgDL(convertedCr)
        }
        try self.init(age: age, sex: sex, weightKg: convertedWeight, creatinineMgDL: convertedCr)
    }

    // Cockcroft-Gault formula
    // CrCl = (140−Age) * WeightKg [* 0.85(if female)] / 72 * SCr
    func creatinineClearance() -> Int {
        var crCl = ((140.0 - age) * weightKg) / (72.0 * creatinineMgDL)
        if sex == .female {
            crCl *= 0.85
        }
        // Don't allow crCl < 1
        return Int(round(crCl < 1 ? 1 : crCl))
    }




}

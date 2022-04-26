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

enum MassUnit {
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

enum ConcentrationUnit {
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


final class Patient {
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

//    // Cockcroft-Gault formula
//    // CrCl = (140−Age) * WeightKg [* 0.85(if female)] / 72 * SCr
//    func creatinineClearance() -> Int {
//        var crCl = ((140.0 - age) * weightKg) / (72.0 * creatinineMgDL)
//        if sex == .female {
//            crCl *= 0.85
//        }
//        // Don't allow crCl < 1
//        return Int(round(crCl < 1 ? 1 : crCl))
//    }

    // Cockcroft-Gault formula
    // CrCl = (140−Age) * WeightKg [* 0.85(if female)] / 72 * SCr
    lazy var crCl: Int = {
        var crCl = ((140.0 - age) * weightKg) / (72.0 * creatinineMgDL)
        if sex == .female {
            crCl *= 0.85
        }
        // Don't allow crCl < 1
        return Int(round(crCl < 1 ? 1 : crCl))
    }()
    // need more than just crCl for Apixaban dosing
//    - (NSString *)getDose:(int)crCl forWeightInKgs:(double)weight forCreatinine:(double)creatinine forAge:(double)age {
//        int dose;
//        NSString *message = [[NSString alloc] init];
//        if ([drug isEqualToString:CREATININE_CLEARNCE_ONLY]) {
//            message = @"";
//            return message;
//
//        }
//        if ([drug isEqualToString:DABIGATRAN]) {
//            if (crCl > 30)
//                dose = 150;
//            else if (crCl >= 15)
//                dose = 75;
//            else {
//                dose = 0;
//            }
//            if (dose == 0)
//                return [message stringByAppendingString:DO_NOT_USE];
//            return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg BID. ", dose]];
//
//        }
//        if ([drug isEqualToString:DOFETILIDE]) {
//             if (crCl > 60)
//                dose = 500;
//            else if (crCl >= 40)
//                dose = 250;
//            else if (crCl >= 20)
//                dose = 125;
//            else
//                dose = 0;
//            if (dose == 0)
//                return [message stringByAppendingString:DO_NOT_USE];
//            return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mcg BID. ", dose]];
//        }
//        if ([drug isEqualToString:RIVAROXABAN]) {
//            if (crCl > 50)
//                dose = 20;
//            else if (crCl >= 15)
//                dose = 15;
//            else
//                dose = 0;
//            if (dose == 0)
//                return [message stringByAppendingString:DO_NOT_USE];
//            return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg daily. ", dose]];
//            }
//        if ([drug isEqualToString:SOTALOL]) {
//            if (crCl >= 40)
//                dose = 80;
//            else
//                dose = 0;
//            if (dose == 0)
//                return [message stringByAppendingString:DO_NOT_USE];
//            if (crCl > 60)
//                return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg BID. ", dose]];
//            if (crCl >= 40)
//                return [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %i mg daily. ", dose]];
//        }
//        if ([drug isEqualToString:APIXABAN]) {
//            NSString* stringDose = @"";
//
//                EPSLog(@"Creatine = %f", creatinine);
//                if ((creatinine >= 1.5 && (age >= 80 || weight <= 60))
//                        || (age >= 80 && weight <= 60))
//                    stringDose = @"2.5";
//                else
//                    stringDose = @"5";
//
//            if ([stringDose isEqualToString:@"0"])
//                return [message stringByAppendingString:DO_NOT_USE];
//            message = [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %@ mg BID. ", stringDose]];
//            if ([stringDose isEqualToString:@"2.5"])
//                message = [message stringByAppendingString:APIXABAN_2_5_CAUTION];
//            else
//                message = [message stringByAppendingString:APIXABAN_5_CAUTION];
//
//            message = [message stringByAppendingString:INHIBITORS];
//            if (crCl < 15) {
//                message = [message stringByAppendingString:APIXABAN_ESRD_CAUTION];
//            }
//            return message;
//        }
//        if ([drug isEqualToString:EDOXABAN]) {
//            NSString* stringDose = @"";
//            if (crCl < 15 || crCl > 95)
//                stringDose = @"0";
//            else {
//                EPSLog(@"Creatine = %f", creatinine);
//                if (crCl <= 50 && crCl >= 15)
//                    stringDose = @"30";
//                else
//                    stringDose = @"60";
//            }
//            if ([stringDose isEqualToString:@"0"])
//                return [message stringByAppendingString:DO_NOT_USE];
//            message = [message stringByAppendingString:[NSString stringWithFormat:@"Dose = %@ mg daily. ", stringDose]];
//            return message;
//            //return [message stringByAppendingString:AFB_DOSING_ONLY_WARNING];
//        }
//        return @"Unknown Dose";
//    }



}

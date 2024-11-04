//
//  HcmRiskScdViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/24/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct HcmRiskScdViewModel {
    private let model: HcmRiskScdModel
    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    init(age: Int, thickness: Int, laDiameter: Int, gradient: Int, familyHxScd: Bool, hxNsvt: Bool, hxSyncope: Bool) {
        model = HcmRiskScdModel(age: Double(age), thickness: Double(thickness), laDiameter: Double(laDiameter), gradient: Double(gradient), familyHxScd: familyHxScd, hxNsvt: hxNsvt, hxSyncope: hxSyncope)
    }

    func calculate() -> String {
        do {
            var risk = try model.calculate()
            risk *= 100.0
            if let riskPercentage = Self.numberFormatter.string(from: NSNumber(value: risk)) {
                var result = "5 year SCD Risk = \(riskPercentage)%"
                if risk < 4 {
                    result += "\nICD generally not indicated."
                }
                else if risk < 6 {
                    result += "\nICD may be considered."
                }
                else {
                    result += "\nICD should be considered."
                }
                return result
            }
            return ErrorMessage.calculationError
        } catch {
            if let error = error as? HcmRiskScdError {
                return error.description
            } else {
                return ErrorMessage.invalidEntry
            }
        }
    }

    func getDetails() -> String {
        var result = "Risk score: HCM Risk-SCD 2014"
        result += "\nRisks:"
        result += "\nAge = \(Int(model.age)) yrs"
        result += "\nMax LV wall thickness = \(Int(model.thickness)) mm"
        result += "\nMax LA diameter = \(Int(model.laDiameter)) mm"
        result += "\nMax LVOT gradient = \(Int(model.gradient)) mmHg"
        if model.familyHxScd {
            result += "\nFamily hx of SCD"
        }
        if model.hxNsvt {
            result += "\nHx of nonsustained VT"
        }
        if model.hxSyncope {
            result += "\nHx of unexplained syncope"
        }
        result += "\n"
        result += calculate()
        result += "\n"
        result += Reference.getReferenceList(from: HcmRiskScdModel.getReferences())
        return result
    }
}

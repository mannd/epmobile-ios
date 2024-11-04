//
//  HcmScd2022ViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

struct HcmScd2022ViewModel {
    private let model: HcmScd2022Model
    private let riskScdModel: HcmRiskScdModel
    private static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    init(age: Int, thickness: Int, laDiameter: Int, gradient: Int, familyHxScd: Bool, hxNsvt: Bool, hxSyncope: Bool, apicalAneurysm: Bool, lowLVEF: Bool, extensiveLGE: Bool, abnormalBP: Bool, sarcomericMutation: Bool) {
        riskScdModel = HcmRiskScdModel(age: Double(age), thickness: Double(thickness), laDiameter: Double(laDiameter), gradient: Double(gradient), familyHxScd: familyHxScd, hxNsvt: hxNsvt, hxSyncope: hxSyncope)
        model = HcmScd2022Model(apicalAneurysm: apicalAneurysm, lowLVEF: lowLVEF, extensiveLGE: extensiveLGE, abnormalBP: abnormalBP, sarcomericMutation: sarcomericMutation, riskSCDModel: riskScdModel)
    }

    func calculate() -> String {
        do {
            let results = try model.calculate()
            var risk = results.0
            risk *= 100.0
            if let riskPercentage = Self.numberFormatter.string(from: NSNumber(value: risk)) {
                var result = "5 year SCD Risk = \(riskPercentage)%"
                switch results.1 {
                case .class3:
                    result += "\nICD generally not indicated. (Class 3)"
                case .class2b:
                    result += "\nICD may be considered. (Class 2b)"
                case .class2a:
                    result += "\nICD should be considered. (Class 2a)"
                case .class1:
                    result += "\nICD is indicated. (Class 1)"
                }
                return result
            } else {
                return ErrorMessage.calculationError
            }
        } catch {
            if let error = error as? HcmRiskScdError {
                return error.description
            } else {
                return ErrorMessage.invalidEntry
            }
        }
    }

    func getDetails() -> String {
        var result = "Risk score: HCM SCD 2022 (ESC)"
        result += "\nRisks:"
        result += "\nAge = \(Int(riskScdModel.age)) yrs"
        result += "\nMax LV wall thickness = \(Int(riskScdModel.thickness)) mm"
        result += "\nMax LA diameter = \(Int(riskScdModel.laDiameter)) mm"
        result += "\nMax LVOT gradient = \(Int(riskScdModel.gradient)) mmHg"
        if riskScdModel.familyHxScd {
            result += "\nFamily hx of SCD"
        }
        if riskScdModel.hxNsvt {
            result += "\nHx of nonsustained VT"
        }
        if riskScdModel.hxSyncope {
            result += "\nHx of unexplained syncope"
        }
        if model.apicalAneurysm {
            result += "\nApical aneurysm"
        }
        if model.lowLVEF {
            result += "\nLow LVEF (≤ 50%)"
        }
        if model.extensiveLGE {
            result += "\nExtensive LGE"
        }
        if model.abnormalBP {
            result += "\nAbnormal blood pressure"
        }
        if model.sarcomericMutation {
            result += "\nSarcomeric mutation"
        }
        result += "\n"
        result += calculate()
        result += "\n"
        result += Reference.getReferenceList(from: HcmScd2022Model.getReferences())
        return result
    }
}

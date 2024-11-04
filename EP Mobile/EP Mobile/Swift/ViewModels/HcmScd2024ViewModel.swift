//
//  HcmScd2024ViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

struct HcmScd2024ViewModel {
    private let model: HcmScd2024Model

    init(familyHxScd: Bool, massiveLVH: Bool, hxSyncope: Bool, apicalAneurysm: Bool, lowLVEF: Bool, hxNsvt: Bool, extensiveLGE: Bool) {
        model = HcmScd2024Model(familyHxScd: familyHxScd, massiveLVH: massiveLVH, hxSyncope: hxSyncope, apicalAneurysm: apicalAneurysm, lowLVEF: lowLVEF, hxNsvt: hxNsvt, extensiveLGE: extensiveLGE)
    }

    func calculate() -> String {
        let recommendation = model.calculate()
        var result: String
        switch recommendation {
        case .class2a:
            result = "ICD is reasonable (Class 2a)"
        case .class2b:
            result = "ICD may be considered (Class 2b)"
        case .class3:
            result = "ICD is not recommended (Class 3)"
        default:
            result = "ERROR"
        }
        return result
    }

    func getDetails() -> String {
        var result = "Risk score: HCM SCD 2020 (AHA/ACC)"
        result += "\nRisks:"
        if noRisks() {
            result += " No risk factors"
        }
        if model.familyHxScd {
            result += "\nFamily hx of SCD"
        }
        if model.massiveLVH {
            result += "\nMassive LVH"
        }
        if model.hxSyncope {
            result += "\nHx of unexplained syncope"
        }
        if model.apicalAneurysm {
            result += "\nApical aneurysm"
        }
        if model.lowLVEF {
            result += "\nLow LVEF"
        }
        if model.hxNsvt {
            result += "\nHx of nonsustained VT"
        }
        if model.extensiveLGE {
            result += "\nExtensive LGE"
        }
        result += "\n"
        result += calculate()
        result += "\n"
        result += Reference.getReferenceList(from: HcmScd2024Model.getReferences())
        return result
    }

    private func noRisks() -> Bool {
        return !model.familyHxScd && !model.massiveLVH && !model.apicalAneurysm && !model.lowLVEF && !model.hxSyncope && !model.hxNsvt && !model.extensiveLGE
    }

    internal func testNoRisks() -> Bool {
        return noRisks()
    }
}

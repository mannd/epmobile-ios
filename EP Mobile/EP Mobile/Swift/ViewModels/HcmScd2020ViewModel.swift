//
//  HcmScd2020ViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

struct HcmScd2020ViewModel {
    private let model: HcmScd2020Model

    init(familyHxScd: Bool, massiveLVH: Bool, hxSyncope: Bool, apicalAneurysm: Bool, lowLVEF: Bool, hxNsvt: Bool, extensiveLGE: Bool) {
        model = HcmScd2020Model(familyHxScd: familyHxScd, massiveLVH: massiveLVH, hxSyncope: hxSyncope, apicalAneurysm: apicalAneurysm, lowLVEF: lowLVEF, hxNsvt: hxNsvt, extensiveLGE: extensiveLGE)
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
        // TODO: fill in rest
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
            result += "\nHx of NSVT"
        }
        if model.extensiveLGE {
            result += "\nExtensive LGE"
        }
        result += "\n"
        result += calculate()
        result += "\nReferences: "
        result += HcmScd2020Model.getReferences()[0].getPlainTextReference()
        result += "\n"
        result += HcmScd2020Model.getReferences()[1].getPlainTextReference()
        result += "\n"
        result += HcmScd2020Model.getReferences()[2].getPlainTextReference()
        return result
    }
}

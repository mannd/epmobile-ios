//
//  HcmScd2022Model.swift
//  EP Mobile
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

struct HcmScd2022Model: InformationProvider {
    var familyHxScd: Bool = false
    var massiveLVH: Bool = false
    var hxSyncope: Bool = false
    var apicalAneurysm: Bool = false
    var lowLVEF: Bool = false
    var hxNsvt: Bool = false
    var extensiveLGE: Bool = false
    static let references: [Reference] = [
        Reference("O’Mahony C, Jichi F, Pavlou M, et al. A novel clinical risk prediction model for sudden cardiac death in hypertrophic cardiomyopathy (HCM Risk-SCD). European Heart Journal. 2014;35(30):2010-2020. doi:10.1093/eurheartj/eht439"),
        Reference("Monda E, Limongelli G. Integrated Sudden Cardiac Death Risk Prediction Model For Patients With Hypertrophic Cardiomyopathy. Circulation. 2023;147(4):281-283. doi:10.1161/CIRCULATIONAHA.122.063019"),
        Reference("Zeppenfeld K, Tfelt-Hansen J, de Riva M, et al. 2022 ESC Guidelines for the management of patients with ventricular arrhythmias and the prevention of sudden cardiac death. Eur Heart J. 2022;43(40):3997-4126. doi:10.1093/eurheartj/ehac262")
    ]

    func calculate() -> Recommendation {
        var recommendation: Recommendation
        if familyHxScd || massiveLVH || hxSyncope || apicalAneurysm || lowLVEF  {
            recommendation = .class2a
        } else if hxNsvt || extensiveLGE {
            recommendation = .class2b
        } else {
            recommendation = .class3
        }
        return recommendation
    }

    static func getReferences() -> [Reference] {
        return references
    }

    static func getInstructions() -> String? {
        return "Do not use this risk calculator for pediatric patients (<16), elite competitive athletes, HCM associated with metabolic syndromes, or patients with aborted SCD or sustained ventricular arrhythmias.\n\nThis calculator uses the HCM Risk-SCD score to calculate the 5 year risk of sudden death.  It takes into account additional risk factors to make recommendations for ICD implantation."
    }

    static func getKey() -> String? {
        return "CMR = cardiovascular magnetic resonance.\n\nHCM = hypertrophic cardiomyopathy.\n\nICD = implantable cardioverter defibrillator.\n\nLGE = late gadolinium enhancement\n\nLVEF = left ventricular ejection fraction.\n\nLVH = left ventricular hypertrophy\n\nVT = ventricular tachycardia." }
}

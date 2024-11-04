//
//  HcmScd2022Model.swift
//  EP Mobile
//
//  Created by David Mann on 10/20/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

struct HcmScd2022Model: InformationProvider {
    var apicalAneurysm = false
    var lowLVEF = false
    var extensiveLGE = false
    var abnormalBP = false
    var sarcomericMutation = false
    var riskSCDModel: HcmRiskScdModel? = nil

    static let extensiveLGEDescription: String = "Defined as ≥15% of LV mass"
    static let abnormalBPDescription: String = "Defined as a failure to increase systolic pressure by at least 20 mmHg from rest to peak exercise, or a fall of >20 mmHg from peak pressure."

    static let references: [Reference] = [
        Reference("O’Mahony C, Jichi F, Pavlou M, et al. A novel clinical risk prediction model for sudden cardiac death in hypertrophic cardiomyopathy (HCM Risk-SCD). European Heart Journal. 2014;35(30):2010-2020. doi:10.1093/eurheartj/eht439"),
        Reference("Zeppenfeld K, Tfelt-Hansen J, de Riva M, et al. 2022 ESC Guidelines for the management of patients with ventricular arrhythmias and the prevention of sudden cardiac death. Eur Heart J. 2022;43(40):3997-4126. doi:10.1093/eurheartj/ehac262"),
        Reference("Monda E, Limongelli G. Integrated Sudden Cardiac Death Risk Prediction Model For Patients With Hypertrophic Cardiomyopathy. Circulation. 2023;147(4):281-283. doi:10.1161/CIRCULATIONAHA.122.063019")
    ]

    func calculate() throws -> (Double, Recommendation) {
        guard let riskSCDModel else {
            throw HcmRiskScdError.invalidEntry
        }
        let scdProbability = try riskSCDModel.calculate()
        return calculate(scdProbability: scdProbability)
    }

    func calculate(scdProbability: Double) -> (Double, Recommendation) {
        var recommendation: Recommendation = .class3
        if scdProbability >= 0.06 {
            recommendation = .class2a
        }
        if (scdProbability >= 0.04 && scdProbability < 0.06) {
            if (apicalAneurysm || lowLVEF || extensiveLGE || abnormalBP || sarcomericMutation) {
                recommendation = .class2a
            } else {
                recommendation = .class2b
            }
        }
        if scdProbability < 0.04 {
            if (apicalAneurysm || lowLVEF || extensiveLGE ) {
                recommendation = .class2b
            }
            else {
                recommendation = .class3
            }
        }
        return (scdProbability, recommendation)
    }

    static func getReferences() -> [Reference] {
        return references
    }

    static func getInstructions() -> String? {
        return "Do not use this risk calculator for pediatric patients (<16), elite competitive athletes, HCM associated with metabolic syndromes, or patients with aborted SCD or sustained ventricular arrhythmias.\n\nThis calculator uses the HCM Risk-SCD score to calculate the 5 year risk of sudden cardia death.  It takes into account additional risk factors not included in the original HCM Risk-SCD score to make recommendations for ICD implantation.  Given this, the 5 year risk calculated by the HCM Risk-SCD score may underestimate the actual risk of SCD."
    }

    static func getKey() -> String? {
        return "HCM = hypertrophic cardiomyopathy.\n\nCMR = cardiovascular magnetic resonance.\n\nICD = implantable cardioverter defibrillator.\n\nLGE = late gadolinium enhancement\n\nLVEF = left ventricular ejection fraction.\n\nLVH = left ventricular hypertrophy\n\nVT = ventricular tachycardia.\n\nSCD = sudden cardiac death." }
}

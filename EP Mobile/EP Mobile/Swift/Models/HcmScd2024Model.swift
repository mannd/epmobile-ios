//
//  HcmScd2024Model.swift
//  EP Mobile
//
//  Created by David Mann on 10/19/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

// Standard AHA/ACC classes of recommendation.
enum Recommendation {
    case class1
    case class2a
    case class2b
    case class3
}

struct HcmScd2024Model: InformationProvider {
    var familyHxScd: Bool = false
    var massiveLVH: Bool = false
    var hxSyncope: Bool = false
    var apicalAneurysm: Bool = false
    var lowLVEF: Bool = false
    var hxNsvt: Bool = false
    var extensiveLGE: Bool = false
    static let references: [Reference] = [
        Reference("Ommen SR, Ho CY, Asif IM, et al. 2024 AHA/ACC/AMSSM/HRS/PACES/SCMR Guideline for the Management of Hypertrophic Cardiomyopathy: A Report of the American Heart Association/American College of Cardiology Joint Committee on Clinical Practice Guidelines. Circulation. 2024;149(23):e1239-e1311. doi:10.1161/CIR.0000000000001250"),
        Reference("Writing Committee Members, Ommen SR, Mital S, et al. 2020 AHA/ACC Guideline for the Diagnosis and Treatment of Patients With Hypertrophic Cardiomyopathy. Circulation. 2020;142(25):e558-e631. doi:10.1161/CIR.0000000000000937"),
        Reference("Lee HJ, Kim HK, Lee SC, et al. Performance of 2020 AHA/ACC HCM Guidelines and Incremental Value of Myocardial Strain for Predicting SCD. JACC Asia. 2023;4(1):10-22. doi:10.1016/j.jacasi.2023.09.002"),
        Reference("Monda E, Limongelli G. Integrated Sudden Cardiac Death Risk Prediction Model For Patients With Hypertrophic Cardiomyopathy. Circulation. 2023;147(4):281-283. doi:10.1161/CIRCULATIONAHA.122.063019"),
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
        return "Do not use this risk calculator for pediatric patients (<16), elite competitive athletes, HCM associated with metabolic syndromes, or patients with aborted SCD or sustained ventricular arrhythmias.\n\nThis calculator is based on the 2024 Guidelines for the Management of HCM by the AHA/ACC.  The guidelines are virtually identical to the 2020 guidelines, with the exception that the original risk factor of LV apical aneurysm, independent of size, was changed to LV apical aneurysm with transmural scar or LGE."
    }

    static func getKey() -> String? {
        return "CMR = cardiovascular magnetic resonance.\n\nHCM = hypertrophic cardiomyopathy.\n\nICD = implantable cardioverter defibrillator.\n\nLGE = late gadolinium enhancement\n\nLVEF = left ventricular ejection fraction.\n\nLVH = left ventricular hypertrophy\n\nVT = ventricular tachycardia.\n\nSCD = sudden cardiac death." }
}

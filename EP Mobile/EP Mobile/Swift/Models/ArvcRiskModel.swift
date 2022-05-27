//
//  ArvcRiskModel.swift
//  EP Mobile
//
//  Created by David Mann on 4/13/19.
//  Copyright © 2019 EP Studios. All rights reserved.
//

import UIKit

public class ArvcRiskModel: NSObject {
    // baseline survival from sustained VAs at time...
    // Reference: https://doi.org/10.1093/eurheartj/ehac180
    // Note these baseline risks are NOT from the source article, but are from
    // the source code of https://arvcrisk.com/ , accessed on 5/26/2022.
    let year5 = 0.83956384494683
//    let year4 = 0.8695 // This year is not used in the online calculator
//    let year3 = 0.8798 // ditto
    let year2 = 0.900806775419695
    let year1 = 0.93761042413069

    // Baseline survival from life-threatening VAs (LTVA) at time...
    // From https://www.ahajournals.org/action/downloadSupplement?doi=10.1161%2FCIRCEP.120.008509&file=CircAE_CIRCAE-2020-008509-T_supp1.pdf
    // NB: This calculator seems to have errors of math in the paper.  The
    // examples don't match the computation.  There is a typo where 0.972 is given
    // for 0.927 as the 5 year baseline survival.  It is not worth including this
    // calculator unless errata are published.  Note that the original calculator
    // was withdrawn and resubmitted because of math errors.
    let ltvaYear5 = 0.927
    let ltvaYear4 = 0.940
    let ltvaYear3 = 0.948
    let ltvaYear2 = 0.953
    let ltvaYear1 = 0.966

    let sex: Int // In paper, male = 1, female = 0
    let age: Int
    let hxSyncope: Int
    let hxNSVT: Int
    let pvcCount: Int
    let twiCount: Int
    let rvef: Int

    typealias RiskResult = (year5Risk: Double, year2Risk: Double, year1Risk: Double)

    init(sex: Int, age: Int, hxSyncope: Int, hxNSVT: Int,
         pvcCount: Int, twiCount: Int, rvef: Int) {
        self.sex = sex
        self.age = age
        self.hxSyncope = hxSyncope
        self.hxNSVT = hxNSVT
        self.pvcCount = pvcCount
        self.twiCount = twiCount
        self.rvef = rvef
    }

    // linear predictor - note log() is natural log.
    private func linearPredictor() -> Double {
        return 0.4879 * Double(sex)
        - 0.0218 * Double(age)
        + 0.6573 * Double(hxSyncope)
        + 0.8112 * Double(hxNSVT)
        + 0.1701 * (pvcCount > 0 ? log(Double(pvcCount)) : 0)
        + 0.1131 * Double(twiCount)
        - 0.0252 * Double(rvef)
    }

    private func ltvaLinearPredictor() -> Double {
        return 0.6899 * Double(sex)
        - 0.0439 * Double(age)
        + 0.1844 * (pvcCount > 0 ? log(Double(pvcCount)) : 0)
        + 0.1153 * Double(twiCount)
    }


    func calculateRisk() -> RiskResult {
        let lp = linearPredictor()
        return (calculateRisk(baselineSurvival: year5, linearPredictor: lp),
                calculateRisk(baselineSurvival: year2, linearPredictor: lp),
                calculateRisk(baselineSurvival: year1, linearPredictor: lp)
        )
    }

    func ltvaCalculateRisk() -> RiskResult {
        let lp = ltvaLinearPredictor()
        print("ltva lp", lp as Any)
        return (calculateRisk(baselineSurvival: ltvaYear5, linearPredictor: lp),
                calculateRisk(baselineSurvival: ltvaYear2, linearPredictor: lp),
                calculateRisk(baselineSurvival: ltvaYear1, linearPredictor: lp)
        )

    }

    private func calculateRisk(baselineSurvival: Double, linearPredictor: Double) -> Double {
        return roundToOnePlace( 100 * (1.0 - pow(baselineSurvival, exp(linearPredictor))))
    }

    private func roundToOnePlace(_ value: Double) -> Double {
        return round(value * 10) / 10
    }
}


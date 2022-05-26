//
//  ArvcRiskModel.swift
//  EP Mobile
//
//  Created by David Mann on 4/13/19.
//  Copyright © 2019 EP Studios. All rights reserved.
//

import UIKit

public class ArvcRiskModel: NSObject {
    // baseline survival at time...
    let year5 = 0.800813822845434
    let year4 = 0.837312364505388
    let year3 = 0.849912331481654
    let year2 = 0.875734032965286
    let year1 = 0.921429983419349

    let sex: Int
    let age: Int
    let hxSyncope: Int
    let hxNSVT: Int
    let pvcCount: Int
    let twiCount: Int
    let rvef: Int

    typealias RiskResult = (year5Risk: Double,
        year4Risk: Double,
        year3Risk: Double,
        year2Risk: Double,
        year1Risk: Double)

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

    // linear predictor
    private func linearPredictor() -> Double {
        return 0.4879 * Double(sex) - 0.0218 * Double(age) + 0.6573 * Double(hxSyncope) + 0.8112 * Double(hxNSVT) + 0.1701 * (pvcCount > 0 ? log(Double(pvcCount)) : 0) + 0.1131 * Double(twiCount) - 0.0252 * Double(rvef)
    }

    func calculateRisk() -> RiskResult {
            let lp = linearPredictor()
            return (calculateRisk(baselineSurvival: year5, linearPredictor: lp),
                    calculateRisk(baselineSurvival: year4, linearPredictor: lp),
                    calculateRisk(baselineSurvival: year3, linearPredictor: lp),
                    calculateRisk(baselineSurvival: year2, linearPredictor: lp),
                    calculateRisk(baselineSurvival: year1, linearPredictor: lp))
    }

    private func calculateRisk(baselineSurvival: Double, linearPredictor: Double) -> Double {
        return roundToOnePlace( 100 * (1.0 - pow(baselineSurvival, exp(linearPredictor))))
    }

    private func calculateRisk(baselineSurvival: Double) -> Double {
        print(linearPredictor())
        print(1.0 - pow(baselineSurvival, exp(linearPredictor())))
        return roundToOnePlace( 100 * (1.0 - pow(baselineSurvival, exp(linearPredictor()))))
    }

    private func roundToOnePlace(_ value: Double) -> Double {
        return round(value * 10) / 10
    }
}


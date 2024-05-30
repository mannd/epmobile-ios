//
//  V2TransitionCalculator.swift
//  EP Mobile
//
//  Created by David Mann on 5/27/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

import Foundation

struct V2TransitionParameters {
    let rVT: Double
    let sVT: Double
    let rSR: Double
    let sSR: Double

    init(rVT: Double, sVT: Double, rSR: Double, sSR: Double) {
        // negative values automatically become positive
        self.rVT = abs(rVT)
        self.sVT = abs(sVT)
        self.rSR = abs(rSR)
        self.sSR = abs(sSR)
    }
}

struct V2TransitionCalculator: InformationProvider {
    static func getReferences() -> [Reference] {
        return [Reference("Betensky BP, Park RE, Marchlinski FE, et al. The V(2) transition ratio: a new electrocardiographic criterion for distinguishing left from right ventricular outflow tract tachycardia origin. J Am Coll Cardiol. 2011;57(22):2255-2262. doi:10.1016/j.jacc.2011.01.035")]
    }

    static func getInstructions() -> String? {
        return "Measure the R wave and S wave in lead V2 of a sinus rhythm complex and a ventricular tachycardia or premature ventricular complex.  Units of measurement do not matter as this calculation is based on ratios.\n\nNote that the app EP Calipers is useful for making these measurements."
    }

    static func getKey() -> String? {
        return nil
    }

    public func calculate(parameters: V2TransitionParameters? = nil) -> Double? {
        guard let parameters = parameters else { return nil }
        let denominatorVT = parameters.rVT + parameters.sVT
        let denominatorSR = parameters.rSR + parameters.sSR
        if denominatorSR == 0 || denominatorVT == 0 {
            return nil
        }
        let ratioVT = parameters.rVT / denominatorVT
        let ratioSR = parameters.rSR / denominatorSR
        if ratioSR == 0 {
            return nil
        }
        let ratio = ratioVT / ratioSR
        return ratio
    }
}

//
//  Weight.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

// Trying out Swift units, rather than my own here...
struct Weight {
    var weight: Measurement<UnitMass>
    var height: Measurement<UnitLength>
    var sex: EP_Mobile.Sex

    func idealBodyWeight() -> Measurement<UnitMass> {
        let providedWeightUnit = weight.unit
        let heightInches = height.converted(to: .inches)
        let weightKgValue = heightInches.value > 60.0 ? (heightInches.value - 60.0) * 2.3 : 0.0
        var ibw = Measurement(value: weightKgValue, unit: UnitMass.kilograms)
        switch sex {
        case .male:
            ibw = ibw + Measurement(value: 50, unit: UnitMass.kilograms)
        case .female:
            ibw = ibw + Measurement(value: 45.5, unit: UnitMass.kilograms)
        }
        return ibw.converted(to: providedWeightUnit)
    }

    func adjustedBodyWeight() -> Measurement<UnitMass> {
        let providedWeightUnit = weight.unit
        let ibw = idealBodyWeight()
        let abw = ibw + 0.4 * (weight - ibw)
        return (weight > ibw ? abw : weight).converted(to: providedWeightUnit)
    }

    func isOverweight() -> Bool {
        let ibw = idealBodyWeight()
        return weight > ibw + 0.3 * ibw
    }

    func isUnderweight() -> Bool {
        return weight < idealBodyWeight()
    }

    func isUnderHeight() -> Bool {
        return height < Measurement(value: 60, unit: UnitLength.inches)
    }
}


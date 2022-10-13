//
//  Weight.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum WeightType {
    case ideal
    case adjusted
    case actual
    case recommended
}

// Trying out Swift units, rather than my own here...
struct Weight: InformationProvider {
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

    static func getReferences() -> [Reference] {
        return [Reference("Winter MA, Guhr KN, Berg GM. Impact of various body weights and serum creatinine concentrations on the bias and accuracy of the Cockcroft-Gault equation. Pharmacotherapy. 2012;32(7):604-612.\ndoi:10.1002/j.1875-9114.2012.01098.x")]
    }

    static func getInstructions() -> String? {
        return "Although the package inserts for the drugs included in the drug dose calculators recommend using actual uncorrected body weight and the Cockcroft-Gault formula for Creatinine Clearance, some authorities feel that using a corrected body weight may be more accurate.\n\nThis calculator determines the Ideal Body Weight and Adjusted Body Weight from the height, sex, and actual body weight. The Adjusted Body Weight formula here uses a correction factor of 0.4, which may give a more accurate measurement of Creatinine Clearance than other factors.  The formulas are not accurate if the height is less than 60 inches.\n\nPatients who are underweight (weight < Ideal Body Weight) should use actual weight for Creatinine Clearance determination.  Normal weight patients can use Ideal Body Weight, and overweight (defined in this calculator as weight 30% or more over Ideal Body Weight) should use the Adjusted Body Weight."
    }

    // Weight calculator substitutes copy and paste instructions for keys
    static func getKeys() -> String? {
        return "These weights can be copied to the clipboard and pasted into the creatinine clearance calculator weight field using the Copy buttons."
    }

}


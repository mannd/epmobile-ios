//
//  BmiModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/1/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

struct BmiModel: InformationProvider {
    static func getReferences() -> [Reference] {
        // TODO:
        return []
    }

    static func getInstructions() -> String? {
        // TODO:
        return "TODO: Bmi instructions"
    }

    static func getKey() -> String? {
        // TODO:
        return "TODO: Bmi key"
    }

    var height: Measurement<UnitLength>
    var weight: Measurement<UnitMass>

    init(height: Measurement<UnitLength>, weight: Measurement<UnitMass>) {
        self.height = height.converted(to: .meters)
        self.weight = weight.converted(to: .kilograms)
    }

    func calculate() -> Double {
        return (weight.value / (height.value * height.value))
    }
}

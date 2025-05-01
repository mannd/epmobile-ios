//
//  BmiModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/1/25.
//  Copyright © 2025 EP Studios. All rights reserved.
//

import Foundation

enum BmiError: Error {
    case invalidParameter
}

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

    init(height: Measurement<UnitLength>, weight: Measurement<UnitMass>) throws {
        if height.value == 0 || weight.value == 0 {
            throw BmiError.invalidParameter
        }
        self.height = height.converted(to: .meters)
        self.weight = weight.converted(to: .kilograms)
    }

    func calculate() -> Double {
        return (weight.value / (height.value * height.value))
    }

    func calculate() -> String {
        return Self.rounded(calculate())
    }

    static func rounded(_ value: Double) -> String {
        let roundedValue = round(10 * value) / 10
        return String(format: "%.1f", roundedValue)
    }
}

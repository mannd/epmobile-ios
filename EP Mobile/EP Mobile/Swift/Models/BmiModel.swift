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

    enum Classification {
        case underweightSevere,
             underweightModerate,
             underweightMild,
             normal,
             overweightPreobese,
             overweightClass1,
             overweightClass2,
             overweightClass3
    }

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

    func calculateRounded() -> String {
        return Self.rounded(calculate())
    }

    static func rounded(_ value: Double) -> String {
        return String(format: "%.1f", roundToTenths(value))
    }

    static func roundToTenths(_ value: Double) -> Double {
        return round(10 * value) / 10
    }

    // BMI must already be rounded to nearest tenth.
    static func getClassification(bmi value: Double) -> Classification {
        switch value {
        case ..<16.0:
            return .underweightSevere
        case 16.0..<17.0:
            return .underweightModerate
        case 17.0..<18.5:
            return .underweightMild
        case 18.5..<25.0:
            return .normal
        case 25.0..<30.0:
            return .overweightPreobese
        case 30..<35.0:
            return .overweightClass1
        case 35..<40.0:
            return .overweightClass2
        default:
            return .overweightClass3
        }
    }
}

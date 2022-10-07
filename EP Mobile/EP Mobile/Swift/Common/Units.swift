//
//  Units.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum MassUnit: Int, CaseIterable, Identifiable, Equatable {
    case kg
    case lb

    var id: MassUnit { self }
    var description: String {
        switch self {
        case .kg:
            return "kg"
        case .lb:
            return "lb"
        }
    }

    private static let lbToKgConversionFactor = 0.45359237

    static func lbToKg(_ weightInLb: Double) -> Double {
        return weightInLb * Self.lbToKgConversionFactor
    }

    static func kgToLb(_ weightInKg: Double) -> Double {
        return weightInKg / Self.lbToKgConversionFactor
    }
}

enum HeightUnit: Int, CaseIterable, Identifiable, Equatable {
    case cm
    case inch

    var id: HeightUnit { self }
    var description: String {
        switch self {
        case .cm:
            return "cm"
        case .inch:
            return "in"
        }
   }
}

enum ConcentrationUnit: Int, CaseIterable, Identifiable, Equatable {
    case mgDL
    case mmolL

    var id: ConcentrationUnit { self }
    var description: String {
        switch self {
        case .mgDL:
            return "mg/dL"
        case .mmolL:
            return "µmol/L"
        }
    }

    private static let conversionFactor = 88.42

    static func mgDLToMmolL(_ mgDL: Double) -> Double {
        return mgDL * conversionFactor
    }

    static func mmolLToMgDL(_ mmolL: Double) -> Double {
        return mmolL / conversionFactor
    }
}

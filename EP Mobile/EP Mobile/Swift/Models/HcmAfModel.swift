//
//  HcmAfModel.swift
//  EP Mobile
//
//  Copyright (C) 2025 EP Studios, Inc.
//  www.epstudiossoftware.com
//
//  Created by ChatGPT on 11/23/25.
//
//  This file is part of EP Mobile.
//
//  EP Mobile is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  EP Mobile is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with EP Mobile.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

/// Errors that can occur during validation of HCM-AF inputs.
enum HcmAfValidationError: Error, Equatable {
    case laDiameterOutOfRange(Int)
    case ageAtEvalOutOfRange(Int)
    case ageAtDxOutOfRange(Int)
    case parsingError
}

/// Result of the HCM-AF points calculation.
enum HcmAfCalculationResult: Equatable {
    case success(points: Int)
    case failure(error: HcmAfValidationError)
}

/// Risk categories for HCM-AF.
enum HcmAfRiskCategory: String, CaseIterable, Identifiable {
    case low = "Low risk (<1.0%/y)"
    case intermediate = "Intermediate risk (1.0%/y-2.0%/y)"
    case high = "High risk (>2.0%/y)"
    var id: String { rawValue }
}

/// Data for a given score.
struct HcmAfRiskData: Equatable {
    let score: Int
    let riskCategory: HcmAfRiskCategory
    let riskAt2YearsPercent: Double
    let riskAt5YearsPercent: Double
}

struct HcmAfModel {
    let laDiameter: Int?
    let ageAtEval: Int?
    let ageAtDx: Int?
    let hfSx: Bool?
    
    static let riskDataLookupMap: [Int: HcmAfRiskData] = [
        // Low risk
        8:  HcmAfRiskData(score: 8,  riskCategory: .low, riskAt2YearsPercent: 0.4, riskAt5YearsPercent: 1.0),
        9:  HcmAfRiskData(score: 9,  riskCategory: .low, riskAt2YearsPercent: 0.5, riskAt5YearsPercent: 1.2),
        10: HcmAfRiskData(score: 10, riskCategory: .low, riskAt2YearsPercent: 0.6, riskAt5YearsPercent: 1.4),
        11: HcmAfRiskData(score: 11, riskCategory: .low, riskAt2YearsPercent: 0.7, riskAt5YearsPercent: 1.7),
        12: HcmAfRiskData(score: 12, riskCategory: .low, riskAt2YearsPercent: 0.9, riskAt5YearsPercent: 2.1),
        13: HcmAfRiskData(score: 13, riskCategory: .low, riskAt2YearsPercent: 1.0, riskAt5YearsPercent: 2.5),
        14: HcmAfRiskData(score: 14, riskCategory: .low, riskAt2YearsPercent: 1.3, riskAt5YearsPercent: 3.0),
        15: HcmAfRiskData(score: 15, riskCategory: .low, riskAt2YearsPercent: 1.5, riskAt5YearsPercent: 3.6),
        16: HcmAfRiskData(score: 16, riskCategory: .low, riskAt2YearsPercent: 1.8, riskAt5YearsPercent: 4.3),
        17: HcmAfRiskData(score: 17, riskCategory: .low, riskAt2YearsPercent: 2.2, riskAt5YearsPercent: 5.2),

        // Intermediate risk
        18: HcmAfRiskData(score: 18, riskCategory: .intermediate, riskAt2YearsPercent: 2.6, riskAt5YearsPercent: 6.2),
        19: HcmAfRiskData(score: 19, riskCategory: .intermediate, riskAt2YearsPercent: 3.1, riskAt5YearsPercent: 7.4),
        20: HcmAfRiskData(score: 20, riskCategory: .intermediate, riskAt2YearsPercent: 3.8, riskAt5YearsPercent: 8.9),
        21: HcmAfRiskData(score: 21, riskCategory: .intermediate, riskAt2YearsPercent: 4.5, riskAt5YearsPercent: 10.6),

        // High risk
        22: HcmAfRiskData(score: 22, riskCategory: .high, riskAt2YearsPercent: 5.4, riskAt5YearsPercent: 12.6),
        23: HcmAfRiskData(score: 23, riskCategory: .high, riskAt2YearsPercent: 6.5, riskAt5YearsPercent: 15.0),
        24: HcmAfRiskData(score: 24, riskCategory: .high, riskAt2YearsPercent: 7.8, riskAt5YearsPercent: 17.8),
        25: HcmAfRiskData(score: 25, riskCategory: .high, riskAt2YearsPercent: 9.3, riskAt5YearsPercent: 21.1),
        26: HcmAfRiskData(score: 26, riskCategory: .high, riskAt2YearsPercent: 11.1, riskAt5YearsPercent: 24.8),
        27: HcmAfRiskData(score: 27, riskCategory: .high, riskAt2YearsPercent: 13.3, riskAt5YearsPercent: 29.1),
        28: HcmAfRiskData(score: 28, riskCategory: .high, riskAt2YearsPercent: 15.7, riskAt5YearsPercent: 33.9),
        29: HcmAfRiskData(score: 29, riskCategory: .high, riskAt2YearsPercent: 18.7, riskAt5YearsPercent: 39.3),
        30: HcmAfRiskData(score: 30, riskCategory: .high, riskAt2YearsPercent: 22.0, riskAt5YearsPercent: 45.2),
        31: HcmAfRiskData(score: 31, riskCategory: .high, riskAt2YearsPercent: 25.9, riskAt5YearsPercent: 51.5)
    ]

    /// Retrieve risk data for a given score.
    static func riskData(for score: Int) -> HcmAfRiskData? {
        riskDataLookupMap[score]
    }

    /// Compute the score based on provided parameters, or return a validation error.
    func getPoints() -> HcmAfCalculationResult {
        guard let laDiameter = laDiameter,
              let ageAtEval = ageAtEval,
              let ageAtDx = ageAtDx,
              let hfSx = hfSx else {
            return .failure(error: .parsingError)
        }
        guard (24...65).contains(laDiameter) else {
            return .failure(error: .laDiameterOutOfRange(laDiameter))
        }
        guard (10...79).contains(ageAtEval) else {
            return .failure(error: .ageAtEvalOutOfRange(ageAtEval))
        }
        guard (0...79).contains(ageAtDx) else {
            return .failure(error: .ageAtDxOutOfRange(ageAtDx))
        }

        let points = Self.getPointsLaDiameter(laDiameter)
            + Self.getPointsAgeAtEval(ageAtEval)
            + Self.getPointsAgeAtDx(ageAtDx)
            + Self.getPointsHfSx(hfSx)
        return .success(points: points)
    }

    private static func getPointsLaDiameter(_ diameter: Int) -> Int {
        let diff = diameter - 24
        let multiplier = diff / 6
        return multiplier * 2 + 8
    }

    private static func getPointsAgeAtEval(_ age: Int) -> Int {
        let diff = age - 10
        let multiplier = diff / 10
        return multiplier * 3 + 8
    }

    private static func getPointsAgeAtDx(_ age: Int) -> Int {
        let multiplier = age / 10
        return multiplier * -2
    }

    private static func getPointsHfSx(_ hasSx: Bool) -> Int {
        hasSx ? 3 : 0
    }
}


//
//  WeightCalculatorViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/9/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct WeightCalculatorViewModel {
    private let model: Weight

    let underHeightMessage = "These measurements might not be useful when height < 60 inches."
    let overweightMessage = "Recommended Weight = Adjusted Body Weight (%@)"
    let underweightMessage = "Recommended Weight = Actual Body Weight (%@)"
    let normalWeightMessage = "Recommended Weight = Ideal Body Weight (%@)"

    static let measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter = numberFormatter
        return formatter
    }()

    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }()


    init(weight: Measurement<UnitMass>, height: Measurement<UnitLength>, sex: EP_Mobile.Sex) {
        model = Weight(weight: weight, height: height, sex: sex)
    }

    func actualBodyWeight() -> String {
        if !checkMeasurements() {
            return ErrorMessage.invalidEntry
        }
        return "Actual Body Weight = \(formattedActualBodyWeight())"
    }

    func formattedActualBodyWeight() -> String {
        return Self.measurementFormatter.string(from: model.weight)
    }

    func rawActualBodyWeight() -> String? {
        return Self.numberFormatter.string(from: NSNumber(value: model.weight.value))

    }
    
    func idealBodyWeight() -> String {
        if !checkMeasurements() {
            return ErrorMessage.invalidEntry
        }
        return "Ideal Body Weight = \(formattedIdealBodyWeight())"
    }

    func formattedIdealBodyWeight() -> String {
        return Self.measurementFormatter.string(from: model.idealBodyWeight())
    }

    func rawIdealBodyWeight() -> String? {
        return Self.numberFormatter.string(from: NSNumber(value: model.idealBodyWeight().value))
    }

    func adjustedBodyWeight() -> String {
        if !checkMeasurements() {
            return ErrorMessage.invalidEntry
        }
        return "Adjusted Body Weight = \(formattedAdjustedBodyWeight())"
    }

    func formattedAdjustedBodyWeight() -> String {
        return Self.measurementFormatter.string(from: model.adjustedBodyWeight())
    }

    func rawAdjustedBodyWeight() -> String? {
        return Self.numberFormatter.string(from: NSNumber(value: model.adjustedBodyWeight().value))
    }

    func recommendedBodyWeight() -> String {
        if !checkMeasurements() {
            return ErrorMessage.invalidEntry
        }
        if model.isOverweight() {
            return "Recommended Weight = Adjusted Body Weight (\(formattedAdjustedBodyWeight()))"
        } else if model.isUnderweight() {
            return "Recommended Weight = Actual Body Weight (\(formattedActualBodyWeight()))"
        }
        return "Recommended Weight = Ideal Body Weight (\(formattedIdealBodyWeight()))"
    }


    func rawRecommendedBodyWeight() -> String? {
        if model.isOverweight() {
            return rawAdjustedBodyWeight()
        } else if model.isUnderweight() {
            return rawActualBodyWeight()
        }
        return rawIdealBodyWeight()
    }

    private func checkMeasurements() -> Bool {
        return model.weight.value > 0 && model.height.value > 0
    }
}

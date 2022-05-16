//
//  WarfarinViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/12/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

struct WarfarinViewModel {
    private let model: Warfarin

    init(tabletSize: Double, weeklyDose: Double, inr: Double, inrTarget: InrTarget ) {
        model = Warfarin(inr: inr, weeklyDose: weeklyDose, tabletSize: tabletSize, inrTarget: inrTarget)
    }

    func calculate() -> String {
        guard model.inr > 0 && model.weeklyDose > 0 else {
            return ErrorMessage.invalidEntry
        }
        let doseChange = model.getDoseChange()
        var result = ""
        if let instruction = doseChange.instruction {
            if instruction == .holdWarfarin || instruction == .therapeutic {
                return instruction.description
            } else {
                result = "\(instruction.description)\n"
            }
        }
        // At this point, should, doseChange.range and direction shold be non-nil
        guard let range = doseChange.range, let direction = doseChange.direction else {
            return ErrorMessage.invalidEntry
        }
        switch direction {
        case .increase:
            result += "Increase "
        case .decrease:
            result += "Decrease "
        }
        let lowEndDose = model.getNewDoseFrom(percent: Double(range.lowerBound) / 100.0, oldDose: model.weeklyDose, doseChangeDirection: direction)
        let highEndDose = model.getNewDoseFrom(percent: Double(range.upperBound) / 100.0, oldDose: model.weeklyDose, doseChangeDirection: direction)
        result += "weekly dose by \(range.lowerBound)% (\(lowEndDose) mg/wk) to \(range.upperBound)% (\(highEndDose) mg/wk)."
        return result
    }

    func showDoseTable() -> Bool {
        return model.weeklyDoseIsSane()
    }
}

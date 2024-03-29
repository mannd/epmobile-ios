//
//  WarfarinViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/12/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

class WarfarinViewModel {
    private let model: Warfarin
    var dosingTableData: DosingTableData?

    init(tabletSize: Double, weeklyDose: Double, inr: Double, inrTarget: InrTarget ) {
        model = Warfarin(inr: inr, weeklyDose: weeklyDose, tabletSize: tabletSize, inrTarget: inrTarget)
    }

    func calculate() -> (String, Bool) {
        guard model.inr > 0 && model.weeklyDose > 0 else {
            return (ErrorMessage.invalidEntry, false)
        }
        var result = ""
        let doseChange = model.getDoseChange()
        if let instruction = doseChange.instruction {
            if instruction == .holdWarfarin || instruction == .therapeutic {
                return (instruction.description, false)
            } else {
                result = "\(instruction.description)\n"
            }
        }
        // At this point, doseChange.range and direction should be non-nil
        guard let range = doseChange.range, let direction = doseChange.direction else {
            return (ErrorMessage.invalidEntry, false)
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
        if weeklyDoseIsSane() {
            dosingTableData = createDosingTableData(lowEndDose: range.lowerBound, highEndDose: range.upperBound, direction: direction)
        }
        return (result, true)
    }

    func weeklyDoseIsSane() -> Bool {
        return model.weeklyDoseIsSane()
    }

    func createDosingTableData(lowEndDose: Int, highEndDose: Int, direction: DoseChangeDirection) -> DosingTableData {
        var dosingTableData = DosingTableData()
        dosingTableData.weeklyDose = Float(model.weeklyDose)
        dosingTableData.lowEndDose = lowEndDose
        dosingTableData.highEndDose = highEndDose
        dosingTableData.tabletSize = Float(model.tabletSize)
        dosingTableData.increaseDose = direction == .increase
        return dosingTableData
    }
}

struct DosingTableData {
    var weeklyDose: Float?
    var lowEndDose: Int?
    var highEndDose: Int?
    var tabletSize: Float?
    var increaseDose: Bool?
}

//
//  Warfarin.swift
//  EP Mobile
//
//  Created by David Mann on 5/12/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum InrTarget: Int, CaseIterable, Identifiable {
    case low
    case high

    var id: InrTarget { self }

    var description: String {
        switch self {
        case .low:
            return "2.0 to 3.0"
        case .high:
            return "2.5 to 3.5"
        }
    }
}

struct Warfarin {

    let lowInrRange: ClosedRange = 2.0...3.0
    let highInrRange: ClosedRange = 2.5...3.5

    var inr: Double
    var weeklyDose: Double
    var tabletSize: Double

    private let doseRange: ClosedRange<Double>

    init(inr: Double, weeklyDose: Double, tabletSize: Double, inrTarget: InrTarget) {
        self.inr = inr
        self.weeklyDose = weeklyDose
        self.tabletSize = tabletSize
        switch inrTarget {
        case .low:
            doseRange = lowInrRange
        case .high:
            doseRange = highInrRange
        }
    }


    func getDoseChange() -> DoseChange {
        var doseChange = DoseChange()
        if inr > 6.0 {
            doseChange.instruction = .holdWarfarin
        } else if inrIsTherapeutic() {
            doseChange.instruction = .therapeutic
        } else if doseRange == lowInrRange {
            doseChange = getDoseChangeLowInrRange()
        } else if doseRange == highInrRange {
            doseChange = getDoseChangeHighInrRange()
        }
        return doseChange
    }

    func getDoseChangeLowInrRange() -> DoseChange {
        var doseChange = DoseChange()
        if inr > 3.6 {
            doseChange.instruction = .holdOneDose
        }
        if inr < 2.0 {
            doseChange.range = 5...20
            doseChange.direction = .increase
        } else if inr > 3.0 && inr < 3.6 {
            doseChange.range = 5...15
            doseChange.direction = .decrease
        } else if inr >= 3.6 && inr <= 4 {
            doseChange.range = 10...15
            doseChange.direction = .decrease
        } else if inr > 4 {
            doseChange.range = 10...20
            doseChange.direction = .decrease
        }
        return doseChange
    }

    func getDoseChangeHighInrRange() -> DoseChange {
        var doseChange = DoseChange()
        if inr < 2.0 {
            doseChange.range = 10...20
            doseChange.direction = .increase
            doseChange.instruction = .giveAdditionalDose
        } else if inr >= 2.0 && inr < 2.5 {
            doseChange.range = 5...15
            doseChange.direction = .increase
        } else if inr > 3.5 && inr <= 4.6 {
            doseChange.range = 5...15
            doseChange.direction = .decrease
        } else if inr > 4.6 && inr <= 5.2 {
            doseChange.range = 10...20
            doseChange.direction = .decrease
            doseChange.instruction = .holdOneDose
        } else if inr > 5.2 {
            doseChange.range = 10...20
            doseChange.direction = .decrease
            doseChange.instruction = .holdTwoDoses
        }
        return doseChange
    }

    func inrIsTherapeutic() -> Bool {
        return doseRange.contains(inr)
    }

    func weeklyDoseIsSane() -> Bool {
        // dose calculator algorithm should handle from about 3 half tabs a week to 2 tabs daily
        return (weeklyDose > (4 * 0.5 * tabletSize)) && (weeklyDose < (2 * tabletSize * 7));
    }

    func getNewDoseFrom(percent: Double,
                        oldDose: Double,
                        doseChangeDirection: DoseChangeDirection) -> Double {
        return round(oldDose + (doseChangeDirection == .increase ? oldDose * percent : -oldDose * percent))
    }
}

enum DoseChangeDirection {
    case increase
    case decrease
}

enum DoseInstruction {
    case giveAdditionalDose
    case holdOneDose
    case holdTwoDoses
    case holdWarfarin
    case therapeutic

    var description: String {
        switch self {
        case .giveAdditionalDose:
            return "Give additional dose."
        case .holdOneDose:
            return "Consider holding one dose."
        case .holdTwoDoses:
            return "Consider holding up to two doses."
        case .holdWarfarin:
            return "Hold warfarin until INR back in therapeutic range."
        case .therapeutic:
            return "INR is therapeutic. No change in warfarin dose."
        }
    }
}

struct DoseChange {
    var range: ClosedRange<Int>? = nil // range of percent change in dose
    var direction: DoseChangeDirection? = nil
    var instruction: DoseInstruction? = nil
}

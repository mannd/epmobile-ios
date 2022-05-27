//
//  QTcCalculatorViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/3/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation
import MiniQTc

extension QtMeasurement {
    func heartRate() -> Double {
        switch intervalRateType {
        case .rate:
            return intervalRate
        case .interval:
            switch units {
            case .msec:
                return QTc.msecToBpm(intervalRate)
            case .sec:
                return QTc.secToBpm(intervalRate)
            }
        }
    }

    func qtInSec() -> Double? {
        guard let qt = qt else { return nil }
        switch units {
        case .sec:
            return qt
        case .msec:
            return QTc.msecToSec(qt)
        }
    }
}

struct QTcCalculatorViewModel {
    let qtMeasurement: QtMeasurement
    let formula: Formula
    let maximumQTc: Double

    func calculate() -> (qtc: String, flagResult: Bool) {
        guard let qt = qtMeasurement.qt else {
            return (ErrorMessage.invalidEntry, false)
        }
        guard qt > 0 && qtMeasurement.intervalRate > 0 else {
            return (ErrorMessage.invalidEntry, false)
        }
        guard !valuesOutOfRange() else {
            return (ErrorMessage.outOfRange, false)
        }
        let calculator = QTc.qtcCalculator(formula: formula)
        var flagResult: Bool = false
        do {
            let rawResult = try calculator.calculate(qtMeasurement: qtMeasurement)
            flagResult = rawResult > maximumQTc
            return (Self.formattedQTcResult(rawResult: rawResult), flagResult)
        } catch {
            // all errors handled as invalid entry, though this is probably unreachable code.
            flagResult = false
            return (ErrorMessage.invalidEntry, false)
        }
    }

    static func formattedQTcResult(rawResult: Double) -> String {
        return "QTc = \(String(Int(round(rawResult)))) msec"
    }

    // assumes no null or negative fields
    func valuesOutOfRange() -> Bool {
        let minQT = 0.2
        let maxQT = 0.8
        let minRate = 20.0
        let maxRate = 250.0
        var outOfRange = false
        if qtMeasurement.heartRate() < minRate || qtMeasurement.heartRate() > maxRate {
            outOfRange = true
        }
        if let qt = qtMeasurement.qtInSec() {
            if qt < minQT || qt > maxQT {
                outOfRange = true
            }
        } else {
            outOfRange = true
        }
        return outOfRange
    }
}

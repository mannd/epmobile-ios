//
//  QTc.swift
//  EP Mobile
//
//  Created by David Mann on 5/1/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation

enum QTcFormulaName {
    case bazett
    case fridericia
    case sagie
    case hodges
}

typealias Msec = Double
typealias Sec = Double
typealias Bpm = Double

protocol QTcFormula {
    func calculate(qtMeasurement: QTMeasurement) -> Msec
}

struct QTMeasurement {
    var qt: Msec
    var rr: Msec

    fileprivate var qtInSec: Sec {
        IntervalRateConversion.msecToSecs(qt)
    }
    fileprivate var rrInSec: Sec {
        IntervalRateConversion.msecToSecs(rr)
    }
    fileprivate var heartRate: Bpm {
        IntervalRateConversion.convert(value: rr)
    }

}

struct QTcFormulaFactory {
    func create(name: QTcFormulaName) -> QTcFormula {
        switch name {
        case .bazett:
            return bazettFormula()
        case .fridericia:
            return fridericiaFormula()
        case .sagie:
            return sagieFormula()
        case .hodges:
            return hodgesFormula()
        }
    }
}

struct bazettFormula: QTcFormula {
    func calculate(qtMeasurement: QTMeasurement) -> Msec {
        return IntervalRateConversion.secsToMsec(qtMeasurement.qtInSec / sqrt(qtMeasurement.rrInSec))
    }
}

struct fridericiaFormula: QTcFormula {
    func calculate(qtMeasurement: QTMeasurement) -> Msec {
        return IntervalRateConversion.secsToMsec(qtMeasurement.qtInSec / cbrt(qtMeasurement.rrInSec))
    }
}

struct sagieFormula: QTcFormula {
    func calculate(qtMeasurement: QTMeasurement) -> Msec {
        return IntervalRateConversion.secsToMsec(qtMeasurement.qtInSec + 0.154 * (1.0 - qtMeasurement.rrInSec))
    }
}

struct hodgesFormula: QTcFormula {
    func calculate(qtMeasurement: QTMeasurement) -> Msec {
        return IntervalRateConversion.secsToMsec(qtMeasurement.qtInSec + ((1.75 * qtMeasurement.heartRate - 60) / 1000.0))
    }
}



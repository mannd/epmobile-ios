//
//  QTcIvcd.swift
//  EP Mobile
//
//  Created by David Mann on 5/5/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import MiniQTc

struct QTcIvcd {
    var qt: Double
    var qrs: Double
    var rr: Double
    var sex: EP_Mobile.Sex
    var formula: Formula

    init(qt: Double, qrs: Double, rr: Double, sex: EP_Mobile.Sex, formula: Formula = .qtcBzt) {
        self.qt = qt
        self.qrs = qrs
        self.rr = rr
        self.sex = sex
        self.formula = formula
    }

    init(qt: Double, qrs: Double, intervalRate: Double, intervalRateType: IntervalRateType, sex: EP_Mobile.Sex, formula: Formula = .qtcBzt) {
        let rr = intervalRateType == .interval ? intervalRate : QTc.bpmToMsec(intervalRate)
        self.init(qt: qt, qrs: qrs, rr: rr, sex: sex, formula: formula)
    }

    func qtc() -> Double? {
        let calculator = QTc.qtcCalculator(formula: formula)
        guard let result = try? calculator.calculate(qtInMsec: qt, rrInMsec: rr) else {
            return nil
        }
        return result
    }

    func jt() -> Double {
        return qt - qrs
    }

    func jtc() -> Double? {
        guard var result = qtc() else {
            return nil
        }
        result -= qrs
        return result
    }

    // Updated to use Bogossian 2020
    func qtCorrectedForLBBB() -> Double {
        //return qt - (qrs * 0.485) // Bogossian 2014
        return qt - (qrs * 0.5) // Bogossian 2020
    }

    func qtCorrectedForIvcdAndSex() -> Double {
        var k: Double
        switch sex {
        case .male:
           k = -22

        case .female:
           k = -34
        }
        let hr = QTc.msecToBpm(rr)
        return qt - 155 * (60 / hr - 1) - 0.93 * (qrs - 139) + k
    }

    func preLbbbQtc() -> Double? {
        var k: Double
        switch sex {
        case .male:
            k = 95.0
        case .female:
            k = 88.0
        }
        guard let qtc = qtc() else {
            return nil
        }
        return qtc - qrs + k
    }

    func qtm() -> Double {
        return qtCorrectedForLBBB()
    }

    func qtmc() -> Double? {
        let calculator = QTc.qtcCalculator(formula: formula)
        guard let result = try? calculator.calculate(qtInMsec: qtm(), rrInMsec: rr) else {
            return nil
        }
        return result
    }
}

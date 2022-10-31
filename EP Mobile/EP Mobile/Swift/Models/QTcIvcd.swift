//
//  QTcIvcd.swift
//  EP Mobile
//
//  Created by David Mann on 5/5/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import MiniQTc

struct QTcIvcd: InformationProvider {

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

    static func getReferences() -> [Reference] {
        var references:[Reference] = []
        references.append(Reference("Rautaharju PM, Zhang ZM, Prineas R, Heiss G. Assessment of prolonged QT and JT intervals in ventricular conduction defects. American Journal of Cardiology. 2004;93(8):1017-1021.\ndoi:10.1016/j.amjcard.2003.12.055"))
        references.append(Reference("Rautaharju PM, Surawicz B, Gettes LS. AHA/ACCF/HRS Recommendations for the Standardization and Interpretation of the Electrocardiogram Part IV: The ST Segment, T and U Waves, and the QT Interval: A Scientific Statement From the American Heart Association Electrocardiography and Arrhythmias Committee, Council on Clinical Cardiology; the American College of Cardiology Foundation; and the Heart Rhythm Society: Endorsed by the International Society for Computerized Electrocardiology. Circulation. 2009;119(10):e241-e250.\ndoi:10.1161/CIRCULATIONAHA.108.191096"))
        references.append(Reference("Yankelson L, Hochstadt A, Sadeh B, et al. New formula for defining “normal” and “prolonged” QT in patients with bundle branch block. Journal of Electrocardiology. 2018;51(3):481-486.\ndoi:10.1016/j.jelectrocard.2017.12.039"))
        references.append(Reference("Bogossian H, Linz D, Heijman J, et al. QTc evaluation in patients with bundle branch block. Int J Cardiol Heart Vasc. 2020;30:100636.\ndoi:10.1016/j.ijcha.2020.100636"))
        return references
    }

    static func getInstructions() -> String? {
        "Use this calculator to estimate the QTc when there is an intraventricular conduction delay "
    }

    static func getKey() -> String? {
        return nil
    }
}

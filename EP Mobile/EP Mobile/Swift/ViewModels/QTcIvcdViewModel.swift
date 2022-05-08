//
//  QTcIvcdViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/6/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation
import OrderedCollections
import MiniQTc

enum QTcIvcdFormula {
    case qt
    case qtc
    case jt
    case jtc
    case qtm
    case qtmc
    case qtrrqrs
    case prelbbbqtc
}

typealias QTcIvcdResultList = OrderedDictionary<QTcIvcdFormula, String>
typealias QTCIvcdResultDetailList = OrderedDictionary<QTcIvcdFormula, String>

enum QTcIvcdError: Error {
    case invalidParameter
    case tooShortQRS
    case longQRS
}

struct QTcIvcdViewModel {
    private static let noQTm = "QTm only defined for LBBB"
    private static let noQTmc = "QTmc only defined for LBBB"
    private static let noPreLbbbQTc = "preLBBBQTc only defined for LBBB"
    private static let qtm_Reference = "Bogossian H et al. New formula for evaluation of the QT interval in patients with left bundle branch block. Heart Rhythm 2004;11:2273-2277."
    private static let qtRRQrsFormula = "QTrr,qrs = QT - 155 x (60/HR - 1) - 0.93 x (QRS - 139) + k, k = -22 ms for men and -34 ms for women"
    private static let qtRRQrsReference = "Rautaharju P et al. Assessment of prolonged QT and JT intervals in ventricular conduction defects.  Amer J Cardio 2003;93:1017-1021."
    private static let qtcReference = "Rautaharju P et al. Circulation. 2009;119:e241-e250."
    private static let preLbbbQtcFormula = "preLBBBQTc = postLBBBQTc(Bazett) - postLBBBQRS + c, where c = 95 msec in males, 88 msec in females"
    private static let preLbbbQtcReference = "Yankelson L, Hochstadt A, Sadeh B, et al. New formula for defining “normal” and “prolonged” QT in patients with bundle branch block. Journal of Electrocardiology. 2018;51(3):481-486. doi:10.1016/j.jelectrocard.2017.12.039"

    let qt: Double
    let qrs: Double
    let intervalRate: Double
    let intervalRateType: IntervalRateType
    let sex: EP_Mobile.Sex
    let formula: Formula
    let isLBBB: Bool

    static var qtcIvcdResultDetails: QTCIvcdResultDetailList = [.qt: "\n\nUse: The QT varies with heart rate, QRS and sex, and so is usually not a good measure of repolarization independent of these other factors.\n\nFormula: This is the uncorrected QT interval.\n\nNormal values: Not defined."]


    func calculate() throws -> QTcIvcdResultList {
        guard intervalRate > 0 && qt > 0 && qrs > 0 else {
            throw QTcIvcdError.invalidParameter
        }
        guard qrs < qt else {
            throw QTcIvcdError.longQRS
        }
        guard qrs >= 120 else {
            throw QTcIvcdError.tooShortQRS
        }
        let qtcIvcd = QTcIvcd(qt: qt, qrs: qrs, intervalRate: intervalRate, intervalRateType: intervalRateType, sex: sex, formula: formula)
        var qtcIvcdResultList = QTcIvcdResultList()
        qtcIvcdResultList[.qt] = format(name: "QT", value: qtcIvcd.qt)
        if let qtc = qtcIvcd.qtc() {
            qtcIvcdResultList[.qtc] = format(name: "QTc", value: qtc)
        } else {
            qtcIvcdResultList[.qtc] = "QTc = " + ErrorMessage.calculationError
        }
        qtcIvcdResultList[.jt] = format(name: "JT", value: qtcIvcd.jt())
        if let jtc = qtcIvcd.jtc() {
            qtcIvcdResultList[.jtc] = format(name: "JTc", value: jtc)
        } else {
            qtcIvcdResultList[.jtc] = "JTc = " + ErrorMessage.calculationError
        }
        if isLBBB {
            qtcIvcdResultList[.qtm] = format(name: "QTm", value: qtcIvcd.qtm())
            if let qtmc = qtcIvcd.qtmc() {
                qtcIvcdResultList[.qtmc] = format(name: "QTmc", value: qtmc)
            } else {
                qtcIvcdResultList[.qtmc] = "QTmc = " + ErrorMessage.calculationError
            }
            if let preLbbbQtc = qtcIvcd.preLbbbQtc() {
                qtcIvcdResultList[.prelbbbqtc] = format(name: "preLBBBQTc", value: preLbbbQtc)
            } else {
                qtcIvcdResultList[.prelbbbqtc] = "preLBBBQTc = " + ErrorMessage.calculationError
            }
        } else {
            qtcIvcdResultList[.qtm] = Self.noQTm
            qtcIvcdResultList[.qtmc] = Self.noQTmc
            qtcIvcdResultList[.prelbbbqtc] = Self.noPreLbbbQTc
        }
        qtcIvcdResultList[.qtrrqrs] = format(name: "QTrr,qrs", value:  qtcIvcd.qtCorrectedForIvcdAndSex())
        return qtcIvcdResultList
    }

    private func format(name: String, value: Double) -> String {
        return "\(name) = \(Int(round(value))) msec"
    }
    
}


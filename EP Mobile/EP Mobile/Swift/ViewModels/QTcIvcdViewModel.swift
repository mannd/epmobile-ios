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

    var description: String {
        switch self {
        case .qt:
            return "Uncorrected QT"
        case .qtc:
            return "Corrected QT (QTc)"
        case .jt:
            return "Uncorrected JT"
        case .jtc:
            return "Corrected JT (JTc)"
        case .qtm:
            return "Modified QT in LBBB (QTm)"
        case .qtmc:
            return "Corrected Modified QTc in LBBB (QTmc)"
        case .qtrrqrs:
            return "QT Corrected for Rate, QRS, and Sex (QTrr,qrs)"
        case .prelbbbqtc:
            return "PreLBBBQTc"
        }
    }
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

    let qt: Double
    let qrs: Double
    let intervalRate: Double
    let intervalRateType: IntervalRateType
    let sex: EP_Mobile.Sex
    let formula: Formula
    let isLBBB: Bool

    static var qtcIvcdResultDetails: QTCIvcdResultDetailList = [
        .qt: "Use: The QT varies with heart rate, QRS and sex, and so is usually not a good measure of repolarization independent of these other factors.\n\nFormula: This is the uncorrected QT interval.\n\nNormal values: Not defined.",
        .jt: "Use: The JT interval corrects for QRS duration, but does not correct for heart rate.\n\nFormula: JT = QT - QRS\n\nNormal values: Not defined.",
        .qtc: "Use: The QTc corrects for heart rate, but does not correct for increased QRS duration.  \n\nFormula: QTc[sec] = QT[sec] / SQRT(RR[sec])\n\nNormal values (without IVCD) per AHA/ACC/HRS guidelines (Rautaharju P et al. Circulation. 2009;119:e241-e250.): Male < 450 msec, Female < 460 msec and > 390 msec (both sexes).",
        .jtc: "Use: JTc corrects for heart rate and QRS duration, however normal values are not well established.\n\nFormula: JTc = QTc - QRS\n\nNormal values: Not defined.",
        .qtm: "Use: Attempts to correct for the prolongation of the QT interval attributable to QRS prolongation in LBBB.\n\nFormula: QTm = QTb - 0.485 * QRSb\n\nNormal values: Not defined.\n\nReference: Bogossian H et al. New formula for evaluation of the QT interval in patients with left bundle branch block. Heart Rhythm 2014;11:2273-2277.",
        .qtmc: "Use: Corrects QTm for heart rate.\n\nFormula: QTmc = QTm corrected for rate.\n\nNormal values: Presumably the same as QTc.\n\nReference: Bogossian H et al. New formula for evaluation of the QT interval in patients with left bundle branch block. Heart Rhythm 2014;11:2273-2277.",
        .qtrrqrs: "Use: Corrects QT for rate, QRS duration and sex.\n\nFormula: QTrr,qrs = QT - 155 x (60/HR - 1) - 0.93 x (QRS - 139) + k, k = -22 ms for men and -34 ms for women\n\nNormal values: 2% and 5% normal limits of 460 and 450 msec.\n\nReference: Rautaharju P et al. Assessment of prolonged QT and JT intervals in ventricular conduction defects.  Amer J Cardio 2003;93:1017-1021.",
        .prelbbbqtc: "Use: Corrects QT for rate, QRS duration and sex.\n\nFormula: preLBBBQTc = postLBBBQTc - postLBBBQRS + c, where c = 95 msec in males, 88 msec in females\n\nNormal values: Presumably the same as QTc.\n\nReference: Yankelson L, Hochstadt A, Sadeh B, et al. New formula for defining “normal” and “prolonged” QT in patients with bundle branch block. Journal of Electrocardiology. 2018;51(3):481-486. doi:10.1016/j.jelectrocard.2017.12.039",
        ]

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


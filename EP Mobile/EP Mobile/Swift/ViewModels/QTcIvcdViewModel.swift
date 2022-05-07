//
//  QTcIvcdViewModel.swift
//  EP Mobile
//
//  Created by David Mann on 5/6/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import Foundation
import MiniQTc

enum QTcIvcdError: Error {
    case invalidParameter
    case tooShortQRS
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

    func calculate() throws -> QTcIvcdResult {
        guard intervalRate > 0 && qt > 0 && qrs > 0 else {
            throw QTcIvcdError.invalidParameter
        }
        guard qrs >= 120 else {
            throw QTcIvcdError.tooShortQRS
        }
        let qtcIvcd = QTcIvcd(qt: qt, qrs: qrs, intervalRate: intervalRate, intervalRateType: intervalRateType, sex: sex, formula: formula)
        var qtcIvcdResult = QTcIvcdResult()
        qtcIvcdResult.qt = format(name: "QT", value: qtcIvcd.qt)
        if let qtc = qtcIvcd.qtc() {
            qtcIvcdResult.qtc = format(name: "QTc", value: qtc)
        } else {
            qtcIvcdResult.qtc = "QTc = " + ErrorMessages.calculationError
        }
        qtcIvcdResult.jt = format(name: "JT", value: qtcIvcd.jt())
        if let jtc = qtcIvcd.jtc() {
            qtcIvcdResult.jtc = format(name: "JTc", value: jtc)
        } else {
            qtcIvcdResult.qtc = "JTc = " + ErrorMessages.calculationError
        }
        if isLBBB {
            qtcIvcdResult.qtm = format(name: "QTm", value: qtcIvcd.qtm())
            if let qtmc = qtcIvcd.qtmc() {
                qtcIvcdResult.qtmc = format(name: "QTmc", value: qtmc)
            } else {
                qtcIvcdResult.qtmc = "QTmc = " + ErrorMessages.calculationError
            }
            if let preLbbbQtc = qtcIvcd.preLbbbQtc() {
                qtcIvcdResult.prelbbbqc = format(name: "preLBBBQTc", value: preLbbbQtc)
            } else {
                qtcIvcdResult.prelbbbqc = "preLBBBQTc = " + ErrorMessages.calculationError
            }
        } else {
            qtcIvcdResult.qtm = Self.noQTm
            qtcIvcdResult.qtmc = Self.noQTmc
            qtcIvcdResult.prelbbbqc = Self.noPreLbbbQTc
        }
        qtcIvcdResult.qtrrqrs = format(name: "QTrr,qrs", value:  qtcIvcd.qtCorrectedForIvcdAndSex())
        return qtcIvcdResult
    }

    private func format(name: String, value: Double) -> String {
        return "\(name) = \(Int(round(value))) msec"
    }
    
}

/// Just a dumb container for the results of the QTc IVCD calculation
struct QTcIvcdResult {
    var qt: String = ""
    var qtc: String = ""
    var jt: String =  ""
    var jtc: String = ""
    var qtm: String = ""
    var qtmc: String = ""
    var qtrrqrs: String = ""
    var prelbbbqc: String = ""
}

//double rateInterval = [self.rateIntervalField.text doubleValue];
//    double qt = [self.qtField.text doubleValue];
//    double qrs = [self.qrsField.text doubleValue];
//    if (rateInterval <= 0 || qt <= 0 || qrs <= 0 || qrs >= qt) {
//        [self showError];
//        return;
//    }
//    else if (qrs < 120) {
//        [self showShortQrsError];
//        return;
//    }
//    double interval;
//    double rate;
//    if (inputIsRate) {
//        interval = 60000.0 / rateInterval;
//        rate = rateInterval;
//    }
//    else {
//        interval = rateInterval;
//        rate = 60000.0 / rateInterval;
//    }
//    // qtc uses Bazett in this module
//    self.qt = (NSInteger)round(qt);
//    self.qtc = [EPSQTMethods qtcFromQtInMsec:qt AndIntervalInMsec:interval UsingFormula:kBazett];
//    self.jt = [EPSQTMethods jtFromQTInMsec:qt andQRSInMsec:qrs];
//    self.jtc = [EPSQTMethods jtCorrectedFromQTInMsec:qt andIntervalInMsec:interval withQRS:qrs];
//    if (self.lbbbSwitch.on) {
//        self.qtm = [EPSQTMethods qtCorrectedForLBBBFromQTInMSec:qt andQRSInMsec:qrs];
//        self.qtmc = [EPSQTMethods qtcFromQtInMsec:self.qtm AndIntervalInMsec:interval UsingFormula:kBazett];
//    }
//    self.qtrrqrs = [EPSQTMethods qtCorrectedForIVCDAndSexFromQTInMsec:qt AndHR:rate AndQRS:qrs IsMale:[self isMale]];
//    self.prelbbbqtc = [EPSQTMethods prelbbbqtcFromQTInMsec:qt andIntervalInMsec:interval withQRS:qrs isMale:[self isMale]];
//    [self performSegueWithIdentifier:@"QTcIVCDResultsSegue" sender:nil];

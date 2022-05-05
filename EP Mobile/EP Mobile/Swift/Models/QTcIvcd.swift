//
//  QTcIvcd.swift
//  EP Mobile
//
//  Created by David Mann on 5/5/22.
//  Copyright © 2022 EP Studios. All rights reserved.
//

import MiniQTc

struct QTcIvcd {
    private static let noQTm = "QTm only defined for LBBB"
    private static let noQTmc = "QTmc only defined for LBBB"
    private static let noPreLbbbQTc = "preLBBBQTc only defined for LBBB"
    private static let qtm_Reference = "Bogossian H et al. New formula for evaluation of the QT interval in patients with left bundle branch block. Heart Rhythm 2004;11:2273-2277."
    private static let qtRRQrsFormula = "QTrr,qrs = QT - 155 x (60/HR - 1) - 0.93 x (QRS - 139) + k, k = -22 ms for men and -34 ms for women"
    private static let qtRRQrsReference = "Rautaharju P et al. Assessment of prolonged QT and JT intervals in ventricular conduction defects.  Amer J Cardio 2003;93:1017-1021."
    private static let qtcReference = "Rautaharju P et al. Circulation. 2009;119:e241-e250."
    private static let preLbbbQtcFormula = "preLBBBQTc = postLBBBQTc(Bazett) - postLBBBQRS + c, where c = 95 msec in males, 88 msec in females"
    private static let preLbbbQtcReference = "Yankelson L, Hochstadt A, Sadeh B, et al. New formula for defining “normal” and “prolonged” QT in patients with bundle branch block. Journal of Electrocardiology. 2018;51(3):481-486. doi:10.1016/j.jelectrocard.2017.12.039"

    private var qt: Double
    private var qrs: Double
    private var hr: Double
    private var sex: Sex

//+ (NSInteger)qtCorrectedForLBBBFromQTInMSec:(double)qt andQRSInMsec:(double)qrs{
//    double result = qt - (qrs * 0.485);
//    return (NSInteger)round(result);
//}
//
//+ (NSInteger)jtFromQTInMsec:(double)qt andQRSInMsec:(double)qrs {
//    return (NSInteger)round(qt - qrs);
//
//}
//
//+ (NSInteger)jtCorrectedFromQTInMsec:(double)qt andIntervalInMsec:(double)rr withQRS:(double)qrs {
//    double result = [self qtcFromQtInMsec:qt AndIntervalInMsec:rr UsingFormula:kBazett];
//    result -= qrs;
//    return (NSInteger)round(result);
//}
//
//+ (NSInteger)qtCorrectedForIVCDAndSexFromQTInMsec:(double)qt AndHR:(double)hr AndQRS:(double)qrs IsMale:(BOOL)isMale {
//    double k = isMale ? -22 : - 34;
//    return (NSInteger)round(qt - 155 * (60/hr -1) - 0.93 * (qrs -139) + k);
//}
//
//+ (NSInteger)prelbbbqtcFromQTInMsec:(double)qt andIntervalInMsec:(double)rr withQRS:(double)qrs isMale:(BOOL)isMale {
//    double k = isMale ? 95 : 88;
//    double qtc = [self qtcFromQtInMsec:qt AndIntervalInMsec:rr UsingFormula:kBazett];
//    return (NSInteger)round(qtc - qrs + k);
//}
//
//+ (NSInteger)roundValueInSecs:(double)value {
//    return (NSInteger)round(value * 1000);
//}
}

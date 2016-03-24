//
//  EPSQTMethods.m
//  EP Mobile
//
//  Created by David Mann on 3/21/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSQTMethods.h"

@implementation EPSQTMethods

+ (NSInteger)qtcFromQtInMsec:(double)qt AndIntervalInMsec:(double)interval UsingFormula:(QTFormula)formula {
    if (interval == 0)
        return 0;   // no divide by zero
    // convert to Seconds
    double intervalInSec = interval / 1000.0;
    double qtInSec = qt / 1000.0;
    double heartRate = 60000.0 / interval;
    double result;
    switch (formula) {
        case kBazett:
            result = qtInSec / sqrt(intervalInSec);
            break;
        case kFridericia:
            result = qtInSec / cbrt(intervalInSec);
            break;
        case kSagie:
            result = qtInSec + 0.154 * (1.0 - intervalInSec);
            break;
        case kHodges:
            result = qtInSec + ((1.75 * (heartRate - 60) / 1000));
            break;
        default:
            result = 0;
            break;
    }
    // convert result back to msec, no decimals
    return [self roundValueInSecs:result];
}

+ (NSInteger)qtCorrectedForLBBBFromQTInMSec:(double)qt andQRSInMsec:(double)qrs{
    double result = (double)qt - ((double)qrs * 0.485);
    return (NSInteger)round(result);
}

+ (NSInteger)jtFromQTInMsec:(double)qt andQRSInMsec:(double)qrs {
    return (NSInteger)round(qt - qrs);
    
}

+ (NSInteger)jtCorrectedFromQTInMsec:(double)qt andIntervalInMsec:(double)rr withQRS:(double)qrs {
    double result = [self qtcFromQtInMsec:qt AndIntervalInMsec:rr UsingFormula:kBazett];
    result -= qrs;
    return (NSInteger)round(result);
}

+ (NSInteger)qtCorrectedForIVCDAndSexFromQTInMsec:(double)qt AndHR:(double)hr AndQRS:(double)qrs IsMale:(BOOL)isMale {
    double k = isMale ? -22 : - 34;
    return (NSInteger)round(qt - 155 * (60/hr -1) - 0.93 * (qrs -139) + k);
}

+ (NSInteger)roundValueInSecs:(double)value {
    return (NSInteger)round(value * 1000);
}

@end

//
//  EPSQTMethods.h
//  EP Mobile
//
//  Created by David Mann on 3/21/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSQTMethods : NSObject

typedef enum {
    kBazett = 0,
    kFridericia,
    kSagie,
    kHodges
} QTFormula;

+ (NSInteger)qtcFromQtInMsec:(NSInteger)qt AndIntervalInMsec:(NSInteger)interval UsingFormula:(QTFormula)formula;
+ (NSInteger)qtCorrectedForLBBBFromQTInMSec:(NSInteger)qt andQRSInMsec:(NSInteger)qrs;
+ (NSInteger)jtCorrectedFromQTInMsec:(double)qt andIntervalInMsec:(double)rr withQRS:(double)qrs;
+ (NSInteger)jtFromQTInMsec:(double)qt andQRSInMsec:(double)qrs;
+ (NSInteger)qtCorrectedForIVCDAndSexFromQTInMsec:(double)qt AndHR:(double)hr AndQRS:(double)qrs IsMale:(BOOL)isMale;


@end

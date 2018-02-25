//
//  EPSCMSViewModel.h
//  EP Mobile
//
//  Created by David Mann on 2/22/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPSCMSModel.h"

@interface EPSCMSViewModel : NSObject

- (NSString *)getMessage;
- (NSString *)getMessageFromResult:(struct Result)result;
- (id)initWithSusVT:(BOOL)susVT cardiacArrest:(BOOL)cardiacArrest
            priorMI:(BOOL)priorMI icm:(BOOL)icm nicm:(BOOL)nicm
  highRiskCondition:(BOOL)highRiskCondition icdAtEri:(BOOL)icdAtEri
     transplantList:(BOOL)transplantList ef:(EF)ef
               nyha:(Nyha)nyha cabgWithin3Months:(BOOL)cabgWithin3Months
     miWithin40Days:(BOOL)miWithin40Days candidateForRevasc:(BOOL)candidateForRevasc
   cardiogenicShock:(BOOL)cardiogenicShock nonCardiacDisease:(BOOL)nonCardiacDisease
        brainDamage:(BOOL)brainDamage uncontrolledSvt:(BOOL)uncontrolledSvt;

@end

//
//  EPSDrugCalculatorNotes.m
//  EP Mobile
//
//  Created by David Mann on 2/24/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import "EPSDrugCalculatorNotes.h"

@implementation EPSDrugCalculatorNotes
- (NSString *)noteText {
    return @"Do not rely on drug dose calculators unless you are fully familiar with these drugs and their dosing.  More detailed information on drug doses can be found in the Reference and Tools | Drug Reference module, which includes a creatinine clearance calculator.  Also note that the doses calculated for the oral anticoagulant drugs are only for the treatment of non-valvular atrial fibrillation, not for other indications, such as DVT or PE.  Other factors not included in these calculators, such as pregnancy, nursing, liver dysfunction, concomitant drug use and adverse reactions can affect drug dosage.";
}

- (NSString *)titleText {
    return @"Drug Calculator Notes";
}

- (NSString *)labelText {
    return @"Warning";
}

@end

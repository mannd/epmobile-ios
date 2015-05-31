//
//  EPSWarfarinNotes.m
//  EP Mobile
//
//  Created by David Mann on 10/3/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWarfarinNotes.h"

@implementation EPSWarfarinNotes
-(NSString *)noteText {
    return @"This calculator can be used to adjust the warfarin dose when a patient is on a stable weekly dosing schedule. It should not be used when first starting warfarin. Select the tablet dose the patient uses and the target INR.  Enter the measured INR and the total number of mg the patient is taking per week (e.g. a patient taking 5 mg daily takes 5 x 7 = 35 mg of warfarin per week).  The calculator will determine the percentage weekly dose increase or decrease that is likely to bring the INR back into the target range.  When it is feasible, the calculator will suggest the number of tablets to take each day of the week to achieve the INR goal. An upper and lower range of dosing will be given; in some cases, when dosing changes are small, the upper and lower range will be identical. When there is a range of doses, you might decide to use the higher or lower dose depending on other factors, such as the patient\'s previous response to dosing changes or the patient\'s age.  Warfarin dosing is not an exact science!\n\nReference: Horton J, Bushwick B: American Family Physician. Feb 1, 1999. http://www.aafp.org/afp/990201ap/635.html";
}

-(NSString *)titleText {
    return @"Warfarin Calculator";
}

-(NSString *)labelText {
    return @"Instructions";
}

@end

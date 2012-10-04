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
    return @"This calculator can be used to adjust the warfarin dose when a patient is on a stable weekly dosing schedule. Select the tablet size, the target INR, the actual INR and the total warfarin dose the patient is taking per week (e.g. 5 mg daily means 35 mg of warfarin per week).  The calculator will determine the weekly dose change that is likely to bring the INR back into the target range.  When it is feasible, the calculator will suggest the number of tablets to take each day of the week.  When there is a range of doses, you might decide to use the higher or lower dose depending on other factors, such as the patient\'s previous response to dosing changes or the patient\'s age.  Warfarin dosing is not an exact science!";
}

-(NSString *)titleText {
    return @"Warfarin Calculator";
}

-(NSString *)labelText {
    return @"Instructions";
}

@end

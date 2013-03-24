//
//  EPSDateCalculatorNotes.m
//  EP Mobile
//
//  Created by David Mann on 3/24/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSDateCalculatorNotes.h"

@implementation EPSDateCalculatorNotes
-(NSString *)noteText {
    return @"Use this calculator to do date arithmetic.  Set the date wheel to the index date (such as today) and then enter the number of days in the future or past that you are calculating.  You can quickly enter 90, 40 or 30 days by using the segmented control bar.  Turn Subtract Days On to subtract days from the index date.\n\nExample Uses:\n\n90 Days - Number of days after revascularization (e.g. stent or CAGB) before ICD can be implanted.  Note the CMS NCD states 3 months, but this can vary between 90 and 92 days, so 90 days is often quoted as the number of days to wait.  Similarly the guidelines state waiting 90 days after diagnosis of non-ischemic cardiomyopathy before ICD implantation.\n\n40 Days - Number of days to wait after acute myocardial infarction before ICD implantation.\n\n30 Days - Number of days an H&P is valid prior to a procedure.";
}

-(NSString *)titleText {
    return @"Date Calculator";
}

-(NSString *)labelText {
    return @"Instructions";
}

@end

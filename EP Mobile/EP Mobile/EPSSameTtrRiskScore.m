//
//  EPSSameTtrRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 12/4/15.
//  Copyright © 2015 EP Studios. All rights reserved.
//

#import "EPSSameTtrRiskScore.h"
#import "EPSRiskFactor.h"
#import "EP_Mobile-Swift.h"

@implementation EPSSameTtrRiskScore

- (NSString *)getTitle {
    return @"SAMe-TT\u2082R\u2082";
}

- (NSString *)getInstructions {
    return @"This score predicts poor INR control in patients on warfarin.";
}

- (NSArray *)getReferences {
    return [NSArray arrayWithObject:[Reference referenceFromCitation:@"Apostolakis S, Sullivan RM, Olshansky B, Lip GYH. Factors affecting quality of anticoagulation control among patients with atrial fibrillation on warfarin: the SAMe-TT₂R₂ score. Chest. 2013;144(5):1555-1563. doi:10.1378/chest.13-0054"]];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Sex (female)" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age (< 60 years)" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Medical history" withValue:1 withDetails:@"more than 2 of: HTN, DM, CAD/MI, PAD, CHF, prior stroke, pulmonary disease, and hepatic or renal disease"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Treatment: interacting drugs"                                                  withValue:1 withDetails:@"e.g. amiodarone"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Tobacco use" withValue:2 withDetails:@"within 2 years"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Race" withValue:2 withDetails:@"non-Caucasian"]];
    return array;
}

- (NSString *)getMessage:(int)score {
    NSString *message = @"";
    
    if (score < 3) {
        message = [message stringByAppendingString:@"\nPatient likely to have good anticoagulation control on warfarin with high (≥ 65%) TTR (Time in Therapeutic Range)."];
    }
    else {
        message = [message stringByAppendingString:@"\nPatient likely to have poor anticoagulation control on warfarin with low (< 65%) TTR (Time in Therapeutic Range). Improve education regarding anticoagulation control, or consider a new oral anticoagulant instead of warfarin."];
    }
    return [NSString stringWithFormat:@"%@ score = %d\n%@", [self getTitle], score, message];
}

- (CGFloat)rowHeight:(CGFloat)defaultHeight {
    return defaultHeight + 75.0;
}

- (int)detailTextNumberOfLines {
    return 3;
}



@end

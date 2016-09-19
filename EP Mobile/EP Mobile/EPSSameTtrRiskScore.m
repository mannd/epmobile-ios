//
//  EPSSameTtrRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 12/4/15.
//  Copyright © 2015 EP Studios. All rights reserved.
//

#import "EPSSameTtrRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSSameTtrRiskScore

- (NSString *)getTitle {
    return @"SAMe-TT\u2082R\u2082";
}

- (NSString *)getReference {
    return @"Apostolakis S, Sullivan RM, Olshansky B, Lip GYH.  Factors affecting quality of anticoagulation control among patients with atrial fibrillation on warfarin.  The SAMe-TT\u2082R\u2082 Score.  Chest [Internet].  2013 Nov [cited 2015 Dec 2] 144(5):155-1563.  Available from: http://journal.publications.chestnet.org/article.aspx?articleid=1686270";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://journal.publications.chestnet.org/article.aspx?articleid=1686270"];
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

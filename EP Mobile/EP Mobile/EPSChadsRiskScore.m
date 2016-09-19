//
//  EPSChadsRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/4/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSChadsRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSChadsRiskScore
- (NSString *)getTitle {
    return @"CHADS\u2082";
}

- (NSString *)getReference {
    return @"Gage BF, Waterman AD, Shannon W, Boechler M, Rich MW, Radford MJ. Validation of clinical classification schemes for predicting stroke. JAMA [Internet]. 2001 Jun 13 [cited 2014 Jun 6];285(22):2864-70. Available from: http://jama.jamanetwork.com/article.aspx?articleid=193912";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://jama.jamanetwork.com/article.aspx?articleid=193912"];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Congestive heart failure" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP ≥ 140/90 or treated HTN"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Stroke history" withValue:2 withDetails:@"or TIA or thromboembolism"]];
    return array;
}

- (NSString *)getMessage:(int)score {
    float risk = [self getRisk:score];
    NSString *strokeRisk = [[NSString alloc] initWithFormat:@"Annual stroke risk is %1.1f%%", risk];
    NSString *message = @"";
    if (score < 1) {
        message = [message stringByAppendingString:@"\nAnti-platelet drug (e.g. aspirin) or no antithrombic therapy recommended.\n\nCurrent guidelines suggest using CHA\u2082DS\u2082-VASc score to define stroke risk better."];
    }
    else if (score == 1) {
         message = [message stringByAppendingString:@"\nEither anti-platelet drug (e.g. aspirin) or oral anticoagulation (warfarin, dabigatran, rivaroxaban, apixaban or edoxaban) recommended.\n\nCurrent guidelines suggest using CHA\u2082DS\u2082-VASc score to define stroke risk better."];
    }
    else
        message = [message stringByAppendingString:@"\nOral anticoagulation (warfarin, dabigatran, rivaroxaban, apixaban or edoxaban) recommended."];

    return [NSString stringWithFormat:@"%@ score = %d\n%@\n%@", [self getTitle], score, strokeRisk, message];
}

- (float)getRisk:(int)score {
    float risk = 0.0f;
    switch (score) {
        case 0:
            risk = 1.9;
            break;
        case 1:
            risk = 2.8;
            break;
        case 2:
            risk = 4.0;
            break;
        case 3:
            risk = 5.9;
            break;
        case 4:
            risk = 8.5;
            break;
        case 5:
            risk = 12.5;
            break;
        case 6:
            risk = 18.2;
            break;
    }
    return risk;
}




@end

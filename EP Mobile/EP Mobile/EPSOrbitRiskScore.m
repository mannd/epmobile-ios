//
//  EPSOrbitRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 3/13/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSOrbitRiskScore.h"
#import "EPSRiskFactor.h"
#import "EP_Mobile-Swift.h"

@implementation EPSOrbitRiskScore
- (NSString *)getTitle {
    return @"ORBIT";
}

- (NSArray *)getReferences {
    return [NSArray arrayWithObject:[Reference referenceFromCitation:@"O’Brien EC, Simon DN, Thomas LE, et al. The ORBIT bleeding score: a simple bedside score to assess bleeding risk in atrial fibrillation. Eur Heart J. 2015;36(46):3258-3264. doi:10.1093/eurheartj/ehv476"]];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Anemia or hx anemia" withValue:2 withDetails:@"Hgb < 13 mg/dL male, < 12 mg/dL female"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Bleeding hx" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Renal insufficiency" withValue:1 withDetails:@"eGFR < 60 mg/dL/1.73 m²"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Antiplatelet treatment" withValue:1]];
    return array;
}

- (NSString *)getMessage:(int)score {
    float risk = [self getRisk:score];
    // below shouldn't happen, but...
    if (risk < 1.0) {
        return @"Error calculating risk";
    }
    NSString *bleedingRisk = [[NSString alloc] initWithFormat:@"Bleeding risk is %1.1f bleeds per 100 patient-years.", risk];
    NSString *message = @"";
    if (score <= 2) {
        message = [message stringByAppendingString:@"Low bleeding risk."];
    }
    else if (score == 3) {
        message = [message stringByAppendingString:@"Medium bleeding risk."];
    }
    else {
        message = [message stringByAppendingString:@"High bleeding risk."];
    }
    return [NSString stringWithFormat:@"%@ score = %d\n%@\n%@", [self getTitle], score, message, bleedingRisk];
    
}

- (float)getRisk:(int)score {
    float risk = 0.0f;
    switch (score) {
        case 0:
        case 1:
        case 2:
            risk = 2.4;
            break;
        case 3:
            risk = 4.7;
            break;
        case 4:
        case 5:
        case 6:
        case 7:
            risk = 8.1;
            break;
        default:
            break;
    }
    return risk;
}

@end

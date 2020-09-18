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
    return @"Friberg L, Rosenqvist M, Lip GYH. Evaluation of risk stratification schemes for ischaemic stroke and bleeding in 182 678 patients with atrial fibrillation: the Swedish Atrial Fibrillation cohort study. Eur Heart J. 2012;33(12):1500-1510. doi:10.1093/eurheartj/ehr488";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"https://academic.oup.com/eurheartj/article/33/12/1500/473502"];
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
    float *risks = [self getRisk:score];
    NSString *strokeRisk = [[NSString alloc] initWithFormat:@"Annual stroke risk is %1.1f%%", *risks];
    NSString *neuroRisk = [[NSString alloc] initWithFormat:@"Annual stroke/TIA/peripheral emboli risk is %1.1f%%%", *(risks + 1)];
    NSString *message = @"";
    if (score < 1) {
        message = [message stringByAppendingString:@"\nAnti-platelet drug (e.g. aspirin) or no antithrombic therapy recommended.\n\nCurrent guidelines suggest using CHA\u2082DS\u2082-VASc score to define stroke risk better."];
    }
    else if (score == 1) {
         message = [message stringByAppendingString:@"\nEither anti-platelet drug (e.g. aspirin) or oral anticoagulation (warfarin, dabigatran, rivaroxaban, apixaban or edoxaban) recommended.\n\nCurrent guidelines suggest using CHA\u2082DS\u2082-VASc score to define stroke risk better."];
    }
    else
        message = [message stringByAppendingString:@"\nOral anticoagulation (warfarin, dabigatran, rivaroxaban, apixaban or edoxaban) recommended."];

    return [NSString stringWithFormat:@"%@ score = %d\n%@\n%@\n%@", [self getTitle], score, strokeRisk, neuroRisk, message];
}

- (float *)getRisk:(int)score {
    float risk = 0.0f;
    float neuroRisk = 0.0f;
    static float result[2];
    switch (score) {
        case 0:
            risk = 0.6;
            neuroRisk = 0.9;
            break;
        case 1:
            risk = 3.0;
            neuroRisk = 4.3;
            break;
        case 2:
            risk = 4.2;
            neuroRisk = 6.1;
            break;
        case 3:
            risk = 7.1;
            neuroRisk = 9.9;
            break;
        case 4:
            risk = 11.1;
            neuroRisk = 14.9;
            break;
        case 5:
            risk = 12.5;
            neuroRisk = 16.7;
            break;
        case 6:
            risk = 13.0;
            neuroRisk = 17.2;
            break;
    }
    result[0] = risk;
    result[1] = neuroRisk;
    return result;
}

@end

//
//  EPSHemorrhagesRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/10/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSHemorrhagesRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSHemorrhagesRiskScore
- (NSString *)getTitle {
    return @"HEMORR\u2082HAGES";
}

- (NSString *)getInstructions {
    return @"Use this score to determine the risk of bleeding in patients on warfarin for atrial fibrillation.";
}

- (NSString *)getReference {
    return @"Gage BF, Yan Y, Milligan PE, et al. Clinical classification schemes for predicting hemorrhage: results from the National Registry of Atrial Fibrillation (NRAF). Am Heart J. 2006;151(3):713-719.\n[doi:10.1016/j.ahj.2005.04.017](https://doi.org/10.1016/j.ahj.2005.04.017)";
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hepatic or renal disease" withValue:1 withDetails:@"cirrhosis, 2x AST/ALT, alb < 3.6, CrCl < 30"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Ethanol use" withValue:1 withDetails:@"EtOH abuse, EtOH related illness"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Malignancy" withValue:1 withDetails:@"recent metastatic cancer"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Older" withValue:1 withDetails:@"Age > 75 years"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Reduced platelet count or function" withValue:1 withDetails:@"plts < 75K, antiplatelet drugs"]];
    
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Rebleeding" withValue:2 withDetails:@"prior bleed requiring hospitalizaiton"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP not currently controlled, > 160"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Anemia" withValue:1 withDetails:@"most recent Hct < 30, Hgb < 10"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Genetic factors" withValue:1 withDetails:@"CYP2C9*2 and/or CYP2C9*3"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Elevated fall risk" withValue:1 withDetails:@"e.g. Alzheimer, Parkinson, schizophrenia"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Stroke" withValue:1]];
    return array;
}

- (NSString *)getMessage:(int)score {
    NSString *message = @"";
    if (score < 2)
        message = @"Low bleeding risk";
    else if (score < 4)
        message = @"Intermediate bleeding risk";
    else
        message = @"High bleeding risk";
    float risk =[self getRisk:score];
    
    NSString *resultMessage = [[NSString alloc] initWithFormat:@"HEMORR\u2082HAGES score = %d\n%@\nBleeding risk is %1.1f bleeds per 100 patient-years.", score, message, risk];
    return resultMessage;
}


- (float)getRisk:(int)score {
    float risk = 0.0f;
    switch (score) {
        case 0:
            risk = 1.9;
            break;
        case 1:
            risk = 2.5;
            break;
        case 2:
            risk = 5.3;
            break;
        case 3:
            risk = 8.4;
            break;
        case 4:
            risk = 10.4;
            break;
    }
    if (score >= 5)
        risk = 12.3;
    return risk;
}


@end

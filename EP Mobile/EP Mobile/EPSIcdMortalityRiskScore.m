//
//  EPSIcdMortalityRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 9/15/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSIcdMortalityRiskScore.h"
#import "EPSRiskFactor.h"
#import "EP_Mobile-Swift.h"

#define WARNING_MSG @"Results based on MADIT-II study population, in brief, EF ≤ 30%, prior MI, excluding NYHA class IV, recent MI/CABG, renal failure and others.  See Reference for details."


@implementation EPSIcdMortalityRiskScore

static int HIGH_RISK = 99;

struct RiskResult {
    int conv;
    int icd;
};

- (NSString *)getTitle {
    return @"ICD Mortality Risk";
}

- (NSString *)getScoreName {
    return @"ICD mortality risk";
}

- (NSString *)getInstructions {
    return @"Use this score to determine the mortality with and without ICD implantation in MADIT-II type patients.";
}

- (NSArray *)getReferences {
    return [NSArray arrayWithObject:[Reference referenceFromCitation:@"Goldenberg I, Vyas AK, Hall WJ, et al. Risk Stratification for Primary Implantation of a Cardioverter-Defibrillator in Patients With Ischemic Left Ventricular Dysfunction. Journal of the American College of Cardiology. 2008;51(3):288-296. doi:10.1016/j.jacc.2007.08.058"]];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Very High Risk group" withValue:HIGH_RISK withDetails:@"defined by BUN ≥ 50 or Cr ≥ 2.5 mg/dl"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"NYHA class > II" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age > 70 years" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"BUN > 26 mg/dl" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"QRS > 0.12 sec" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Atrial fibrillation" withValue:1 withDetails:@"as baseline rhythm"]];
    return array;
}

- (NSString *)getMessage:(int)score {
    struct RiskResult risk = [self getRisk:score];
    NSString *message = @"";
    if (score >= HIGH_RISK) {
        message = [NSString stringWithFormat:@"\nIn the Very High Risk group there is high (50%%) 2 year mortality in MADIT-II type patients regardless of therapy (conventional therapy %d%%, ICD %d%% mortality).", risk.conv, risk.icd];
        return [NSString stringWithFormat:@"Very High Risk group\n\n%@\n\n%@", message, WARNING_MSG];
    }
    else {
        message = [NSString stringWithFormat:@"The 2 year mortality risk in MADIT-II type patients with conventional therapy is %d%%, and with ICD therapy is %d%%.", risk.conv,risk.icd];
        return [NSString stringWithFormat:@"%@ score = %d\n\n%@\n\n%@", [self getScoreName], score, message, WARNING_MSG];
    }
}

- (struct RiskResult)getRisk:(int)score {
    struct RiskResult riskResult = {0, 0};
    if (score >= HIGH_RISK) {
        riskResult.conv = 43;
        riskResult.icd = 51;
        return riskResult;
    }
    switch (score) {
        case 0:
            riskResult.conv = 8;
            riskResult.icd = 7;
            break;
        case 1:
            riskResult.conv = 22;
            riskResult.icd = 9;
            break;
        case 2:
            riskResult.conv = 32;
            riskResult.icd = 15;
            break;
        case 3:
        case 4:
        case 5:
            riskResult.conv = 32;
            riskResult.icd = 29;
            break;

    }
    return riskResult;
}

@end

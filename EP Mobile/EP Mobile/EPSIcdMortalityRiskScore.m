//
//  EPSIcdMortalityRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 9/15/16.
//  Copyright © 2016 EP Studios. All rights reserved.
//

#import "EPSIcdMortalityRiskScore.h"
#import "EPSRiskFactor.h"

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

- (NSString *)getReference {
    return @"Goldenberg I, Vyas AK, Hall WJ, Moss AJ, Wang H, He H, Zareba W, McNitt S, Andrews ML, MADIT-II Investigators.  Risk stratification for primary implantation of a cardioverter-defibrillator in patients with ischemic left ventricular dysfunction.  J Am Coll Cardiol [Internet] 2008 Jan [cited 2016 Sep 1];51(3):288-296.  Available from http://content.onlinejacc.org/article.aspx?articleid=1187155";
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Very high risk" withValue:HIGH_RISK withDetails:@"BUN ≥ 50 or Cr ≥ 2.5 mg/dl"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"NYHA class > II" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age > 70 years" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"BUN > 26 mg/dl" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"QRS > 0.12 sec" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"AFB baseline rhythm" withValue:1]];
    return array;
}

- (NSString *)getMessage:(int)score {
    struct RiskResult risk = [self getRisk:score];
    NSString *message = @"";
    if (score >= HIGH_RISK) {
        message = [NSString stringWithFormat:@"\nIn the Very High Risk group there is high (50%%) 2 year mortality regardless of therapy (Conventional therapy %d%%, ICD %d%% mortality).", risk.conv, risk.icd];
        return [NSString stringWithFormat:@"Very High Risk group\n\n%@", message];
    }
    else {
        message = [NSString stringWithFormat:@"The 2 year mortality risk with Conventional therapy is %d%%, with ICD is %d%%.", risk.conv,risk.icd];
        return [NSString stringWithFormat:@"%@ score = %d\n\n%@", [self getScoreName], score, message];
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

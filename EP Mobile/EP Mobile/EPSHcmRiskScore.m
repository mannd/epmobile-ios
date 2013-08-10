//
//  EPSHcmRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/10/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSHcmRiskScore.h"
#import "EPSRiskFactor.h"

// used to distinguish specially handled risk factor in HCM
#define HIGHEST_RISK_SCORE 100
#define SCD_RISK_SCORE 0
#define SUSTAINED_VT_RISK_SCORE 1

@implementation EPSHcmRiskScore
-(NSString *)getTitle {
    return @"Hypertrophic CM";
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Major criteria
    // will be able to tease out major and minor because major 1 order of magnitude higher
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Cardiac arrest" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Spontaneous sustained VT" withValue:10 ]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Family history" withValue:10 withDetails:@"of premature sudden death"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Unexplained syncope" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"LV thickness ≥ 3 cm" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Abnormal BP response to exercise" withValue:10 withDetails:@"failure of BP to rise with exercise"]];
    
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Nonsustained VT" withValue:10]];
    // Minor criteria
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Atrial fibrillation" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Myocardial ischemia" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"LV outflow obstruction" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"High risk mutation" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Elevated fall risk" withValue:1 withDetails:@"e.g. Alzheimer, Parkinson, schizophrenia"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Stroke" withValue:1]];              return array;
}

- (int)calculateScore:(NSMutableArray *)risks {
    int result = 0;
    // cardiac arrest and VT treated specially
    if ([[risks objectAtIndex:SCD_RISK_SCORE] selected]
        || [[risks objectAtIndex:SUSTAINED_VT_RISK_SCORE] selected])
        result = HIGHEST_RISK_SCORE;
    else
        result = [super calculateScore:risks];
    return result;
    
}

- (NSString *)getMessage:(int)score {
    int minorScore = 0;
    int majorScore = 0;
    // extract major and minor risks
    majorScore = score / 10;
    minorScore = score % 10;
    NSLog(@"Major score = %i", majorScore);
    NSLog(@"Minor score = %i", minorScore);
    NSString *resultMessage = @"";
    NSString *message = @"";
    if (score == HIGHEST_RISK_SCORE)
        resultMessage = @"Survivors of cardiac arrest and patients with spontaneous sustained VT are considered at very high risk for SD and are ICD candidates.";
    else {
        message = [[NSString alloc] initWithFormat:@"Major risks = %i\nMinor risks = %i\n", majorScore, minorScore];
        if (majorScore >= 2)
            resultMessage = [message stringByAppendingString:@"Patients with 2 or more major risk factors are considered at high risk and should be considered for ICD implantation."];
        else if (majorScore == 1)
            resultMessage = [message stringByAppendingString:@"Patients with 1 major risk factor have increased risk for SD and recommendations should be individualized. Factors such as the nature of the risk factor (e.g. SD in an immediate family member), young age (which confers greater risk) and presence of minor risk factors should be considered.  ICD implantation can be considered depending on these factors."];
        else // result == 0
            resultMessage = [message stringByAppendingString:@"Patients without any major risk factors (even if minor risk factors are present) are considered to be at low risk for SD. ICD implantation is not recommended."];
    }
    return resultMessage;
}



@end

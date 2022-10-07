//
//  EPSChadsVascRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/10/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSChadsVascRiskScore.h"
#import "EPSRiskFactor.h"

// the 2 mutually exclusive CHADS-VASc risk that must be dealt with specially
#define CHADS_VASC_AGE_75 2
#define CHADS_VASC_AGE_65 6
// also need to deal with female sex if score == 1
#define CHADS_VASC_FEMALE 7

@implementation EPSChadsVascRiskScore

- (NSString *)getTitle {
    return @"CHA\u2082DS\u2082-VASc";
}

- (NSString *)getInstructions {
    return @"Use this score to assess the risk of stroke in patients with atrial fibrillation.";
}

- (NSString *)getReference {
    return @"Friberg L, Rosenqvist M, Lip GYH. Evaluation of risk stratification schemes for ischaemic stroke and bleeding in 182 678 patients with atrial fibrillation: the Swedish Atrial Fibrillation cohort study. Eur Heart J. 2012;33(12):1500-1510.\n[doi:10.1093/eurheartj/ehr488](https://doi.org/10.1093/eurheartj/ehr488)";
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Congestive heart failure" withValue:1 withDetails:@"or left ventricular systolic dysfunction"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP ≥ 140/90 or treated HTN"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Stroke history" withValue:2 withDetails:@"or TIA or thromboembolism"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Vascular disease" withValue:1 withDetails:@"e.g. PAD, MI, aortic plaque"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 65 years" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Sex category" withValue:1 withDetails:@"female sex"]];
    return array;
}

- (int)calculateScore:(NSMutableArray *)risks {
    int score = [super calculateScore:risks];
    self.isFemale = [[risks objectAtIndex:CHADS_VASC_FEMALE] isSelected];
    if ([[risks objectAtIndex:CHADS_VASC_AGE_65] isSelected] && [[risks objectAtIndex:CHADS_VASC_AGE_75] isSelected])
        --score;
    return score;
}

- (NSString *)getMessage:(int)score {
    float *risks = [self getRisk:score];
    NSString *strokeRisk = [[NSString alloc] initWithFormat:@"Annual stroke risk is %1.1f%%", *risks];
    NSString *neuroRisk = [[NSString alloc] initWithFormat:@"Annual stroke/TIA/peripheral emboli risk is %1.1f%%", *(risks + 1)];
    NSString *message = @"";
    if (score < 1) {
        message = [message stringByAppendingString:@"\nIt is reasonable to omit antithrombotic therapy."];
    }
    else if (score == 1) {
        message = [message stringByAppendingString:@"\nNo anticoagulation or oral anticoagulation (warfarin, dabigatran, rivaroxaban, apixaban or edoxaban) or aspirin may be considered (2014 AHA/ACC/HRS guidelines)."];
        if (self.isFemale) {
            message = [message stringByAppendingString:@" European Society of Cardiology (2012) recommends considering no antithrombotic therapy when female sex is the only risk factor."];
        }
        else {
        message = [message stringByAppendingString:@" European Society of Cardiology (2012) recommends anticoagulation."];
        }
    }
    else
        message = [message stringByAppendingString:@"\nOral anticoagulation (warfarin, dabigatran, rivaroxaban, apixaban or edoxaban) is recommended."];

    return [NSString stringWithFormat:@"%@ score = %d\n%@\n%@\n%@", [self getTitle], score, strokeRisk, neuroRisk, message];}

- (float *)getRisk:(int)score {
    float risk = 0.0f;
    float neuroRisk = 0.0f;
    static float result[2];
    switch (score) {
        case 0:
            risk = 0.2;
            neuroRisk = 0.3;
            break;
        case 1:
            risk = 0.6;
            neuroRisk = 0.9;
            break;
        case 2:
            risk = 2.2;
            neuroRisk = 2.9;
            break;
        case 3:
            risk = 3.2;
            neuroRisk = 4.6;
            break;
        case 4:
            risk = 4.8;
            neuroRisk = 6.7;
            break;
        case 5:
            risk = 7.2;
            neuroRisk = 10.0;
            break;
        case 6:
            risk = 9.7;
            neuroRisk = 13.6;
            break;
        case 7:
            risk = 11.2;
            neuroRisk = 15.7;
            break;
        case 8:
            risk = 10.8;
            neuroRisk = 15.2;
            break;
        case 9:
            risk = 12.23;
            neuroRisk = 17.4;
            break;
    }
    result[0] = risk;
    result[1] = neuroRisk;
    return result;
}


@end

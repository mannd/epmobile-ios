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

- (NSString *)getReference {
    return @"Lip GY, Frison L, Halperin JL, Lane DA. Identifying patients at high risk for stroke despite anticoagulation: a comparison of contemporary stroke risk stratification schemes in an anticoagulated atrial fibrillation cohort. Stroke [Internet]. 2010 Oct 21 [cited 2014 Jun 6];41:2731-8. Available from: http://stroke.ahajournals.org/content/41/12/2731.full.pdf";
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
    self.isFemale = [[risks objectAtIndex:CHADS_VASC_FEMALE] selected];
    if ([[risks objectAtIndex:CHADS_VASC_AGE_65] selected] && [[risks objectAtIndex:CHADS_VASC_AGE_75] selected])
        --score;
    return score;
}

- (NSString *)getMessage:(int)score {
    float risk = [self getRisk:score];
    NSString *strokeRisk = [[NSString alloc] initWithFormat:@"Annual stroke risk is %1.1f%%", risk];
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
    
    return [NSString stringWithFormat:@"%@ score = %d\n%@\n%@", [self getTitle], score, strokeRisk, message];
}




- (float)getRisk:(int)score {
    float risk = 0.0f;
    switch (score) {
        case 0:
            risk = 0;
            break;
        case 1:
            risk = 1.3;
            break;
        case 2:
            risk = 2.2;
            break;
        case 3:
            risk = 3.2;
            break;
        case 4:
            risk = 4.0;
            break;
        case 5:
            risk = 6.7;
            break;
        case 6:
            risk = 9.8;
            break;
        case 7:
            risk = 9.6;
            break;
        case 8:
            risk = 6.7;
            break;
        case 9:
            risk = 15.2;
            break;
    }
    return risk;
}


@end

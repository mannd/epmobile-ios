//
//  EPSHasBledRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/10/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSHasBledRiskScore.h"
#import "EPSRiskFactor.h"
#import "EP_Mobile-Swift.h"

@implementation EPSHasBledRiskScore
- (NSString *)getTitle {
    return @"HAS-BLED";
}

- (NSString *)getInstructions {
    return @"Use this score to estimate the 1-year risk for major bleeding (intracranial, hospitalization, hemoglobin decrease > 2 g/L, and/or transfusion) in patients with atrial fibrillation.";
}

- (NSArray *)getReferences {
    return [NSArray arrayWithObject:[Reference referenceFromCitation:@"Pisters R, Lane DA, Nieuwlaat R, de Vos CB, Crijns HJGM, Lip GYH. A novel user-friendly score (HAS-BLED) to assess 1-year risk of major bleeding in patients with atrial fibrillation: the Euro Heart Survey. Chest. 2010;138(5):1093-1100. doi:10.1378/chest.10-0134"]];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"systolic BP ≥ 160"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Abnormal renal function" withValue:1 withDetails:@"dialysis, kidney transplant, Cr ≥ 2.6 mg/dL"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Abnormal liver function" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Stroke history" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Bleeding history" withValue:1 withDetails:@"or anemia or predisposition to bleeding"]];
    
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Labile INR" withValue:1 withDetails:@"unstable, high or < 60%  therapeutic INRs"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Elderly" withValue:1 withDetails:@"65 years or older"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Drugs" withValue:1 withDetails:@"taking antiplatlet drugs like ASA or clopidogrel"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Alcohol" withValue:1 withDetails:@"8 or more alcoholic drinks per week"]];
    return array;
}

- (NSString *)getMessage:(int)score {
    NSString *message = @"";
    if (score < 3)
        message = @"Low bleeding risk";
    else
        message = @"High bleeding risk";
    NSString *riskString = [self getRisk:score];
    NSString *resultMessage = [[NSString alloc] initWithFormat:@"HAS-BLED score = %d\n%@\nBleeding risk is %@ bleeds per 100 patient-years.", score, message, riskString];
    return resultMessage;
}


- (NSString *)getRisk:(int)score {
    NSString *riskString = nil;
    switch (score) {
        case 0:
        case 1:
            riskString = @"1.02-1.13";
            break;
        case 2:
            riskString = @"1.88";
            break;
        case 3:
            riskString = @"3.74";
            break;
        case 4:
            riskString = @"8.70";
            break;
        case 5:
            riskString = @"12.50";
            break;
        case 6:
        case 7:
        case 8:
        case 9:
            riskString = @"> 12.50";
            break;
    }
    return riskString;
}

// Detailed text label not big enough on iPhone 4s
- (CGFloat)rowHeight:(CGFloat)defaultHeight {
    return defaultHeight + 60.0;
}

- (int)detailTextNumberOfLines {
    return 2;
}



@end

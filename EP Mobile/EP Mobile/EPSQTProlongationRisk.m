//
//  EPSQTProlongationRisk.m
//  EP Mobile
//
//  Created by David Mann on 4/6/20.
//  Copyright © 2020 EP Studios. All rights reserved.
//

#import "EPSQTProlongationRisk.h"
#import "EPSRiskFactor.h"
#import "EP_Mobile-Swift.h"

#define QT_PROLONGATION_RISK_NAME @"QT Prolongation Risk"

@implementation EPSQTProlongationRisk
EPSRiskFactor *oneQTcDrug;
EPSRiskFactor *twoQTcDrugs;

- (NSString *)getTitle {
    return QT_PROLONGATION_RISK_NAME;
}

- (NSArray *)getReferences {
    return [NSArray arrayWithObject:[Reference referenceFromCitation:@"Tisdale JE, Jaynes HA, Kingery JR, et al. Development and Validation of a Risk Score to Predict QT Interval Prolongation in Hospitalized Patients. Circulation: Cardiovascular Quality and Outcomes. 2013;6(4):479-487. doi:10.1161/CIRCOUTCOMES.113.000152"]];

}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 68" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Female sex" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Loop diuretic" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Serum potassium ≤ 3.5 mEq/L" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Admission QTc ≥ 450 msec" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Acute MI" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Sepsis" withValue:3]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Heart failure" withValue:3]];
    // These two factors need to be identified to be handled specially during risk score calculation.
    oneQTcDrug = [[EPSRiskFactor alloc] initWith:@"One QTc prolonging drug" withValue:3];
    twoQTcDrugs = [[EPSRiskFactor alloc] initWith:@"Two or more QTc prolonging drugs" withValue:6];
    [array addObject:oneQTcDrug];
    [array addObject:twoQTcDrugs];

    return array;
}


- (int)calculateScore:(NSMutableArray *)risks {
    int score = 0;
    for (int i = 0; i < [risks count]; ++i)
        if ([(EPSRiskFactor *)[risks objectAtIndex:i] isSelected] == YES)
            score += [[risks objectAtIndex:i] points];
    // Two drugs implies one drug, don't allow both to be added to the score.
    if (oneQTcDrug.isSelected && twoQTcDrugs.isSelected) {
        score -= 3;
    }
    return score;
}


- (NSString *)getMessage:(int)score {
    int risk = [self getRisk:score];
    NSString *message = @"";
    if (score < 7) {
        message = [message stringByAppendingString:@"Low"];
    }
    else if (score < 11) {
        message = [message stringByAppendingString:@"Moderate"];
    }
    else {
        message = [message stringByAppendingString:@"High"];
    }
    NSString *qtProlongationRisk = [[NSString alloc] initWithFormat:@"%@ risk (~%d%%) of QT prolongation during hospitalization.", message, risk];
    return [NSString stringWithFormat:@"%@ score = %d\n%@", [self getTitle], score, qtProlongationRisk];
}

- (int)getRisk:(int)score {
    int risk = 0;
    if (score < 7) {
        risk = 15;
    }
    else if (score < 11) {
        risk = 37;
    }
    else {
        risk = 73;
    }
    return risk;
}

@end

//
//  EPSAtriaStrokeRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 12/9/15.
//  Copyright © 2015 EP Studios. All rights reserved.
//

#import "EPSAtriaStrokeRiskScore.h"
#import "EPSRiskFactor.h"

#define PRIOR_STROKE_ITEM 10
#define NO_AGE_SELECTED -1
#define TOO_MANY_AGES_SELECTED -2

@implementation EPSAtriaStrokeRiskScore
- (NSString *)getTitle {
    return @"ATRIA Stroke Risk";
}

- (NSString *)getReference {
    return @"Singer DE, Chang Y, Borowsky LH, Fang MC, Pomernacki NK, Udaltsova N, Reynolds K, Go AS.  A new risk scheme to predict ischemic stroke and other thromboembolism in atrial fibrillation: the ATRIA study stroke risk score. J Am Heart Assoc [Internet]. 2013 Jun 19 [cited 2015 Nov 29];2:3000250.  Available from: http://jaha.ahajournals.org/content/2/3/e000250";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://jaha.ahajournals.org/content/2/3/e000250"];
}


- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 85 years" withValue:6]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age 75 to 84 years" withValue:5]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age 65 to 74 years" withValue:3]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age < 65 years" withValue:0]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Female sex" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Congestive heart failure" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Hypertension" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Proteinuria" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"eGFR < 45 mL/min/1.73 m\u00B2 or ESRD" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Prior stroke" withValue:0]];

    return array;
}

- (NSString *)getMessage:(int)score {
    NSString *message = @"";
    if (score == NO_AGE_SELECTED) {
        return [message stringByAppendingString:@"You must select an age range!"];
    }
    if (score == TOO_MANY_AGES_SELECTED) {
        return [message stringByAppendingString:@"You have selected multiple age ranges! Please just select one!"];
    }
    if (score <= 5) {
        message = [message stringByAppendingString:@"\nLow thromboembolic risk (< 1% per year)."];
    }
    else if (score == 6) {
        message = [message stringByAppendingString:@"\nModerate thromboembolic risk (1 to < 2% per year)."];
    }
    else {
        message = [message stringByAppendingString:@"\nHigh thromboembolic risk (2% or greater per year."];
    }
    return [NSString stringWithFormat:@"ATRIA stroke risk score = %d\n%@", score, message];
    
}

- (int)calculateScore:(NSMutableArray *)risks {
    int score = 0;
    int agesSelected = 0;
    BOOL priorStrokeSelected = NO;
    for (int i = 0; i < [risks count]; ++i) {
        if ([[risks objectAtIndex:i] selected] == YES) {
            if (i <= 3) {
                agesSelected++;
            }
            if (i == PRIOR_STROKE_ITEM) {
                priorStrokeSelected = YES;
            }
            score += [[risks objectAtIndex:i] points];
        }
    }
    // check for problems with age selection
    if (agesSelected == 0) {
        score = NO_AGE_SELECTED;
        return score;
    }
    if (agesSelected > 1) {
        score = TOO_MANY_AGES_SELECTED;
        return score;
    }
    // adjust points for prior stroke (only affects age points)
    if (priorStrokeSelected) {
        for (int i = 0; i < 4; i++) {
            if ([[risks objectAtIndex:i] selected] == YES) {
                switch (i) {
                    case 0:
                        score += 3;
                        break;
                    case 1:
                        score += 2;
                        break;
                    case 2:
                        score += 4;
                        break;
                    case 3:
                        score += 8;
                        break;
                    default:
                        break;
                }
            }
        }
    }
    return score;
}



@end

//
//  EPSBrugadaRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 9/26/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

#import "EPSBrugadaRiskScore.h"
#import "EPSRiskFactor.h"
#import "EPSSharedMethods.h"
#import "EPSLogging.h"

#define NO_ECG_RISK_SCORE 1000

@implementation EPSBrugadaRiskScore

-(NSString *)getTitle {
    return @"Brugada Shanghai Score";
}

- (NSString *)getReference {
    return @"Antzelevitch C, Yan GX, Ackerman MJ, Borggrefe M, Corrado D, Guo J, et al. J-wave syndromes expert consensus conference report: Emerging concepts and gaps in knowledge. J Arrhythmia. [Internet] 2016 Oct [cited 2017 Sep 28];32(5):315-339. Available from: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5063270/";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5063270/"];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Note original points multiplied by 10 to avoid floating point numbers
    // ECG risks multiplied by 1000 to be distinguishable as no risk score without them
    // ECG criteria
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Spontaneous type 1 Brugada ECG pattern at nominal or high leads" withValue:35]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Fever-induced type 1 Brugada ECG pattern at nominal or high leads" withValue:30]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Type 2 or 3 Brugada ECG pattern that converts with provocative drug challenge" withValue:20]];
    // Clinical history
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Unexplained arrest or documented VF/polymorphic VT" withValue:30]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Nocturnal agonal respirations" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Suspected arrhythmic syncope" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Syncope of unclear mechanism/unclear etiology" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Atrial flutter/fibrillation in patients < 30 years without alternative etiology" withValue:5]];
    // Family history
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"First- or second-degree relative with definite Brugada Syndrome" withValue:20]];    
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Suspicious SCD (fever, nocturnal, Brugada aggravating drugs) in first- or second-degree relative" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Unexplained SCD < 45 years in first- or second-degree relative with negative autopsy" withValue:5]];
    // Genetic test result
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Probable pathogenic mutation in Brugada Syndrome susceptibility gene" withValue:5]];

    return array;
}

- (int)calculateScore:(NSMutableArray *)risks {
    NSArray *ecgRisks = [risks subarrayWithRange: NSMakeRange( 0, 3 )];
    NSArray *clinicalRisks = [risks subarrayWithRange:NSMakeRange(3, 5)];
    NSArray *familyRisks = [risks subarrayWithRange:NSMakeRange(8, 3)];
    NSArray *geneticRisks = [risks subarrayWithRange:NSMakeRange(11, 1)];
    int ecgPoints = [self findMaxPoints:ecgRisks];
    if (ecgPoints == 0) {
        return NO_ECG_RISK_SCORE;
    }
    return ecgPoints +
        [self findMaxPoints:clinicalRisks] +
        [self findMaxPoints:familyRisks] +
        [self findMaxPoints:geneticRisks];
}

- (int)findMaxPoints:(NSArray *)risks {
    int result = 0;
    for (EPSRiskFactor *risk in risks) {
        if (risk.selected && (risk.points > result)) {
            result = (int)risk.points;
        }
    }
    return result;
}

// Overriden from EPSRiskScore to use risk details instead of name
- (NSArray *)risksSelected:(NSArray *)risks {
    if ([risks count] == 0) {
        return nil;
    }
    NSMutableArray *selected = [[NSMutableArray alloc] init];
    for (int i = 0; i < [risks count]; ++i) {
        if ([[risks objectAtIndex:i] selected] == YES) {
            [selected addObject:[[risks objectAtIndex:i] details]];
        }
    }
    return selected;
}


- (NSString *)getMessage:(int)score {
    if (score == NO_ECG_RISK_SCORE) {
        return @"Score requires at least 1 ECG finding.";
    }
    double riskScore = score / 10.0;
    NSString *message = [NSString stringWithFormat:@"Risk score = %@\n", [EPSSharedMethods trimmedZerosFromNumber:riskScore]];
    if (riskScore >= 3.5) {
      message = [message stringByAppendingString:@"Probable/definite Brugada Syndrome"];
    }
    else if (riskScore >= 2) {
      message = [message stringByAppendingString:@"Possible Brugada Syndrome"];
    }
    else {
      message = [message stringByAppendingString:@"Non-diagnostic"];
    }
   return message;
}

- (int)numberOfSections {
    return 4;
}

- (int)numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 3;
    else if (section == 1)
        return 5;
    else if (section == 2)
      return 3;
    else if (section == 3)
      return 1;
    else
      return 0;
}

// Each section starts this number of rows after the start of the array
 - (int)getOffset:(NSInteger)section {
     if (section == 1)
         return 3;
     else if (section == 2)
         return 8;
     else if (section == 3)
         return 11;
     else
         return 0;
 }

- (CGFloat)rowHeight:(CGFloat)defaultHeight {
    return defaultHeight + 50.0;
}

- (int)detailTextNumberOfLines {
    return 3;
}


- (NSString *)getTitleForHeaderSection:(NSInteger)section {
    if (section == 0)
        return @"ECG (12-lead / ambulatory)";
    else if (section == 1)
        return @"Clinical History";
    else if (section == 2)
      return @"Family History";
    else if (section == 3)
      return @"Genetic Test Result";
    else
      return nil;
}

@end

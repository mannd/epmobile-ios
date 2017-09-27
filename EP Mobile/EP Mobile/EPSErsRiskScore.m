//
//  EPSErsRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 9/26/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

#import "EPSErsRiskScore.h"
#import "EPSRiskFactor.h"
#import "EPSLogging.h"

@implementation EPSErsRiskScore

-(NSString *)getTitle {
    return @"ERS Shanghai Score";
}

- (NSString *)getReference {
    return @"Antzelevitch C, Yan GX, Ackerman MJ, Borggrefe M, Corrado D, Guo J, et al. J-wave syndromes expert consensus conference report: Emerging concepts and gaps in knowledge. Heart Rhythm. 2016;13(10):e295-324. Available from: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5063270/";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5063270/"];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Note original points multiplied by 10 to avoid floating point numbers
    // Clinical history
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Unexplained cardiac arrest, documented VF or polymorphic VT" withValue:30]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Suspected arrhythmic syncope" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Syncope of unclear mechanims/unclear etiology" withValue:10]];
    // 12-lead ECG
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"ER ≥ 0.2 mV in ≥ 2 inferior and/or lateral ECG leads with horizontal/descending ST segment ('IIa pattern')" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Dynamic changes in J-point elevation (≥ 0.1 mV) in ≥ 2 inferior and/or lateral leads" withValue:15]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"≥ 0.1 mV J-point elevation in at least 2 inferior and/or lateral ECG leads" withValue:10]];
    // Ambulatory ECG monitoring
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Short-coupled PVCs with R on ascending limb or peak of T wave" withValue:20]];
    // Family history
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Relative with definite ERS" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"≥ 2 first-degree relatives with a IIa ECG pattern as above" withValue:20]];    
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"First-degree relative with a IIa ECG pattern as above" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Unexplained sudden cardiac death < 45 years in a first- or second-degree relative" withValue:5]];
    // Genetic test result
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Probable pathogenic ERS mutation" withValue:5]];

    return array;
}

- (int)calculateScore:(NSMutableArray *)risks {
    NSArray *clinicalRisks = [risks subarrayWithRange:NSMakeRange(0, 3)];
    NSArray *ecgRisks = [risks subarrayWithRange: NSMakeRange(3, 3)];
    NSArray *ambulatoryEcgRisks = [risks subarrayWithRange: NSMakeRange(6, 1)];
    NSArray *familyRisks = [risks subarrayWithRange:NSMakeRange(7, 4)];
    NSArray *geneticRisks = [risks subarrayWithRange:NSMakeRange(11, 1)];
    return [self findMaxPoints:clinicalRisks] +
      [self findMaxPoints:ecgRisks] +
      [self findMaxPoints:ambulatoryEcgRisks] +
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
    double riskScore = score / 10.0;
    NSString *message = [NSString stringWithFormat:@"Risk score = %.1f\n", riskScore];
    if (riskScore >= 5) {
      message = [message stringByAppendingString:@"Probable/definite Early Repolarization Syndrome"];
    }
    else if (riskScore >= 3) {
      message = [message stringByAppendingString:@"Possible Early Repolarization Syndrome"];
    }
    else {
      message = [message stringByAppendingString:@"Nondiagnostic"];
    }
   return message;
}

- (int)numberOfSections {
    return 5;
}

- (int)numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 3;
    else if (section == 1)
        return 3;
    else if (section == 2)
      return 1;
    else if (section == 3)
      return 4;
    else if (section == 4)
      return 1;
    else
      return 0;
}

// Each section starts this number of rows after the start of the array
 - (int)getOffset:(NSInteger)section {
     if (section == 1)
         return 3;
     else if (section == 2)
         return 6;
     else if (section == 3)
         return 7;
     else if (section == 4)
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
        return @"Clinical History";
    else if (section == 1)
        return @"Twelve-lead ECG";
    else if (section == 2)
      return @"Ambulatory ECG Monitoring";
    else if (section == 3)
      return @"Family History";
    else if (section == 4)
      return @"Genetic Test Result";
    else
      return nil;
}

@end


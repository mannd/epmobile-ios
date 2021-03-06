//
//  EPSMartinRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/11/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSMartinRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSMartinRiskScore

- (NSString *)getTitle {
    return @"Martin Algorithm";
}

- (NSString *)getReference {
    return @"Martin TP, Hanusa BH, Kapoor WN.  Risk stratification of patients with syncope. Ann Emerg Med [Internet]. 1997 April [cited 2014 Jun 6];29(4):459-66. Available from: http://www.annemergmed.com/article/S0196-0644(97)70217-8/abstract";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://www.annemergmed.com/article/S0196-0644(97)70217-8/abstract"];
}


- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Abnormal ECG" withValue:1 withDetails:@"New changes or non-sinus rhythm"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"History of ventricular arrhythmia" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"History of CHF" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age > 45 years" withValue:1]];
    return array;
}

- (NSString *)getMessage:(int)score {
    int risk[] = {0, 5, 16, 27, 27 };
    NSString *message = [[NSString alloc] initWithFormat:@"Martin Algorithm Score = %d\n1-year severe arrhythmia or arrhythmic death risk = %d%%", score, risk[score]];
    return message;
}


@end

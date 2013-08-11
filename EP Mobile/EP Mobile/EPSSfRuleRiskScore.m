//
//  EPSSfRuleRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/11/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSSfRuleRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSSfRuleRiskScore

- (NSString *)getTitle {
    return @"SF Rule";
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Abnormal ECG" withValue:1 withDetails:@"New changes or non-sinus rhythm"]];
     [array addObject:[[EPSRiskFactor alloc] initWith:@"Congestive heart failure" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Shortness of breath" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Low Hematocrit" withValue:1 withDetails:@"< 30%"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Low systolic blood pressure" withValue:1 withDetails:@"< 90 mmHg"]];
    return array;
}

@end

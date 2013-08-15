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

- (NSString *)getMessage:(int)score {
    NSString *message = @"";
    if (score < 1)
        message = [message stringByAppendingString:@"No or little risk of serious events at 30 days."];
    else
        message = [message stringByAppendingString:@"Risk of serious events at 30 days (98% sensitive and 56% specific."];
    NSString *resultMessage = [[NSString alloc] initWithFormat:@"SF Rule Score %@\n%@", (score > 0 ? @"\u2265 1." : @"= 0."), message];
    return resultMessage;
}

@end

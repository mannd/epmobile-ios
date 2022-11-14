//
//  EPSSfRuleRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/11/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSSfRuleRiskScore.h"
#import "EPSRiskFactor.h"
#import "EP_Mobile-Swift.h"

@implementation EPSSfRuleRiskScore

- (NSString *)getTitle {
    return @"SF Rule";
}

- (NSString *)getInstructions {
    return @"Use this rule to assess the risk of serious events within 30 days of presentation with syncope.";
}

- (NSArray *)getReferences {
    return [NSArray arrayWithObject:[Reference referenceFromCitation:@"Quinn J, McDermott D, Stiell I, Kohn M, Wells G. Prospective validation of the San Francisco Syncope Rule to predict patients with serious outcomes. Ann Emerg Med. 2006;47(5):448-454. doi:10.1016/j.annemergmed.2005.11.019"]];

}

- (NSString *)getReference {
    return @"Quinn J, McDermott D, Stiell I, Kohn M, Wells G. Prospective validation of the San Francisco Syncope rule to predict patients with serious outcomes. 2006 May [cited 2014 Jun 6];47(5):448-54. Available from: http://www.annemergmed.com/article/S0196-0644(05)01959-1/abstract";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://www.annemergmed.com/article/S0196-0644(05)01959-1/abstract"];
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
        message = [message stringByAppendingString:@"Risk of serious events at 30 days (98% sensitive and 56% specific)."];
    NSString *resultMessage = [[NSString alloc] initWithFormat:@"SF Rule Score %@\n%@", (score > 0 ? @"\u2265 1." : @"= 0."), message];
    return resultMessage;
}

@end

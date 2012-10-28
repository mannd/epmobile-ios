//
//  EPSModifiedArrudaAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 10/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSModifiedArrudaAlgorithm.h"

@implementation EPSModifiedArrudaAlgorithm

- (NSString *)name {
    return @"Modified Arruda Algorithm";
}

- (NSString *)yesResult:(int *)step {
    if (*step == 1) {
        [self adjustStepsForward:*step];
        *step = 6;
        return [self getQuestion:*step];
    }
    else
        return [super yesResult:step];
        
}

@end

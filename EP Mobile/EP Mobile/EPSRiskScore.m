//
//  EPSRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/4/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSRiskScore
// This is essentially an abstract class with some default methods
// implemented.

- (NSString *)getTitle {
    return nil;
}

- (NSString *)getScoreName {
    return [self getTitle];
}

- (NSMutableArray *)getArray {
    return nil;
}

- (NSString *)getRisk {
    return nil;
}

- (NSString *)getTitleForHeaderSection {
    return nil;
}

- (int)getOffset {
    return 0;
}

- (int)calculateScore:(NSMutableArray *)risks {
// default assumes just add points of risk scores
    int score = 0;
    for (int i = 0; i < [risks count]; ++i)
        if ([[risks objectAtIndex:i] selected] == YES)
            score += [[risks objectAtIndex:i] points];
    return score;
}

- (NSString *)getResultMessage:(NSMutableArray *)risks {
    return nil;
}
@end

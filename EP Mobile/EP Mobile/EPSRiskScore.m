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

- (NSString *)getTitleForHeaderSection:(int)section {
    return nil;
}

- (int)getOffset:(int)section {
    // default 1 section, no offset
    return 0;
}

- (int)numberOfSections {
    return 1;
}

- (int)numberOfRowsInSection:(int)section {
    // if returns 0 calling function will assume only one section
    return 0;
}

- (CGFloat)rowHeight:(CGFloat)defaultHeight {
    // default behavior just passes back passed in height
    return defaultHeight;
}

- (void)formatCell:(UITableViewCell *)cell {
    // default doesn't change cell
    return;
}

- (int)calculateScore:(NSMutableArray *)risks {
// default assumes just add points of risk scores
    int score = 0;
    for (int i = 0; i < [risks count]; ++i)
        if ([[risks objectAtIndex:i] selected] == YES)
            score += [[risks objectAtIndex:i] points];
    return score;
}

- (NSString *)getMessage:(int)score {
    return nil;
}
@end

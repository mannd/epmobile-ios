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

- (NSString *)getTitleForHeaderSection:(NSInteger)section {
    return nil;
}

- (int)getOffset:(NSInteger)section {
    // default 1 section, no offset
    return 0;
}

- (int)numberOfSections {
    return 1;
}

- (int)numberOfRowsInSection:(NSInteger)section {
    // if returns 0 calling function will assume only one section
    return 0;
}

- (CGFloat)rowHeight:(CGFloat)defaultHeight {
    // default behavior just passes back passed in height
    return defaultHeight;
}

- (int)detailTextNumberOfLines {
    return 1;
}

- (void)formatCell:(UITableViewCell *)cell {
    // default doesn't change cell
    return;
}

- (int)calculateScore:(NSMutableArray *)risks {
// default assumes just add points of risk scores
    int score = 0;
    for (int i = 0; i < [risks count]; ++i)
        if ([(EPSRiskFactor *)[risks objectAtIndex:i] isSelected] == YES)
            score += [[risks objectAtIndex:i] points];
    return score;
}

- (NSString *)getMessage:(int)score {
    return nil;
}

- (NSString *)getReference {
    return nil;
}

- (NSArray *)risksSelected:(NSArray *)risks {
    if ([risks count] == 0) {
        return nil;
    }
    NSMutableArray *selected = [[NSMutableArray alloc] init];
    for (int i = 0; i < [risks count]; ++i) {
        if ([(EPSRiskFactor *)[risks objectAtIndex:i] isSelected] == YES) {
            [selected addObject:[[risks objectAtIndex:i] name]];
        }
    }
    return selected;
}

- (NSString *)getFullRiskReportFromMessage:(NSString *)message andRisks:(NSArray *)risks {
    NSString *riskList = [EPSRiskScore formatRisks:risks];
    NSString *report = @"Risk score: ";
    report = [report stringByAppendingString:[self getTitle]];
    report = [report stringByAppendingString:@"\nRisks: "];
    report = [report stringByAppendingString:riskList];
    report = [report stringByAppendingString:@"\n"];
    report = [report stringByAppendingString:message];
    report = [report stringByAppendingString:@"\nReference: "];
    report = [report stringByAppendingString:[self getReference]];
    report = [report stringByAppendingString:@"\n"];
    // eliminate blank lines
    report = [report stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    return report;
}

+ (NSString *)formatRisks:(NSArray *)risks {
    NSString *riskString = @"None";
    if (risks != nil && [risks count] != 0) {
        riskString = [risks componentsJoinedByString:@", "];
    }
    return riskString;
}

- (NSURL *)getReferenceLink {
    return nil;
}


@end

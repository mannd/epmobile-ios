//
//  EPSEgsysRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/11/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSEgsysRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSEgsysRiskScore
- (NSString *)getTitle {
    return @"EGSYS Score";
}

- (NSString *)getReference {
    return @"Del Rosso A, Ungar A, Maggi R, Giada F, Petix NR, De Santo T, Menozzi C, Brignole M. Clinical predictors of cardiac syncope at initial evaluation in patients referred urgently to a general hospital: the EGSYS score. Heart [Internet]. 2008 Dec [cited 2014                                                     Jun 6];94(12):1620-6. Available from: http://heart.bmj.com/content/94/12/1620.abstract";
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Palpitations before syncope" withValue:4]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Abnormal ECG or heart disease" withValue:3]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Syncope during effort" withValue:3]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Syncope while supine" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Autonomic prodrome" withValue:-1 withDetails:@"Nausea or vomiting"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Predisposing and/or precipitating factors" withValue:-1 withDetails:@"warm/crowded place, prolonged standing, fear, pain, emotion"]];
    return array;
}

- (NSString *)getMessage:(int)score {
    int mortalityRisk = 0;
    int syncopeRisk = 0;
    if (score < 3) {
        mortalityRisk = 2;
        syncopeRisk = 2;
    }
    else
        mortalityRisk = 21;
    if (score == 3)
        syncopeRisk = 13;
    if (score == 4)
        syncopeRisk = 33;
    if (score > 4)
        syncopeRisk = 77;
    NSString *message = [[NSString alloc] initWithFormat:@"EGSYS Score = %d\n2-year total mortality = %d%%\nCardiac syncope probability = %d%%", score, mortalityRisk, syncopeRisk];
    return message;
}

- (CGFloat)rowHeight:(CGFloat)defaultHeight {
    return 80;  // larger row height for this risk score
}

- (void)formatCell:(UITableViewCell *)cell {
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    //cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
}


@end

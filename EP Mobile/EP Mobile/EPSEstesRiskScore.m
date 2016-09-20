//
//  EPSEstesRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/10/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSEstesRiskScore.h"
#import "EPSRiskFactor.h"

// the 2 mutually exclusive ESTES risks
#define ESTES_STRAIN_WITH_DIG 1
#define ESTES_STRAIN_WITHOUT_DIG 2
#define ESTES_ERROR -1

@implementation EPSEstesRiskScore
-(NSString *)getTitle {
    return @"Estes LVH Score";
}

- (NSString *)getReference {
    return @"Romhilt DW, Estes EH Jr. A point-score system for the ECG diagnosis of left ventricular hypertrophy. Am Heart J. 1968 Jun;75(6):752-8.";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://www.ncbi.nlm.nih.gov/pubmed/4231231"];
}


- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Any limb-lead R or S \u2265 20 mm or S V1 or V2 \u2265 30 mm or R V5 or V6 \u2265 30 mm" withValue:3]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Left ventricular strain pattern without digitalis" withValue:3 withDetails:@"ST-J point depression \u2265 1 mm & inverted T in V5"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Left ventricular strain pattern with digitalis" withValue:1 withDetails:@"ST-J point depression \u2265 1 mm & inverted T in V5"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Left atrial enlargement" withValue:3 withDetails:@"P terminal force in V1 \u2265 1 mm & \u2265 40 msec"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Left axis deviation \u2265 -30\u00b0" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"QRS duration \u2265 90 msec" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Intrinsicoid QRS deflection of \u2265 50 msec in V5 or V6" withValue:1]];
    return array;
}

- (int)calculateScore:(NSMutableArray *)risks {
    if ([[risks objectAtIndex:ESTES_STRAIN_WITH_DIG] selected] && [[risks objectAtIndex:ESTES_STRAIN_WITHOUT_DIG] selected]) 
        return ESTES_ERROR;
    else
        return [super calculateScore:risks];
}

- (NSString *)getMessage:(int)score {
    NSString *resultMessage = @"";
    NSString *message = @"";
    if (score == ESTES_ERROR) {
       resultMessage = @"You have selected strain pattern with and without digitalis.  Please select one or the other, not both.";
        return resultMessage;
    }
    if (score < 4)
        message = @"Left Ventricular Hypertrophy not present.";
    else if (score == 4)
        message = @"Probable Left Ventricular Hypertrophy.";
    else // score > 4
        message = @"Definite Left Ventricular Hypertrophy.";
    resultMessage = [[NSString alloc] initWithFormat:@"Romhilt-Estes score = %d\n%@\n", score, message];
    return resultMessage;
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

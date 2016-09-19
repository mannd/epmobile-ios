//
//  EPSAtriaBleedRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 12/4/15.
//  Copyright © 2015 EP Studios. All rights reserved.
//

#import "EPSAtriaBleedRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSAtriaBleedRiskScore
- (NSString *)getTitle {
    return @"ATRIA Bleeding Risk";
}

- (NSString *)getReference {
    return @"Fang MC, Go, AS, Chang Y, Borowsky LH, Pomernacki NK,    Udaltsova N, Singer DE.  A new risk scheme to predict warfarin-associated hemorrhage.  The ATRIA Study.  J Am Coll Cardiol [Internet]. 2011 Jul 2011 [cited 2015 Nov 29];58(4):395-401.  Available from: http://content.onlinejacc.org/article.aspx?articleid=1146658";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://content.onlinejacc.org/article.aspx?articleid=1146658"];
}


- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Anemia" withValue:3 withDetails:@"Hgb < 13 g/dL male, < 12 g/dL female"]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Severe renal disease" withValue:3 withDetails:@"GFR < 30 mL/min or hemodialysis"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:2]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Any prior hemorrhage" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Diagnosed HTN" withValue:1]];
    return array;
}

- (NSString *)getMessage:(int)score {
    NSString *message = @"";
    
    if (score <= 3) {
        message = [message stringByAppendingString:@"\nLow bleeding risk on warfarin (hemorrhage rate 0.8% per year)."];
    }
    else if (score == 4) {
        message = [message stringByAppendingString:@"\nIntermediate bleeding risk on warfarin (hemorrhage rate 2.6% per year).  Consider alternatives to warfarin."];
    }
    else {
        message = [message stringByAppendingString:@"\nHigh bleeding risk on warfarin (hemorrhage rate 5.8% per year).  Strongly consider alternatives to warfarin."];
    }
    return [NSString stringWithFormat:@"ATRIA bleeding risk score = %d\n%@", score, message];

}

@end

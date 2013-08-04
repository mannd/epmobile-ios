//
//  EPSChadsRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/4/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSChadsRiskScore.h"
#import "EPSRiskFactor.h"

@implementation EPSChadsRiskScore
-(NSString *)getTitle {
    return @"CHADS\u2082";
}

-(NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Congestive heart failure" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP ≥ 140/90 or treated HTN"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Stroke history" withValue:2 withDetails:@"or TIA or thromboembolism"]];
    return array;
   
    
}

@end

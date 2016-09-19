//
//  EPSOesilScore.m
//  EP Mobile
//
//  Created by David Mann on 8/11/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSOesilScore.h"
#import "EPSRiskFactor.h"

@implementation EPSOesilScore

- (NSString *)getTitle {
    return @"OESIL Score";
}

- (NSString *)getReference {
    return @"Colivicchi F, Ammirati F, Melina D, Guido V, Imperoli G, Santini M, for the OESIL (Osservatorio Epidemiologico sulla Sincope nel Lazio) Study Investigators. Development and prospective validation of a risk stratification system for patients with syncope in the emergency department: the OESIL risk score. Eur Heart J [Internet]. 2003 [cited 2014 Jun 6];24:811-19. Available from: http://eurheartj.oxfordjournals.org/content/24/9/811.full.pdf";
}

- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"http://eurheartj.oxfordjournals.org/content/24/9/811.full.pdf"];
}


- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Abnormal ECG" withValue:1 withDetails:@"New changes or non-sinus rhythm"]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"History of CV disease" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Lack of prodrome" withValue:1]];
    [array addObject:[[EPSRiskFactor alloc] initWith:@"Age > 65 years" withValue:1]];
    return array;
}

- (NSString *)getMessage:(int)score {
    double risk[] = {0, 0.6, 14, 29, 52.9 };
    NSString *message = [[NSString alloc] initWithFormat:@"OESIL Score = %d\n1-year total mortality = %1.1f%%", score, risk[score]];
    return message;
}


@end

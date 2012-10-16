//
//  EPSAnnularVTAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 10/15/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSAnnularVTAlgorithm.h"

@implementation EPSAnnularVTAlgorithm
- (NSString *)yesResult:(int *)step {
    (*step)++;
    return @"Yes";
}

- (NSString *)noResult:(int *)step {
    (*step)++;
    return @"No";
}

- (NSString *)backResult:(int *)step {
    if (*step <= 1)
        *step = 1;
    else
        (*step)--;
    return @"BACK";
}

- (NSString *)outcome:(int)step {
    return @"Outcome";
}

- (NSString *)name {
    return @"Mitral Annular VT";
}

- (BOOL)showInstructionsButton {
    return YES;
}

- (NSString *)step1 {
    return @"Precordial transition (first precordial lead with R > S) in V1 or V2 with R or Rs pattern in V2 to V5 (R/S > 3 in V2-V4)?";
}

- (void)resetSteps:(int *)step {
//
}

@end

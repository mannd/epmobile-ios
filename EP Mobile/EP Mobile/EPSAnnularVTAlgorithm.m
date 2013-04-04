//
//  EPSAnnularVTAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 10/15/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSAnnularVTAlgorithm.h"

@implementation EPSAnnularVTAlgorithm {
    BOOL isNotMitralAnnular, isAnteroLateral, isAnteroMedial, isPosterior, isPosteroSeptal;
}

const int initialStep = 1;
const int positiveQrsInferiorLeadsStep = 2;
const int notchingRInferiorLeadsStep = 3;
const int notchingQInferiorLeadsStep = 4;

- (NSString *)yesResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
		case initialStep:
			*step = positiveQrsInferiorLeadsStep;
			break;
		case positiveQrsInferiorLeadsStep:
			*step = notchingQInferiorLeadsStep;
			break;
		case notchingRInferiorLeadsStep:
            isAnteroLateral = YES;
			*step = SUCCESS_STEP;
			break;
		case notchingQInferiorLeadsStep:
			isPosterior = YES;
		    *step = SUCCESS_STEP;
			break;
    }
    return [self getQuestion:*step];
}

- (NSString *)noResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
		case initialStep:
            isNotMitralAnnular = YES;
			*step = SUCCESS_STEP;
			break;
		case positiveQrsInferiorLeadsStep:
			*step = notchingQInferiorLeadsStep;
			break;
		case notchingRInferiorLeadsStep:
			isAnteroMedial = YES;
			*step = SUCCESS_STEP;
			break;
		case notchingQInferiorLeadsStep:
			isPosteroSeptal = YES;
			*step = SUCCESS_STEP;
			break;
    }
    return [self getQuestion:*step];

}

- (NSString *)outcome:(int)step {
    NSString *message = @"";
    if (isNotMitralAnnular)
        message = [message stringByAppendingString:@"QRS morphology suggests VT or PVCs are NOT arising from the mitral annulus"];
    else if (isAnteroLateral)
        message = [message stringByAppendingString:@"Anterolateral Mitral Annulus"];
    else if (isAnteroMedial)
        message = [message stringByAppendingString:@"Anteromedial Mitral Annulus"];
    else if (isPosterior)
        message = [message stringByAppendingString:@"Posterior Mitral Annulus"];
    else if (isPosteroSeptal)
        message = [message stringByAppendingString:@"Posteroseptal Mitral Annulus"];
    else
        message = [message stringByAppendingString:@"Location cannot be determined."];
    return message;
}

- (NSString *)name {
    return @"Mitral Annular VT";
}

- (BOOL)showInstructionsButton {
    return YES;
}

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;
    switch (step) {
        case initialStep:
            question = @"Precordial transition (first precordial lead with R > S) in V1 or V2?";
            break;
        case positiveQrsInferiorLeadsStep:
            question = @"Positive QRS in inferior leads?";
            break;
        case notchingRInferiorLeadsStep:
            question = @"Notching of R wave in inferior leads?";
            break;
        case notchingQInferiorLeadsStep:
            question = @"Notching of Q wave in inferior leads?";
            break;
    }
    return question;
}

- (void)resetSteps:(int *)step {
    [super resetSteps:step];
    // need to zero out the BOOLs in this algorithm too
    isAnteroLateral = isAnteroMedial = isNotMitralAnnular = isPosterior = isPosteroSeptal = NO;
}

@end

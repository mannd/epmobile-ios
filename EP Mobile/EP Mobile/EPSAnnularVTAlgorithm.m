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
    int priorStep, priorStep1, priorStep2, priorStep3, priorStep4, priorStep5, priorStep6, priorStep7;
}

- (id)init {
    self = [super init];
    if (self) {
        priorStep = priorStep1 = priorStep2 = priorStep3 = priorStep4 = priorStep5 = priorStep6 = priorStep7 = 1;
    }
    return self;
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

- (NSString *)backResult:(int *)step {
    [self adjustStepsBackward:step];
    return [self getQuestion:*step];}

- (NSString *)outcome:(int)step {
    return @"Outcome";
}

- (NSString *)name {
    return @"Mitral Annular VT";
}

- (NSString *)resultDialogTitle {
    return @"Proposed VT Location";
}

- (BOOL)showInstructionsButton {
    return YES;
}

- (NSString *)step1 {
    return [self getQuestion:1];
//    return @"Precordial transition (first precordial lead with R > S) in V1 or V2 with R or Rs pattern in V2 to V5 (R/S > 3 in V2-V4)?";
}

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;
    switch (step) {
        case initialStep:
            question = @"Precordial transition (first precordial lead with R > S) in V1 or V2";
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


- (void)adjustStepsForward:(int)step {
    priorStep7 = priorStep6;
    priorStep6 = priorStep5;
    priorStep5 = priorStep4;
    priorStep4 = priorStep3;
    priorStep3 = priorStep2;
    priorStep2 = priorStep1;
    priorStep1 = priorStep;
    priorStep = step;
}

- (void)adjustStepsBackward:(int *)step {
    *step = priorStep;
    priorStep = priorStep1;
    priorStep1 = priorStep2;
    priorStep2 = priorStep3;
    priorStep3 = priorStep4;
    priorStep4 = priorStep5;
    priorStep5 = priorStep6;
    priorStep6 = priorStep7;
}

- (void)resetSteps:(int *)step {
    priorStep7 = priorStep6 = priorStep5 = priorStep4 = 1;
    priorStep3 = priorStep2 = priorStep1 = priorStep = *step = 1;
}


@end

//
//  EPSOutflowVTAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 10/15/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSOutflowVTAlgorithm.h"

@implementation EPSOutflowVTAlgorithm {
    BOOL mitralAnnularVT, isRvot, isLvot, isIndeterminate, isSupraValvular, isRvFreeWall, isAnterior, isCaudal;
}

int priorStep = 1;
int priorStep1 = 1;
int priorStep2 = 1;
int priorStep3 = 1;
int priorStep4 = 1;
int priorStep5 = 1;
int priorStep6 = 1;
int priorStep7 = 1;

const int lateTransitionStep = 1;
const int freeWallStep = 2;
const int anteriorLocationStep = 3;
const int caudalLocationStep = 4;
const int v3TransitionStep = 6;
const int indeterminateLocationStep = SPECIAL_STEP_1; // used by caller to change buttons
const int supraValvularStep = 9;

- (NSString *)yesResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
		case lateTransitionStep:
			isRvot = true;
			isIndeterminate = false;
			isLvot = false;
			*step = freeWallStep;
			break;
		case freeWallStep:
			isRvFreeWall = true;
			*step = anteriorLocationStep;
			break;
		case anteriorLocationStep:
			isAnterior = true;
			*step = caudalLocationStep;
			break;
		case caudalLocationStep:
			isCaudal = true;
			//showResult();
            *step = SUCCESS_STEP;
			break;
		case v3TransitionStep:
			*step = indeterminateLocationStep;
			break;
		case indeterminateLocationStep:
			isRvot = true;
			isLvot = false;
			isIndeterminate = true;
			isRvFreeWall = false;
			*step = anteriorLocationStep;
			break;
		case supraValvularStep:
			isSupraValvular = true;
			//showResult();
            *step = SUCCESS_STEP;
			break;
    }
    return [self getQuestion:*step];
}

- (NSString *)noResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
		case lateTransitionStep:
			*step = v3TransitionStep;
			break;
		case freeWallStep:
			isRvFreeWall = false;
			*step = anteriorLocationStep;
			break;
		case anteriorLocationStep:
			isAnterior = false;
			*step = caudalLocationStep;
			break;
		case caudalLocationStep:
			isCaudal = false;
			*step = SUCCESS_STEP;
			break;
		case v3TransitionStep:
			isLvot = true;
			isRvot = false;
			isIndeterminate = false;
			*step = supraValvularStep;
			break;
		case indeterminateLocationStep:
			isLvot = true;
			isRvot = false;
			isIndeterminate = true;
			*step = supraValvularStep;
			break;
            
		case supraValvularStep:
			isSupraValvular = false;
			*step = SUCCESS_STEP;
    }
    return [self getQuestion:*step];
}

- (NSString *)backResult:(int *)step {
    [self adjustStepsBackward:step];
    return [self getQuestion:*step];
}

- (NSString *)outcome:(int)step {
    return @"Outcome";
}

- (NSString *)name {
    return @"Outflow Tract VT";
}

- (BOOL)showInstructionsButton {
    return YES;
}

- (NSString *)step1 {
    return [self getQuestion:1];
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

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;
    switch (step) {
        case lateTransitionStep:
            question = @"QRS transition (first precordial lead with R > S) V4 or later?";
            break;
        case freeWallStep:
            question = @"QRS duration \u2265 140 msec or R wave notching in inferior leads?";
            break;
        case anteriorLocationStep:
            question = @"Negative or isoelectric QRS in I?";
            break;
        case caudalLocationStep:
            question = @"Positive or isoelectric QRS in aVL?";
            break;
        case v3TransitionStep:
            question = @"QRS transition in V3?";
            break;
        case indeterminateLocationStep:
            question = @"VT location may be right or left sided.  Select RV to find predicted RV location, LV to find predicted LV location.";
            // buttons must be fixed somewhere
            break;
        case supraValvularStep:
            question = @"Absent S in V5 or V6?";
            break;
    }
    return question;
}



@end

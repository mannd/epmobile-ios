//
//  EPSV2TransitionRatio.m
//  EP Mobile
//
//  Created by David Mann on 5/25/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

#import "EPSV2TransitionRatio.h"

@implementation EPSV2TransitionRatio {

BOOL mitralAnnularVT, isRvot, isLvot, isIndeterminate, isSupraValvular, isRvFreeWall, isAnterior, isCaudal;
int priorStep, priorStep1, priorStep2, priorStep3, priorStep4, priorStep5, priorStep6, priorStep7;
}

- (id)init {
self = [super init];
if (self) {
    priorStep = priorStep1 = priorStep2 = priorStep3 = priorStep4 = priorStep5 = priorStep6 = priorStep7 = 1;
}
return self;
}


const int xlateTransitionStep = 1;
const int xfreeWallStep = 2;
const int xanteriorLocationStep = 3;
const int xcaudalLocationStep = 4;
const int xv3TransitionStep = 6;
const int xindeterminateLocationStep = SPECIAL_STEP_1; // used by caller to change buttons
const int xsupraValvularStep = 9;

- (NSString *)yesResult:(int *)step {
[self adjustStepsForward:*step];
switch (*step) {
    case xlateTransitionStep:
        isRvot = YES;
        isIndeterminate = NO;
        isLvot = NO;
        *step = xfreeWallStep;
        break;
    case xfreeWallStep:
        isRvFreeWall = YES;
        *step = xanteriorLocationStep;
        break;
    case xanteriorLocationStep:
        isAnterior = YES;
        *step = xcaudalLocationStep; 
        break;
    case xcaudalLocationStep: 
        isCaudal = YES;
        //showResult();
        *step = SUCCESS_STEP;
        break;
    case xv3TransitionStep:
        *step = xindeterminateLocationStep;
        break;
    case xindeterminateLocationStep:
        isRvot = YES;
        isLvot = NO;
        isIndeterminate = YES;
        isRvFreeWall = NO;
        *step = xanteriorLocationStep;
        break;
    case xsupraValvularStep:
        isSupraValvular = YES;
        //showResult();
        *step = SUCCESS_STEP;
        break;
}
return [self getQuestion:*step];
}

- (NSString *)noResult:(int *)step {
[self adjustStepsForward:*step];
switch (*step) {
    case xlateTransitionStep:
        *step = xv3TransitionStep;
        break;
    case xfreeWallStep:
        isRvFreeWall = NO;
        *step = xanteriorLocationStep;
        break;
    case xanteriorLocationStep:
        isAnterior = NO;
        *step = xcaudalLocationStep; 
        break;
    case xcaudalLocationStep: 
        isCaudal = NO;
        *step = SUCCESS_STEP;
        break;
    case xv3TransitionStep:
        isLvot = YES;
        isRvot = NO;
        isIndeterminate = NO;
        *step = xsupraValvularStep;
        break;
    case xindeterminateLocationStep:
        isLvot = YES;
        isRvot = NO;
        isIndeterminate = YES;
        *step = xsupraValvularStep;
        break;

    case xsupraValvularStep:
        isSupraValvular = NO;
        *step = SUCCESS_STEP;
}
return [self getQuestion:*step];
}

- (NSString *)backResult:(int *)step {
[self adjustStepsBackward:step];
return [self getQuestion:*step];
}

- (NSString *)outcome:(int)step {
NSString *message = @"";
if (isIndeterminate)
    message = [message stringByAppendingString:@"Note: Location (RV vs LV) is indeterminate.  Results reflect one possible localization.\n"];
if (isRvot) {
    message = [message stringByAppendingString:@"Right Ventricular Outflow Tract"];
    message = isRvFreeWall ? [message stringByAppendingString:@"\nFree wall"] : [message stringByAppendingString:@"\nSeptal"];
    message = isAnterior ? [message stringByAppendingString:@"\nAnterior"] : [message stringByAppendingString:@"\nPosterior"];
    message = isCaudal ? [message stringByAppendingString:@"\nCaudal (>2 cm from pulmonic valve)"] : [message stringByAppendingString:@"\nCranial (<2 cm from pulmonic valve)"];
} else if (isLvot) {
    message = [message stringByAppendingString:@"Left Ventricular Outflow Tract"];
    message = isSupraValvular ? [message stringByAppendingString:@"\nSupravalvular (aortic cusp) Location.\nTransition is in V2 or V3 with origin in the right coronary cusp, and in V1 or V2 in the left coronary cusp.  Left coronary cusp VT is often associated with a W- or M-shaped pattern in V1."] : [message stringByAppendingString:@"\nSubvalvular Location.\nVT from the aorto-mitral                                                                                                                                                                                                                                                                                                                  continuity often has a qR pattern in V1.  VT from the mitral annulus has an R in V1."];
} else
    message = [message stringByAppendingString:@"Location can't be determined."];


return message;
}

- (NSString *)name {
return @"V2 Transition Ratio";
}

- (NSString *)resultDialogTitle {
return @"Ventricular Tachycardia Location";
}

- (BOOL)showInstructionsButton {
return YES;
}

- (BOOL)showMap {
return NO;
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
    case xlateTransitionStep:
        question = @"QRS transition (first precordial lead with R > S) V4 or later?";
        break;
    case xfreeWallStep:
        question = @"QRS duration \u2265 140 msec or R wave notching in inferior leads?";
        break;
    case xanteriorLocationStep:
        question = @"Negative or isoelectric QRS in I?";
        break;
    case xcaudalLocationStep: 
        question = @"Positive or isoelectric QRS in aVL?";
        break;
    case xv3TransitionStep:
        question = @"QRS transition in V3?";
        break;
    case xindeterminateLocationStep:
        question = @"VT location may be right or left sided.  Select RV to find predicted RV location, LV to find predicted LV location.";
        // buttons must be fixed somewhere
        break;
    case xsupraValvularStep:
        question = @"Absent S in V5 or V6?";
        break;
}
return question;
}

@end

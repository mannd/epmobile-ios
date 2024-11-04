//
//  EPSV2TransitionRatio.m
//  EP Mobile
//
//  Created by David Mann on 5/25/24.
//  Copyright © 2024 EP Studios. All rights reserved.
//

#import "EPSV2TransitionRatio.h"

@implementation EPSV2TransitionRatio {

    BOOL mitralAnnularVT, isCertainlyRvot, isRvot, isLvot, isIndeterminate, isSupraValvular, isRvFreeWall, isAnterior, isCaudal;
    int priorStep, priorStep1, priorStep2, priorStep3, priorStep4, priorStep5, priorStep6, priorStep7;
}

- (id)init {
    self = [super init];
    if (self) {
        priorStep = priorStep1 = priorStep2 = priorStep3 = priorStep4 = priorStep5 = priorStep6 = priorStep7 = 1;
    }
    return self;
}


static const int v3TransitionStep = 1;
static const int lateTransitionStep = 2;
static const int manualMeasureStep = SPECIAL_STEP_2;

- (NSString *)yesResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
        case v3TransitionStep:
            isRvot = NO;
            isCertainlyRvot = NO;
            isIndeterminate = NO;
            isLvot = NO;
            *step = lateTransitionStep;
            break;
        case lateTransitionStep:
            isCertainlyRvot = YES;
            *step = SUCCESS_STEP;
            //[self showResult];
            break;
        case manualMeasureStep:
            isRvot = YES;
            *step = SUCCESS_STEP;
            //[self showResult];
            break;
    }
    return [self getQuestion:*step];
}

- (NSString *)noResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
        case v3TransitionStep:
            isIndeterminate = YES;
            *step = SUCCESS_STEP;
            break;
        case lateTransitionStep:
            *step = manualMeasureStep;
            break;
        case manualMeasureStep:
            isLvot = YES;
            *step = SUCCESS_STEP;
            break;
    }
    return [self getQuestion:*step];
}

- (NSString *)backResult:(int *)step {
    [self adjustStepsBackward:step];
    return [self getQuestion:*step];
}

- (NSString *)outcome:(int)step {
    NSString *message = @"";
    if (isIndeterminate) {
        message = [message stringByAppendingString:@"This algorithm requires that the R wave transition be in lead V3.  Use the Outflow Tract VT module instead."];
    } else if (isRvot) {
        message = [message stringByAppendingString:@"Right Ventricular Outflow Tract\nTransition ratio is < 0.6\nRVOT origin is likely. \n(sensitivity 95%, specificity 100%)"];
    } else if (isCertainlyRvot) {
        message = [message stringByAppendingString:@"Right Ventricular Outflow Tract\nThe PVC/VT origin is the RVOT (100% specificity)."];
    } else if (isLvot) {
        message = [message stringByAppendingString:@"Left Ventricular Outflow Tract\nTransition ratio is ≥ 0.6\nLVOT origin is likely. \n(sensitivity 95%, specificity 100%)"];
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

- (void)showResult {

}

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;
    switch (step) {
        case v3TransitionStep:
            question = @"Is the PVC/VT R/S transition in lead V3?";
            break;
        case lateTransitionStep:
            question = @"Is the PVC/VT R/S transition later than the R/S transition in sinus rhythm?";
            break;
        case manualMeasureStep:
            question = @"What is the V2 transition ratio?\n(tap the V2 Transition Calculator button if you need to manually calculate the ratio)";
            break;
    }
    return question;
}

@end

//
//  EPSBrugadaWCTAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 10/17/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSBrugadaWCTAlgorithm.h"

@implementation EPSBrugadaWCTAlgorithm



- (NSString *)name {
    return @"Brugada Criteria WCT";
}

- (BOOL)showInstructionsButton {
    return NO;
}

- (NSString *)resultDialogTitle {
    return @"WCT Result";
}

- (NSString *)noResult:(int *)step {
    [self adjustStepsForward:*step];
    (*step)++;
    if (*step > 4)
        *step += SUCCESS_STEP;
    return [self getQuestion:*step];
}

- (NSString *)yesResult:(int *)step {
    [self adjustStepsForward:*step];
    *step += SUCCESS_STEP;
    return nil;
}

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;
    switch (step) {
        case 1:
            question = @"Absence of an RS complex in all precordial leads?";
            break;
        case 2:
            question = @"R to S interval > 100 msec in one precordial lead?";
            break;
        case 3:
            question = @"AV dissociation present?";
            break;
        case 4:
            question = @"Morphology criteria for VT present in both precordial leads V1-2 and V6?";
            break;
    }
    return question;
}

- (NSString *)outcome:(int)step {
    NSString *message = @"Wide Complex Tachycardia is most likely ";
    NSString *sens = nil;
    NSString *spec = nil;
    BOOL isSVT = NO;
    switch (step) {
		case SUCCESS_STEP + 1:
		case SUCCESS_STEP + 2:
			sens = @".21";
			spec = @"1.0";
			break;
		case SUCCESS_STEP + 3:
			sens = @".82";
			spec = @".98";
			break;
		case SUCCESS_STEP + 4:
			sens = @".987";
			spec = @".965";
			break;
        case SUCCESS_STEP + 5:
            // is SVT
            isSVT = YES;
            sens = @".965";
            spec = @".967";
            break;
    }
    if (!isSVT) {
        message = [message stringByAppendingString:@"Ventricular Tachycardia"];
    }
    else
        message = [message stringByAppendingString:@"Supraventricular Tachycardia"];
    message = [message stringByAppendingFormat:@" (Sens=%@, Spec=%@) ", sens, spec];
    return message;
}


@end

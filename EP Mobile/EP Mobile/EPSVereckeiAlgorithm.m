//
//  EPSVereckeiAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 3/25/14.
//  Copyright (c) 2014 EP Studios. All rights reserved.
//

#import "EPSVereckeiAlgorithm.h"

@implementation EPSVereckeiAlgorithm

- (NSString *)name {
    return @"Vereckei Algorithm";
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
            question = @"Initial R in aVR?";
            break;
        case 2:
            question = @"Initial r or q in aVR with width > 40 msec?";
            break;
        case 3:
            question = @"Notching on the initial downstroke of a predominantly negative QRS complex in aVR?";
            break;
        case 4:
            question = @"Ratio of voltage of initial and final 40 msec of QRS complex in aVR (Vi/Vt) \u2264 1?";
            break;
    }
    return question;
}

- (NSString *)outcome:(int)step {
    NSString *message = @"Wide Complex Tachycardia is most likely ";
    BOOL isSVT = NO;
    if (step == SUCCESS_STEP + 5) {
        isSVT = YES;
    }
    if (!isSVT) {
        message = [message stringByAppendingString:@"Ventricular Tachycardia"];
    }
    else
        message = [message stringByAppendingString:@"Supraventricular Tachycardia"];
    return message;
}



@end

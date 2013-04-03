//
//  EPSAtrialTachAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 4/2/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSAtrialTachAlgorithm.h"

@implementation EPSAtrialTachAlgorithm


const int step1 = 1;
const int v24PosStep = 2;
const int aVLStep = 3;
const int bifidIIStep = 4;
const int negAllInfStep = 5;
const int negAllInf2Step = 6;
const int sinusRhythmStep = 7;
// result "steps" == outcomes == locations
const int locationCrista = 100;
const int locationRightSeptum = 101;
// etc.

- (NSString *)name {
    return @"Atrial Tach Location";
}

- (BOOL)showInstructionsButton {
    return YES;
}

- (NSString *)resultDialogTitle {
    return @"Proposed AT Location";
}

- (BOOL)showMap {
    return NO;
}

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;
    switch (step) {
        case step1:
            question = @"P Wave Morphology in Lead V1?";
            break;
        case v24PosStep:
            question = @"P Wave in Leads V2-V4 Positive?";
            break;
        case aVLStep:
            question = @"aVL Polarity?";
            break;
        case bifidIIStep:
            question = @"Bifid P in II and/or V1?";
            break;
        case negAllInfStep:
        case negAllInf2Step:
            question = @"Negative P in All Inferior Leads?";
            break;
        case sinusRhythmStep:
            question = @"Sinus Rhythm P Wave Morphology?";
            break;
    }
    return question;
}

- (NSString *)outcome:(int)step {
    NSString* message = nil;
    switch (step) {
//        case :
//            ;
            
//            break;
//            
//        default:
//            break;
    }
    return message;
}


@end

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
const int sinusRhythmPStep = 7;

// result "steps" == outcomes == locations
// in ViewController, SUCCESS_STEP = 1000
const int locationCrista = 1000;
const int locationRightSeptum = 1001;
const int locationSMA = 1002;
const int locationOsOrLeftSeptum = 1003;
const int locationTA = 1004;
const int locationTAOrRAA = 1005;
const int locationCsBody = 1006;
const int locationLPVOrLAA = 1007;
const int locationCristaOrRPV = 1008;
const int locationRSPV = 1009;


- (NSString *)name {
    return @"Atrial Tach Location";
}

- (BOOL)showInstructionsButton {
    return YES;
}

- (NSString *)resultDialogTitle {
    return @"Atrial Tachycardia Location";
}

- (BOOL)showMap {
    return NO;
}

- (NSString *)yesResult:(int *)step {
    switch (*step) {
        case 1:
            *step = v24PosStep;
            break;
        case v24PosStep:
            *step = locationCrista;
            break;
        case aVLStep:
            *step = locationSMA;
            break;
        case bifidIIStep:
            *step = negAllInf2Step;
            break;
        case negAllInfStep:
            *step = locationTA;
            break;
        case negAllInf2Step:
            *step = locationCsBody;
            break;
        case sinusRhythmPStep:
            *step = locationCristaOrRPV;
            break;
    }
    return [self getQuestion:*step];
    
}

- (NSString *)noResult:(int *)step {
    switch (*step) {
        case 1:
            *step = locationCrista;
            break;
        case v24PosStep:
            *step = negAllInfStep;
            break;
        case aVLStep:
            *step = locationOsOrLeftSeptum;
            break;
        case bifidIIStep:
            *step = sinusRhythmPStep;
            break;
        case negAllInfStep:
            *step = locationTAOrRAA;
            break;
        case negAllInf2Step:
            *step = locationLPVOrLAA;
            break;
        case sinusRhythmPStep:
            *step = locationRSPV;
            break;
    }
    return [self getQuestion:*step];
}

- (NSString *)backResult:(int *)step {
    // back button moves forward in step 1, back button is neg/pos button
    if (*step == 1)
        *step = aVLStep;
    else
        [self adjustStepsBackwards:step];
    return [self getQuestion:*step];
}

- (NSString *)button4Result:(int *)step {
    *step = aVLStep;
    return [self getQuestion:*step];
}

- (NSString *)button5Result:(int *)step {
    *step = locationRightSeptum;
    return nil;
}

- (NSString *)button6Result:(int *)step {
    *step = bifidIIStep;
    return [self getQuestion:*step];
}

- (void)adjustStepsBackwards:(int *)step {
    switch (*step) {
		case v24PosStep:
		case aVLStep:
		case bifidIIStep:
			*step = 1;
			break;
		case negAllInfStep:
			*step = v24PosStep;
			break;
		case negAllInf2Step:
		case sinusRhythmPStep:
			*step = bifidIIStep;
			break;
    }
    
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
        case sinusRhythmPStep:
            question = @"Sinus Rhythm P Wave Morphology?";
            break;
    }
    return question;
}

- (NSString *)outcome:(int)step {
    NSString* message = @"Undefined";
    switch (step) {
        case locationCrista:
            message = @"Crista Terminalis";
            break;
        case locationRightSeptum:
            message = @"Right Side of Septum or Perinodal";
            break;
        case locationSMA:
            message = @"Superior Mitral Annulus";
            break;
        case locationOsOrLeftSeptum:
            message = @"Coronary Sinus Os or Left Side of Septum";
            break;
        case locationTA:
            message = @"Tricuspid Annulus";
            break;
        case locationTAOrRAA:
            message = @"Tricuspid Annulus or Right Atrial Appendage";
            break;
        case locationCsBody:
            message = @"Coronary Sinus Body";
            break;
        case locationLPVOrLAA:
            message = @"Left Sided Pulmonary Vein or Left Atrial Appendage";
            break;
        case locationCristaOrRPV:
            message = @"Crista Terminalis or Right Sided Pulmonary Vein";
            break;
        case locationRSPV:
            message = @"Right Sided Pulmonary Vein";
            break;
    }
    return message;
}


@end

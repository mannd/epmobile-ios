//
//  EPSArrudaAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 10/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSArrudaAlgorithm.h"
#import "EPSAccessoryPathwayLocations.h"

@implementation EPSArrudaAlgorithm

@synthesize message;
@synthesize location1;
@synthesize location2;

- (NSString *)name {
    return @"Arruda Algorithm";
}

- (NSString *)resultDialogTitle {
    return @"Accessory Pathway Location";
}

- (BOOL)showInstructionsButton {
    return NO;
}

- (BOOL)showMap {
    return  YES;
}

- (NSString *)yesResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
		case 1:
//			if (modifiedArruda)
//				*step = 6;
//			else
				*step = 2;
			break;
		case 2:
			*step = 5;
			break;
		case 6:
			*step = 12;
			break;
		case 13:
			*step = 14;
			break;
		case 15:
			*step = 16;
			break;
		case 16:
			*step = 23;
			break;
		case 18:
			*step = 19;
			break;
		case 20:
			*step = 21;
			break;
		case 24:
			*step = 30;
			break;
		case 27:
			*step = 29;
			break;
		case 80:
			*step = 9;
			break;
		case 81:
			*step = 10;
			break;
    }
    if ([self checkForSuccess:*step])
        *step += SUCCESS_STEP;
    return [self getQuestion:*step];
}

- (NSString *)noResult:(int *)step {
    [self adjustStepsForward:*step];
    switch (*step) {
		case 1:
			*step = 13;
			break;
		case 2:
			*step = 4;
			break;
		case 6:
			*step = 80; // 8a
			break;
            // handle 8 differently
		case 80:
			*step = 81;
			break;
		case 81:
			*step = 11;
			break;
		case 13:
			*step = 15;
			break;
		case 15:
			*step = 24;
			break;
		case 16:
			*step = 18;
			break;
		case 18:
			*step = 20;
			break;
		case 20:
			*step = 22;
			break;
		case 24:
			*step = 27;
			break;
		case 27:
			*step = 28;
			break;
    }
    if ([self checkForSuccess:*step])
        *step += SUCCESS_STEP;
    return [self getQuestion:*step]; 
}

- (BOOL)checkForSuccess:(int)step {
    BOOL success = NO;
    switch (step) {
        case 4:
		case 5:
		case 9:
		case 10:
		case 11:
		case 12:
		case 14:
		case 19:
		case 21:
		case 22:
		case 23:
		case 28:
		case 30:
		case 29:
            success = YES;
            break;
    }
    return success;
}

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;

    switch (step) {
        case 1:
            question = @"Lead I \u00b1 or -\n or V1 R/S \u2265 1?";
            break;
        case 2:
            question = @"Pathway is Left Free Wall\nLead aVF + ?";
            break;
		case 6:
			question = @"Pathway is Left Free Wall\nLead I \u00b1 or Lead V1 S \u00b1 ?";
			break;
		case 13:
            question = @"Lead II - ?";
			break;
		case 15:
            question = @"Lead V1 \u00b1 or - ?";
			break;
		case 16:
            question = @"Pathway is Septal\nLead aVF - ?";
			break;
		case 18:
            question = @"Lead aVF \u00b1 ?";
			break;
		case 20:
            question = @"Lead III R \u2265 S ?";
			break;
		case 24:
            question = @"Pathway is Right Free Wall\nLead aVF + ?";
			break;
		case 27:
            question = @"Lead II + ?";
			break;
		case 80: // 8a
            question = @"Lead V1 + ?";
			break;
		case 81:
            question = @"Lead V1 \u00b1 ?";
			break;
    }
    return question;
}

- (NSString *)outcome:(int)step {
    step %= SUCCESS_STEP;
    [self setMessageAndLocation:step];
    return message;
}

- (void)setMessageAndLocation:(int)step {
    switch (step) {
		case 9:
			message = @"Left Posterolateral or Left Lateral";
            location1 = LPL;
			location2 = LL;
			break;
		case 10:
			message = @"Left Lateral";
			location1 = LL;
			break;
		case 11:
			message = @"Left Anterolateral";
			location1 = LAL;
			break;
		case 12:
			message = @"Left Posterior or Posteroseptal Tricuspid Annulus";
			location1 = LP;
			location2 = PSTA;
			break;
		case 4:
			message = @"Left Posterior or Left Posterolateral";
			location1 = LP;
			location2 = LPL;
			break;
		case 5:
			message = @"Left Lateral or Left Anterolateral";
			location1 = LL;
			location2 = LAL;
			break;
		case 14:
			message = @"Epicardial: Coronary Sinus or Middle Cardiac Vein";
			location1 = SUBEPI;
			break;
		case 19:
			message = @"Posteroseptal Tricuspid Annulus or Posteroseptal Mitral Annulus";
			location1 = PSTA;
			location2 = PSMA;
			break;
		case 21:
			message = @"Anteroseptal";
			location1 = AS;
			break;
		case 23:
			message = @"Posteroseptal Tricuspid Annulus";
			location1 = PSTA;
			break;
		case 22:
			message = @"Midseptal Tricuspid Annulus";
			location1 = MSTA;
			break;
		case 30:
			message = @"Right Anterior or Right Anterolateral";
			location1 = RA;
			location2 = RAL;
			break;
		case 29:
			message = @"Right Lateral";
			location1 = RL;
			break;
		case 28:
			message = @"Right Posterior or Right Posterolateral";
			location1 = RP;
			location2 = RPL;
			break;
    }
    
}


@end

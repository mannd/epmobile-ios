//
//  EPSDavilaAlgorithm.m
//  EP Mobile
//
//  Created by David Mann on 2/8/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import "EPSDavilaAlgorithm.h"
#import "EPSAccessoryPathwayLocations.h"

@implementation EPSDavilaAlgorithm

@synthesize message;
@synthesize location1;
@synthesize location2;

- (NSString *)name {
    return @"D'Avila Algorithm";
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
            *step = 2;  // III +
            break;
        case 2:
            *step = 8; // LL
            break;
        case 3:
            *step = 9; // LP
            break;
        case 10:
            *step = 7; //  AS
            break;
        case 5:
            *step = 6;  // aVL +?
            break;
        case 6:
            *step = 7;  // AS
            break;
        case 7:
            *step = 14;
            break;
        case 11:
            *step = 12; // MS
            break;
        case 13:
            *step = 14; // V2 + ?
            break;
        case 14:
            *step = 15; // RPS
            break;
        case 16:
            *step = 17; // RL
            break;
        case 17:
            *step = 19; // PS
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
            *step = 5;  // III + ?
            break;
        case 2:
            *step = 3;   // III +/- ?
            break;
        case 3:
            *step = 4;
            break;
        case 4:
            *step = 11;
            break;
        case 5:
            *step = 10;
            break;
        case 6:
            *step = 8;  // LL
            break;
        case 10:
            *step = 11;
            break;
        case 11:
            *step = 13; // II + ?
            break;
        case 13:
            *step = 17; // II -
            break;
        case 14:
            *step = 16; //RL
            break;
        case 17:
            *step = 18; // RL
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
        case 7:
        case 8:
        case 9:
        case 12:
        case 15:
        case 16:
        case 18:
        case 19:
            success = YES;
            break;
    }
    return success;
}

- (NSString *)getQuestion:(int)step {
    NSString *question = nil;
    
    switch (step) {
        case 1:
            question = @"Polarity of QRS in Lead V1 is + or \u00b1 ?";
            break;
        case 2:
        case 5:
            question = @"Lead III QRS polarity + ?";
            break;
        case 3:
        case 10:
            question = @"Lead III QRS polarity \u00b1 ?";
            break;
        case 6:
            question = @"Lead aVL QRS polarity + ?";
            break;
        case 11:
            question = @"\"Qrs\" pattern (deep Q, small rs) in Lead III?";
            break;
        case 13:
            question = @"Lead II QRS polarity + ?";
            break;
        case 14:
        case 17:
            question = @"Lead V2 QRS polarity + ?";
            break;
    }
    return question;
}

- (NSString *)outcome:(int)step {
    step %= SUCCESS_STEP;
    [self setMessageAndLocation:step];
    return self.message;
}

- (NSString *)outcomeLocation1:(int)step {
    step %= SUCCESS_STEP;
    [self setMessageAndLocation:step];
    return self.location1;
}

- (NSString *)outcomeLocation2:(int)step {
    step %= SUCCESS_STEP;
    [self setMessageAndLocation:step];
    return self.location2;
}

- (void)setMessageAndLocation:(int)step {
    // nillify lingering messages and locations
    self.message = nil;
    self.location1 = nil;
    self.location2 = nil;
    switch (step) {
        case 4:
            self.message = @"Left Posteroseptal (Posteroseptal Mitral Annulus)";
            self.location1 = PSMA;
            break;
        case 7:
            self.message = @"Anteroseptal";
            self.location1 = AS;
            break;
        case 8:
            self.message = @"Left Lateral";
            self.location1 = LL;
            break;
        case 9:
            self.message = @"Left Posterior";
            self.location1 = LP;
            break;
        case 12:
            self.message = @"Mid-septal (Mid-septal Tricuspid Annulus)";
            self.location1 = MSTA;
            break;
        case 16:
        case 18:
            self.message = @"Right Lateral";
            self.location1 = RL;
            break;
        case 15:
            self.message = @"Right Posteroseptal (Posteroseptal Tricuspid Annulus)";
            self.location1 = PSTA;
            break;
        case 19:
            self.message = @"Posteroseptal";
            self.location1 = SUBEPI;
            break;
      }
    
}


@end

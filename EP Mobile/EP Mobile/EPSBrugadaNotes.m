//
//  EPSBrugadaNotes.m
//  EP Mobile
//
//  Created by David Mann on 10/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSBrugadaNotes.h"

@implementation EPSBrugadaNotes

- (NSString *)noteText {
    return @"Type 1: Coved ST elevation with \u2265 2 mm J-point elevation and gradually descending ST segment followed by negative T wave.  Considered diagnostic of Brugada syndrome if occurs spontaneously or induced by drug challenge.\n\nType 2: Saddle back pattern with \u2265 2 mm J-point elevation and \u2265 1 mm ST elevation with a positive or biphasic T wave.  Occasionally seen in healthy subjects.\n\nType 3: Saddle back pattern with < 2 mm J point elevation and < 1 mm ST elevation with positive T wave.  Not uncommon in healthy subjects.";
}

- (NSString *)titleText {
    return @"Brugada ECG Notes";
}

- (NSString *)labelText {
    return @"ST-T Abnormalities in V1-V3";
}

@end

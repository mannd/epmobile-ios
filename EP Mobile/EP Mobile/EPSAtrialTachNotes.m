//
//  EPSAtrialTachNotes.m
//  EP Mobile
//
//  Created by David Mann on 4/2/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSAtrialTachNotes.h"

@implementation EPSAtrialTachNotes
- (NSString *)noteText {
    return @"This algorithm applies only to focal atrial tachycardia. To be accurate, the P wave must have a discrete isoelectric segment before its start, i.e. don\'t use a P wave that is fused onto the end of a T wave.  Iso means isoelectric, defined as a < 0.05 mV deviation from the baseline.  The algorithm sensitivity in the original study was 93%.\nKistler et al. JACC 2006;48:1010. J Am Coll Cardiol. 2006;48(5):1010-1017. http://content.onlinejacc.org/article.aspx?articleid=1137857";
}

- (NSString *)titleText {
    return @"Atrial Tach Location";
}

- (NSString *)labelText {
    return @"Instructions";
}

@end

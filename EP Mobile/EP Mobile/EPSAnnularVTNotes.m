//
//  EPSAnnularVTNotes.m
//  EP Mobile
//
//  Created by David Mann on 10/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSAnnularVTNotes.h"

@implementation EPSAnnularVTNotes
-(NSString *)noteText {
    return @"Use this module to predict the location of idiopathic mitral annular ventricular tachycardia or premature ventricular complexes based on the ECG morphology.  Note that this module does not deal with mitral isthmus VT in the setting of prior inferior infarction (see Wilber D et al. Circulation 1995;92:3481).\n\nReference: Tada H et al.  JACC 2005;45:877.";
}

-(NSString *)titleText {
    return @"Mitral Annular VT";
}

-(NSString *)labelText {
    return @"Instructions";
}
@end

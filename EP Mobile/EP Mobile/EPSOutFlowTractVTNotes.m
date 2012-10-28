//
//  EPSOutFlowTractVTNotes.m
//  EP Mobile
//
//  Created by David Mann on 10/1/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSOutFlowTractVTNotes.h"

@implementation EPSOutFlowTractVTNotes
- (NSString *)noteText {
    return @"Ventricular tachycardia and premature ventricular complexes can arise from either the right or left ventricular outflow tract (RVOT or LVOT).  Outflow tract VT has a vertical axis and a left bundle branch block pattern in the precordial leads.  The earlier the precordial transition lead, the more likely the VT is from the LVOT.  If the precordial transition is in lead V3 it is not possible to use an algorithm to determine from which ventricle the VT arises. See Tanner et al. JACC 2005;45:418. http://content.onlinejacc.org/cgi/content/short/45/3/418.\n\nThis algorithm was developed from Joshi S and Wilber DJ, J Cardiovasc Electrophysiol 2005;16:Suppl I:S52, Bala R and Marchlinski FE, Heart Rhythm 2007;4:366, and Srivathsan K et al. Indian Pacing Electrophysiol J 2005;5:106. http://cogprints.org/4219/1/srivathsan.htm";
}

-(NSString *)titleText {
    return @"Outflow Tract VT";
}

-(NSString *)labelText {
    return @"Instructions";
}
@end

//
//  EPSEntrainmentNotes.m
//  EP Mobile
//
//  Created by David Mann on 3/24/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSEntrainmentNotes.h"

@implementation EPSEntrainmentNotes
-(NSString *)noteText {
    return @"This Entrainment Mapping module is most suited for mapping ischemic ventricular tachycardia (VT), but principles of entrainment apply to all reentrant arrhythmias.  Entrainment is performed by pacing during stable VT (or other reentrant tachycardia) for approximately 8-15 beat trains at 20-40 msec shorter than the tachycardia cycle length (TCL).  Make sure all electrograms are 'entrained', i.e. the CL shortens to the pacing CL.  The post-pacing interval (PPI) is measured from the last pacing stimulus to the next electrogram recorded from the pacing site.  Concealed fusion is present if the tachycardia morphology does not change during entrainment.  If there is concealed fusion then the pacing site is in an area of slow conduction near the critical isthmus of the reentry circuit.  During VT if a discrete electrogram (EG) is present prior to the QRS onset then the EG-QRS interval can be measured.  During entrainment with concealed fusion, if there is a delay between the pacing stimulus to onset of the QRS (S-QRS), then the site is within the critical isthmus if the S-QRS interval is similar to the EG-QRS interval.  In addition the relative location within the critical isthmus can be estimated by the ratio of the S-QRS to the TCL.  Sites with concealed fusion but long PPI intervals are probably adjacent bystander tracts.  Pacing sites within the critical isthmus are associated with a much higher chance of successful tachycardia termination with ablation than other sites.\n\nReference: Stevenson WG et al. JACC 1997;29:1180.\nhttp://content.onlinejacc.org/article.aspx?articleid=1121699";
}

-(NSString *)titleText {
    return @"Entrainment Map";
}

-(NSString *)labelText {
    return @"Instructions";
}


@end

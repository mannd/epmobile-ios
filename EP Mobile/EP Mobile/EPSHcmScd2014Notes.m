//
//  EPSHcmScd2014Notes.m
//  EP Mobile
//
//  Created by David Mann on 5/31/15.
//  Copyright (c) 2015 EP Studios. All rights reserved.
//

#import "EPSHcmScd2014Notes.h"

@implementation EPSHcmScd2014Notes
-(NSString *)noteText {
    return @"Do not use this risk calculator for pediatric patients (<16), elite competitive athletes, HCM associated with metabolic syndromes, or patients with aborted SCD or sustained ventricular arrhythmias.\n\nHCM = hypertrophic cardiomyopathy. Age = age at evaluation. Wall thickness = maximum left ventricular wall thickness.  Note all echo measurements via transthoracic echo. LA (left atrial) diameter measured in parasternal long axis. Gradient = maximum left ventricular outflow tract gradient determined at rest and with Valsalva using pulsed and continuous wave Doppler from the apical 3 and 5 chamber views. Peak outflow gradients determined by modified Bernoulli equation: Gradient = 4V\u00B2, where V is the peak aortic outflow velocity. Family hx of SCD = history of sudden cardiac death in 1 or more first degree relatives under 40 years old or in a first degree relative with confirmed HCM at any age. NSVT = nonsustained ventricular tachycardia: 3 consecutive ventricular beats at a rate of 120 bpm or more and <30 sec duration on Holter monitoring (minimum 24 hrs) at or prior to evaluation. \n\nReferences: Elliott PM et al. 2014 ESC guidelines on diagnosis and management of hypertrophic cardiomyopathy. Eur Heart J 2014;35:2733, http://eurheartj.oxfordjournals.org/content/35/39/2733#sec-16\nO'Mahony C et al.  Eur Heart J 2014;35:2010, http://eurheartj.oxfordjournals.org/content/35/30/2010.long";
}

-(NSString *)titleText {
    return @"HCM-SCD Risk 2014";
}

-(NSString *)labelText {
    return @"Notes";
}

@end

//
//  EPSCMSNotes.m
//  EP Mobile
//
//  Created by David Mann on 10/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSCMSNotes.h"

@implementation EPSCMSNotes
-(NSString *)noteText {
    return @"The Calculate button will show whether the patient is likely to meet CMS guidelines for Medicare reimbursement.  Note the CMS National Coverage Determination (NCD) is quite detailed and you should be very familiar with it before making a decision  as to whether a particular patient is likely to be covered.  This module is only intended as a guide to the NCD and is not definitive. Additional factors need to be considered.  For example, the NCD definition of myocardial infarction must be used. Primary prevention ICD recipients  must be enrolled in an FDA-approved clinical trial or in the National ICD Registry.  Although unstated in CMS guidelines, patients considered for primary prevention ICDs should be on stable, optimal medical therapy for left ventricular dysfunction.  Note also that the CMS makes a distinction between EP testing performed for suspected VT (e.g. in a patient with syncope) in Guideline #2 and EP testing performed for risk stratification (e.g. as in MADIT), which is Guideline #4. The CMS NCD does not cover approval of CRT devices. CRT device approval is subject to Local Coverage Determinations and local payers.  Note that some locales may require QRS duration \u2265 130 msec for CRT coverage.\n\nReference: Center for Medicaid and Medicare Services, National Coverage Determination Manual, Chapter 1, Part 1, Section 20.4, 2005";
}

-(NSString *)titleText {
    return @"CMS ICD Criteria";
}

-(NSString *)labelText {
    return @"Notes";
}
@end

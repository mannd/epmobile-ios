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
    return @"Select patient characteristics and then select Calculate to show whether the patient is likely to meet CMS guidelines for Medicare reimbursement. Note the CMS National Coverage Determination (NCD) is quite detailed and you should be very familiar with it before making a decision as to whether a particular patient is covered. This module is only intended as a guide to the NCD and is not definitive. The module has been updated to the latest 2018 CMS guidelines.\n\nAF = atrial fibrillation.  CA = cardiac arrest. CABG = coronary artery bypass grafting.  CM = cardiomyopathy. CMS = Centers for Medicare and Medicaid Services. EF = ejection fraction. EPS = electrophysiology study. HCM = hypertrophic cardiomyopathy. ICD = implantable cardioverter defibrillator. OMT = optimal medical therapy. MI = myocardial infarction. NYHA = New York Heart Association. PCI = percutaneous coronary intervention. SVT = supraventricular tachycardia. VT = ventricular tachycardia/tachyarrhythmia. VF = ventricular fibrillation.\n\nReference: CMS: Decision Memo for Implantable Cardioverter Defibrillators (CAG-00157R4) Feb 15, 2018. https://www.cms.gov/medicare-coverage-database/details/nca-decision-memo.aspx?NCAId=288";
}

-(NSString *)titleText {
    return @"CMS ICD Criteria";
}

-(NSString *)labelText {
    return @"Notes";
}
@end

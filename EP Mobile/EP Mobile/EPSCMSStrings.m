//
//  EPSCMSStrings.m
//  EP Mobile
//
//  Created by David Mann on 2/25/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

#import "EPSCMSStrings.h"
#import "EPSCMSModel.h"

@implementation EPSCMSStrings
+ (NSDictionary *)getCMSIndicationStrings {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 [NSNumber numberWithInt:Primary]: @"Primary Prevention",
                 [NSNumber numberWithInt:Secondary]: @"Secondary Prevention",
                 [NSNumber numberWithInt:Other]: @"Other Indication"
                 };
    });
    return dict;
}

+ (NSDictionary *)getCMSApprovalStrings {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 [NSNumber numberWithInt:Approved]: @"ICD implantation appears to meet CMS guidelines.",
                 [NSNumber numberWithInt:NotApproved]: @"ICD implantation does NOT meet CMS guidelines.",
                 [NSNumber numberWithInt:ApprovalUnclear]: @"Not enough information to determine if ICD is indicated."
                 };
    });
    return dict;
}

+ (NSDictionary *)getCMSDetailsStrings {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 [NSNumber numberWithInt:AbsoluteExclusion]: @"There are one or more absolute exclusions to ICD implantation.",
                 [NSNumber numberWithInt:NoIndications]: @"No ICD indications have been selected.  Use the checkboxes to select an indication.",
                 [NSNumber numberWithInt:NoEF]: @"Note that all ICD candidates must have left ventricular EF measured by echocardiography, radionuclide (nuclear medicine) imaging, cardiac magnetic resonance imaging (MRI), or catheter angiography. Select an EF range and try again.",
                 [NSNumber numberWithInt:NoNyha]: @"You must select a NYHA class.",
                 [NSNumber numberWithInt:WaitingPeriodException]: @"Waiting periods (CABG or PCI within 3 months, MI within 40 days) do not apply in this circumstance.",
                 [NSNumber numberWithInt:NeedsWaitingPeriod]: @"It is necessary to delay implantation until waiting period expires (40 days post-MI, 3 months post CABG or PCI). Note that if a pacemaker is indicated or the patient has an ICD at ERI or with lead/device malfunction, ICD implantation CAN proceed before waiting period expires.",
                 [NSNumber numberWithInt:CandidateForRevasc]: @"ICD implantation not indicated in candidate for revascularization.",
                 [NSNumber numberWithInt:ForgotIcm]: @"You selected MI and patient has Class II or III heart failure.  Did you forget to select ischemic or nonischemic cardiomyopathy?",
                 [NSNumber numberWithInt:ForgotMI]: @"You selected ICM and patient has low EF but only Class I heart failure.  Did you forget to select prior MI?",
                 [NSNumber numberWithInt:BridgeToTransplant]: @"Coverage of ICDs as a bridge to transplant is determined by local Medicare Administrative Contractors (MACs)."
                 };
    });
    return dict;
}


//Primary,
//Secondary,
//Other,
//IndicationNone
@end

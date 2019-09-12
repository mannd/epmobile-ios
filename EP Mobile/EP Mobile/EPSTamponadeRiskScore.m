//
//  EPSTamponadeRiskScore.m
//  EP Mobile
//
//  Created by David Mann on 8/23/18.
//  Copyright © 2018 EP Studios. All rights reserved.
//

#import "EPSTamponadeRiskScore.h"
#import "EPSRiskFactor.h"
#import "EPSSharedMethods.h"

@implementation EPSTamponadeRiskScore

-(NSString *)getTitle {
    return @"Cardiac Tamponade";
}

- (NSString *)getReference {
    return @"Risti AD, Imazio M, Adler Y, et al. Triage strategy for urgent management of cardiac tamponade: a position statement of the European Society of Cardiology Working Group on Myocardial and Pericardial Diseases. European Heart Journal. 2014;35(34):2279-2284. doi:10.1093/eurheartj/ehu217";
}

// TODO: confirm this link
- (NSURL *)getReferenceLink {
    return [[NSURL alloc] initWithString:@"https://doi.org/10.1093/eurheartj/ehu217"];
}

- (NSMutableArray *)getArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // Note original points multiplied by 10 to avoid floating point numbers
    // Etiology
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Malignant disease" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Tuberculosis" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Recent radiotherapy" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Recent viral infection" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Recurrent PE, previous pericardiocentesis" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Chronic terminal renal failure" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Immunodeficiency or immunosuppression" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Hypo- or hyperthyroidism" withValue:-10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Systemic autoimmune disease" withValue:-10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Dyspnea/Tachypnea" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Orthopnea (NO rales on lung auscultation" withValue:30]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Hypotension (SBP < 95 mmHg" withValue:5]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Progressive sinus tachycardia (no meds affecting HR, hypothyroidism or uremia)" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Oliguria" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Pulsus paradoxus > 10 mmHg" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Pericardial chest pain" withValue:5]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Pericardial friction rub" withValue:5]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Rapid worsening of symptoms" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Slow evolution of disease" withValue:-10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Cardiomegaly on CXR" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Electrical alternans on ECG" withValue:5]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Microvoltage in ECG" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Circumferential PE (> 2 cm in diastole)" withValue:30]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Moderate PE (1-2 cm in diastole)" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Small PE (< 1 cm in diastole), no trauma" withValue:-10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Right atrial collapse > 1/3 of cardiac cycle" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"IVC > 2.5 cm, < 50% inspiratory collapse" withValue:15]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Right ventricular collapse" withValue:15]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Left atrial collapse" withValue:20]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Mitral/tricuspid respiratory flow variations" withValue:10]];
    [array addObject:[[EPSRiskFactor alloc] initWithDetailsOnly:@"Swinging heart" withValue:10]];
    return array;
}

- (int)calculateScore:(NSMutableArray *)risks {
    return [super calculateScore:risks];
}

// Overriden from EPSRiskScore to use risk details instead of name
- (NSArray *)risksSelected:(NSArray *)risks {
    if ([risks count] == 0) {
        return nil;
    }
    NSMutableArray *selected = [[NSMutableArray alloc] init];
    for (int i = 0; i < [risks count]; ++i) {
        if ([(EPSRiskFactor *)[risks objectAtIndex:i] isSelected] == YES) {
            [selected addObject:[[risks objectAtIndex:i] details]];
        }
    }
    return selected;
}

- (NSString *)getMessage:(int)score {
    double riskScore = score / 10.0;
    NSString *message = [NSString stringWithFormat:@"Risk score = %@\n", [EPSSharedMethods trimmedZerosFromNumber:riskScore]];
    if (riskScore >= 6) {
        message = [message stringByAppendingString:[NSString stringWithFormat:@"Urgent pericardiocentesis is indicated (risk score ≥ 6) immediately after contraindications are ruled-out.  Contraindications include uncorrected coagulopathy, anticoagulant therapy with INR > 1.5, thrombocytopenia < 50%@000/mm³, small, posterior, and loculated effusions, or effusions resolving under anti-inflammatory treatment.", [NSLocale currentLocale].groupingSeparator]];
    }
    else {
        message = [message stringByAppendingString:@"Pericardiocentesis can be postponed for up to 12/48 hours (risk score < 6)."];
    }
    message = [message stringByAppendingString:@"\n\n*** NOTE ***\nUrgent surgical management is indicated regardless of the score for:\n 1. Type A aortic dissection \n2. Ventricular free wall rupture after acute myocardial infarction \n3. Severe recent chest trauma \n4. Iatrogenic hemopericardium when the bleeding cannot be controlled percutaneously"];
    return message;
}

- (int)numberOfSections {
    return 3;
}

- (int)numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 9;
    else if (section == 1)
        return 10;
    else if (section == 2)
        return 12;
    else
        return 0;
}

// Each section starts this number of rows after the start of the array
- (int)getOffset:(NSInteger)section {
    if (section == 1)
        return 9;
    else if (section == 2)
        return 19;
    else
        return 0;
}

- (CGFloat)rowHeight:(CGFloat)defaultHeight {
    //return defaultHeight + 50.0;
    return defaultHeight;
}

- (int)detailTextNumberOfLines {
    return 3;
}

- (NSString *)getTitleForHeaderSection:(NSInteger)section {
    if (section == 0)
        return @"Etiology";
    else if (section == 1)
        return @"Clinical Presentation";
    else if (section == 2)
        return @"Imaging";
    else
        return nil;
}

@end

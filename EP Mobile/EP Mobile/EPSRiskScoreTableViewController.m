//
//  EPSRiskScoreTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSRiskScoreTableViewController.h"
#import "EPSRiskFactor.h"

// used to distinguish specially handled risk factor in HCM
#define HIGHEST_RISK_SCORE 100
// the 2 mutually exclusive CHADS-VASc risk that must be dealt with specially
#define CHADS_VASC_AGE_75 2
#define CHADS_VASC_AGE_65 6

// the 2 mutually exclusive ESTES risks
#define ESTES_STRAIN_WITH_DIG 1
#define ESTES_STRAIN_WITHOUT_DIG 2

@interface EPSRiskScoreTableViewController ()

@end

@implementation EPSRiskScoreTableViewController
@synthesize risks;
@synthesize scoreType;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([scoreType isEqualToString:@"Chads2"]) {
        self.title = @"CHADS\u2082";
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Congestive heart failure" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP ≥ 140/90 or treated HTN"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Stroke history" withValue:2 withDetails:@"or TIA or thromboembolism"]];
    }
    else if ([scoreType isEqualToString:@"ChadsVasc"]) {
        self.title = @"CHA\u2082DS\u2082-VASc";
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Congestive heart failure" withValue:1 withDetails:@"or left ventricular systolic dysfunction"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP ≥ 140/90 or treated HTN"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 75 years" withValue:2]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Diabetes mellitus" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Stroke history" withValue:2 withDetails:@"or TIA or thromboembolism"]];        
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Vascular disease" withValue:1 withDetails:@"e.g. PAD, MI, aortic plaque"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Age ≥ 65 years" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Sex category" withValue:1 withDetails:@"i.e. female gender"]];        
        
    }
    else if ([scoreType isEqualToString:@"HasBled"]) {
        self.title = @"HAS-BLED";
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"systolic BP ≥ 160"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Abnormal renal function" withValue:1 withDetails:@"dialysis, kidney transplant, Cr ≥ 2.6 mg/dL"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Abnormal liver function" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Stroke history" withValue:1]];   
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Bleeding history" withValue:1 withDetails:@"or anemia or predisposition to bleeding"]];
   
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Labile INR" withValue:1 withDetails:@"unstable, high or < 60%  therapeutic INRs"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Elderly" withValue:1 withDetails:@"65 years or older"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Drugs" withValue:1 withDetails:@"taking antiplatlet drugs like ASA or clopidogrel"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Alcohol" withValue:1 withDetails:@"8 or more alcoholic drinks per week"]];
    }
    else if ([scoreType isEqualToString:@"Hemorrhages"]) {
        self.title = @"HEMORR\u2082HAGES";
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hepatic or renal disease" withValue:1 withDetails:@"cirrhosis, 2x AST/ALT, alb < 3.6, CrCl < 30"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Ethanol use" withValue:1 withDetails:@"EtOH abuse, EtOH related illness"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Malignancy" withValue:1 withDetails:@"recent metastatic cancer"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Older" withValue:1 withDetails:@"Age > 75 years"]];   
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Reduced platelet count or function" withValue:1 withDetails:@"plts < 75K, antiplatelet drugs"]];
        
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Rebleeding" withValue:2 withDetails:@"prior bleed requiring hospitalizaiton"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Hypertension" withValue:1 withDetails:@"BP not currently controlled, > 160"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Anemia" withValue:1 withDetails:@"most recent Hct < 30, Hgb < 10"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Genetic factors" withValue:1 withDetails:@"CYP2C9*2 and/or CYP2C9*3"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Elevated fall risk" withValue:1 withDetails:@"e.g. Alzheimer, Parkinson, schizophrenia"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Stroke" withValue:1]];
        
        
    }
    else if ([scoreType isEqualToString:@"HCM"]) {
        self.title = @"Hypertrophic CM";
        // Major criteria
        // will be able to tease out major and minor because major 1 order of magnitude higher
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Cardiac arrest" withValue:10]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Spontaneous sustained VT" withValue:10 ]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Family history" withValue:10 withDetails:@"of premature sudden death"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Unexplained syncope" withValue:10]];          
        [array addObject:[[EPSRiskFactor alloc] initWith:@"LV thickness ≥ 3 cm" withValue:10]];  
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Abnormal BP response to exercise" withValue:10 withDetails:@"failure of BP to rise with exercise"]];
        
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Nonsustained VT" withValue:10]];
        // Minor criteria
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Atrial fibrillation" withValue:1]];  
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Myocardial ischemia" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"LV outflow obstruction" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"High risk mutation" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Elevated fall risk" withValue:1 withDetails:@"e.g. Alzheimer, Parkinson, schizophrenia"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Stroke" withValue:1]];          
    }
    else if ([scoreType isEqualToString:@"Estes"]) {
        self.title = @"Estes LVH Score";
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Any limb-lead R or S \u2265 20 mm or S V1 or V2 \u2265 30 mm or R V5 or V6 \u2265 30 mm" withValue:3]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Left ventricular strain pattern without digitalis" withValue:3 withDetails:@"ST-J point depression \u2265 1 mm & inverted T in V5"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Left ventricular strain pattern with digitalis" withValue:1 withDetails:@"ST-J point depression \u2265 1 mm & inverted T in V5"]];
        [array addObject:[[EPSRiskFactor alloc] initWithDetails:@"Left atrial enlargement" withValue:3 withDetails:@"P terminal force in V1 \u2265 1 mm & \u2265 40 msec"]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Left axis deviation \u2265 -30\u00b0" withValue:2]];
                [array addObject:[[EPSRiskFactor alloc] initWith:@"QRS duration \u2265 90 msec" withValue:1]];
        [array addObject:[[EPSRiskFactor alloc] initWith:@"Intrinsicoid QRS deflection of \u2265 50 msec in V5 or V6" withValue:1]];
    }
    self.risks = array;
 
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.risks = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)calculateScore {
    // handle mutually exclusive Estes scores
    if ([scoreType isEqualToString:@"Estes"]) {
        if ([[self.risks objectAtIndex:ESTES_STRAIN_WITH_DIG] selected] && [[self.risks objectAtIndex:ESTES_STRAIN_WITHOUT_DIG] selected]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have selected strain pattern with and without digitalis.  Please select one or the other, not both." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    int score = 0;
    for (int i = 0; i < [self.risks count]; ++i)
        if ([[self.risks objectAtIndex:i] selected] == YES)
            score += [[self.risks objectAtIndex:i] points];
    // adjust for duplicate age entry in ChadsVasc
    if ([scoreType isEqualToString:@"ChadsVasc"]) {
        if ([[self.risks objectAtIndex:CHADS_VASC_AGE_65] selected] && [[self.risks objectAtIndex:CHADS_VASC_AGE_75] selected])
            --score;
    }
    NSString *message = [self getResultsMessage:score];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Risk Score" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    // left justify message
    //((UILabel *)[[alertView subviews] objectAtIndex:1]).textAlignment = UITextAlignmentLeft;
    [alertView show];
}

- (NSString *)getResultsMessage:(int)result {
    NSString *message = [[NSString alloc] init];
    float risk = 0;
    // some risk scores require a string, e.g. HAS-BLED
    NSString *riskString = [[NSString alloc] init];
    NSString *scoreName = [[NSString alloc] init];
    if ([scoreType isEqualToString:@"Chads2"]) {
        switch (result) {
            case 0:
                risk = 1.9;
                break;
            case 1:
                risk = 2.8;
                break;
            case 2:
                risk = 4.0;
                break;
            case 3:
                risk = 5.9;
                break;
            case 4:
                risk = 8.5;
                break;
            case 5:
                risk = 12.5;
                break;
            case 6:
                risk = 18.2;
                break;
        }
        scoreName = @"CHADS\u2082";
    }
    else if ([scoreType isEqualToString:@"ChadsVasc"]) {
		switch (result) {
            case 0:
                risk = 0;
                break;
            case 1:
                risk = 1.3;
                break;
            case 2:
                risk = 2.2;
                break;
            case 3:
                risk = 3.2;
                break;
            case 4:
                risk = 4.0;
                break;
            case 5:
                risk = 6.7;
                break;
            case 6:
                risk = 9.8;
                break;
            case 7:
                risk = 9.6;
                break;
            case 8:
                risk = 6.7;
                break;
            case 9:
                risk = 15.2;
                break;
		}
        scoreName = @"CHA\u2082DS\u2082-VASc";

    }
    else if ([scoreType isEqualToString:@"HasBled"]) {
		if (result < 3)
            message = @"Low bleeding risk";
        else 
            message = @"High bleeding risk";
        switch (result) {
            case 0:
            case 1:
                riskString = @"1.02-1.13";
                break;
            case 2:
                riskString = @"1.88";
                break;
            case 3:
                riskString = @"3.74";
                break;
            case 4:
                riskString = @"8.70";
                break;
            case 5:
                riskString = @"12.50";
                break;
            case 6:
            case 7:
            case 8:
            case 9:
                riskString = @"> 12.50";
                break;
        }
        message = [[NSString alloc] initWithFormat:@"HAS-BLED score = %d\n%@\nBleeding risk is %@ bleeds per 100 patient-years", result, message, riskString];
        
    }
    else if ([scoreType isEqualToString:@"Hemorrhages"]) {
        if (result < 2)
            message = @"Low bleeding risk";
        else if (result < 4)
            message = @"Intermediate bleeding risk";
        else 
            message = @"High bleeding risk";
		switch (result) {
            case 0:
                risk = 1.9;
                break;
            case 1:
                risk = 2.5;
                break;
            case 2:
                risk = 5.3;
                break;
            case 3:
                risk = 8.4;
                break;
            case 4:
                risk = 10.4;
                break;
		}
		if (result >= 5)
			risk = 12.3;        
        message = [[NSString alloc] initWithFormat:@"HEMORR\u2082HAGES score = %d\n%@\nBleeding risk is %1.1f bleeds per 100 patient-years", result, message, risk];        
    }
    else if ([scoreType isEqualToString:@"Estes"]) {
        if (result < 4)
            message = @"Left Ventricular Hypertrophy not present.";
        else if (result == 4)
            message = @"Probable Left Ventricular Hypertrophy.";
        else // result > 4
            message = @"Definite Left Ventricular Hypertrophy.";
        message = [[NSString alloc] initWithFormat:@"Romhilt-Estes score = %d\n%@\n", result, message];          
    }
    else if ([scoreType isEqualToString:@"HCM"]) {
        int minorScore = 0;
        int majorScore = 0;
         // cardiac arrest and VT treated specially 
        if ([[self.risks objectAtIndex:0] selected] || [[self.risks objectAtIndex:1] selected])  
            result = HIGHEST_RISK_SCORE;
        else {
            // extract major and minor risks
            majorScore = result / 10;
            minorScore = result % 10;
            NSLog(@"Major score = %i", majorScore);
            NSLog(@"Minor score = %i", minorScore);
        }
        if (result == HIGHEST_RISK_SCORE)
            message = @"Survivors of cardiac arrest and patients with spontaneous sustained VT are considered at very high risk for SD and are ICD candidates.";
        else {
            message = [[NSString alloc] initWithFormat:@"Major risks = %i\nMinor risks = %i\n", majorScore, minorScore];
            if (majorScore >= 2)
                message = [message stringByAppendingString:@"Patients with 2 or more major risk factors are considered at high risk and should be considered for ICD implantation."];
            else if (majorScore == 1)
                message = [message stringByAppendingString:@"Patients with 1 major risk factor have increased risk for SD and recommendations should be individualized. Factors such as the nature of the risk factor (e.g. SD in an immediate family member), young age (which confers greater risk) and presence of minor risk factors should be considered.  ICD implantation can be considered depending on these factors."];
            else // result == 0
                message = [message stringByAppendingString:@"Patients without any major risk factors (even if minor risk factors are present) are considered to be at low risk for SD. ICD implantation is not recommended."];
        }
    }

    if ([scoreType isEqualToString:@"Chads2"] || [scoreType isEqualToString:@"ChadsVasc"]) { 
        NSString *strokeRisk = [[NSString alloc] initWithFormat:@"Annual stroke risk is %1.1f%%", risk];
        message = [[NSString alloc] initWithFormat:@"%@ score = %d\n%@\n", scoreName, result, strokeRisk];
        if (result < 1) { 
            message = [message stringByAppendingString:@"\nAnti-platelet drug (ASA) or no drug recommended."];
            if ([scoreType isEqualToString:@"Chads2"])
                message = [message stringByAppendingString:@"\n\nConsider using CHA\u2082DS\u2082-VASc score to define stroke risk better."];
        }
        else if (result == 1) {
            message = [message stringByAppendingString:@"\nAnti-platelet drug (ASA) or oral anticoagulation (warfarin, dabigatran or rivaroxaban) recommended."];
            if ([scoreType isEqualToString:@"Chads2"])
                message = [message stringByAppendingString:@"\n\nConsider using CHA\u2082DS\u2082-VASc score to define stroke risk better and using bleeding score (e.g. HAS-BLED) to help choose between ASA and oral anticoagulation."];
            else 
                message = [message stringByAppendingString:@"\n\nConsider assessing bleeding score (e.g. HAS-BLED) to help choose between ASA and anticoagulation."];
        }
        else 
            message = [message stringByAppendingString:@"\nOral anticoagulation (warfarin, dabigatran or rivaroxaban) recommended."];
    }
    return message;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([scoreType isEqualToString:@"HCM"])
        return 2;
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([scoreType isEqualToString:@"HCM"]) {
        if (section == 0)
            return 7;   // 7 major criteria for HCM
        else 
            return 4;   // 4 minor criteria for HCM
    }
    return [risks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([scoreType isEqualToString:@"Estes"])
        return 80;
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChadsCell"];
    // deal with the 2 sectioned HCM risk
    int offset = 0; // use with more than one section
    if ([scoreType isEqualToString:@"HCM"])
        offset = [self calculateOffset:indexPath.section];
    NSString *risk = [[self.risks objectAtIndex:indexPath.row + offset] name];
    NSString *details = [[self.risks objectAtIndex:indexPath.row + offset] details];
    cell.textLabel.text = risk;
    if ([scoreType isEqualToString:@"Estes"]) {
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        //cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.numberOfLines = 0;

    }

    cell.detailTextLabel.text = details;
    if ([[self.risks objectAtIndex:(indexPath.row + offset)] selected] == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    
    return cell;
}

- (int)calculateOffset:(int)section {
    int offset = 0;
    if (section == 1)
        offset = 7;
    return offset;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([scoreType isEqualToString:@"HCM"]) {
        if (section == 0)
            return @"MAJOR";
        else 
            return @"MINOR";
    }
    return nil;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offset = 0; // for HCM
    if ([scoreType isEqualToString:@"HCM"])
        offset = [self calculateOffset:indexPath.section];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[self.risks objectAtIndex:indexPath.row + offset] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
        [[self.risks objectAtIndex:indexPath.row + offset] setSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

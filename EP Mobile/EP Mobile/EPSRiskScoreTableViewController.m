//
//  EPSRiskScoreTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/22/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSRiskScoreTableViewController.h"
#import "EPSRiskFactor.h"
#import "EPSRiskScore.h"
#import "EPSChadsRiskScore.h"
#import "EPSChadsVascRiskScore.h"
#import "EPSHasBledRiskScore.h"
#import "EPSHemorrhagesRiskScore.h"
#import "EPSHcmRiskScore.h"

// the 2 mutually exclusive ESTES risks
#define ESTES_STRAIN_WITH_DIG 1
#define ESTES_STRAIN_WITHOUT_DIG 2

@interface EPSRiskScoreTableViewController ()

@end

@implementation EPSRiskScoreTableViewController {
    EPSRiskScore *riskScore;
}
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
        riskScore = [[EPSChadsRiskScore alloc] init];
        self.title = [riskScore getTitle];
        array = [riskScore getArray];
    }
    else if ([scoreType isEqualToString:@"ChadsVasc"]) {
        riskScore = [[EPSChadsVascRiskScore alloc] init];
        self.title = [riskScore getTitle];
        array = [riskScore getArray];
        
    }
    else if ([scoreType isEqualToString:@"HasBled"]) {
        riskScore = [[EPSHasBledRiskScore alloc] init];
        self.title = [riskScore getTitle];
        array = [riskScore getArray];
    }
    else if ([scoreType isEqualToString:@"Hemorrhages"]) {
        riskScore = [[EPSHemorrhagesRiskScore alloc] init];
        self.title = [riskScore getTitle];
        array = [riskScore getArray];
        
    }
    else if ([scoreType isEqualToString:@"HCM"]) {
        riskScore = [[EPSHcmRiskScore alloc] init];
        self.title = [riskScore getTitle];
        array = [riskScore getArray];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    NSString *message;
    if ([scoreType isEqualToString:@"Chads2"] || [scoreType isEqualToString:@"ChadsVasc"]
        || [scoreType isEqualToString:@"HasBled"] || [scoreType isEqualToString:@"Hemorrhages"]
        || [scoreType isEqualToString:@"HCM"]) {
        score = [riskScore calculateScore:self.risks];
        message = [riskScore getMessage:score];
    }
    else {
        for (int i = 0; i < [self.risks count]; ++i)
        if ([[self.risks objectAtIndex:i] selected] == YES)
            score += [[self.risks objectAtIndex:i] points];
        message = [self getResultsMessage:score];

    }
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Risk Score" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    // left justify message
    //((UILabel *)[[alertView subviews] objectAtIndex:1]).textAlignment = UITextAlignmentLeft;
    [alertView show];
}

- (NSString *)getResultsMessage:(int)result {
    NSString *message = nil;
    NSString *resultMessage = nil;
    if ([scoreType isEqualToString:@"Estes"]) {
        if (result < 4)
            message = @"Left Ventricular Hypertrophy not present.";
        else if (result == 4)
            message = @"Probable Left Ventricular Hypertrophy.";
        else // result > 4
            message = @"Definite Left Ventricular Hypertrophy.";
        resultMessage = [[NSString alloc] initWithFormat:@"Romhilt-Estes score = %d\n%@\n", result, message];
    }
    return resultMessage;

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
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        //cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
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

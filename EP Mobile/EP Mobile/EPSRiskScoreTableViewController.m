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
#import "EPSEstesRiskScore.h"
#import "EPSSfRuleRiskScore.h"
#import "EPSEgsysRiskScore.h"
#import "EPSMartinRiskScore.h"
#import "EPSOesilScore.h"
#import "EPSAtriaBleedRiskScore.h"
#import "EPSSameTtrRiskScore.h"
#import "EPSAtriaStrokeRiskScore.h"
#import "EPSOrbitRiskScore.h"
#import "EPSIcdMortalityRiskScore.h"
#import "EPSSharedMethods.h"

#define COPY_RESULT_BUTTON_NUMBER 1
#define REFERENCE_BUTTON_NUMBER 2
#define LINK_BUTTON_NUMBER 3

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
    NSMutableArray *array;
    if ([scoreType isEqualToString:@"Chads2"]) 
        riskScore = [[EPSChadsRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"ChadsVasc"])
        riskScore = [[EPSChadsVascRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"HasBled"])
        riskScore = [[EPSHasBledRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"Hemorrhages"])
        riskScore = [[EPSHemorrhagesRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"HCM"])
        riskScore = [[EPSHcmRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"Estes"])
        riskScore = [[EPSEstesRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"SfRule"])
        riskScore = [[EPSSfRuleRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"EgsysScore"])
        riskScore = [[EPSEgsysRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"MartinScore"])
        riskScore = [[EPSMartinRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"OesilScore"])
        riskScore = [[EPSOesilScore alloc] init];
    else if ([scoreType isEqualToString:@"AtriaBleed"])
        riskScore = [[EPSAtriaBleedRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"SameTtr"])
        riskScore = [[EPSSameTtrRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"AtriaStroke"])
        riskScore = [[EPSAtriaStrokeRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"Orbit"])
        riskScore = [[EPSOrbitRiskScore alloc] init];
    else if ([scoreType isEqualToString:@"ICDMortalityRisk"])
        riskScore = [[EPSIcdMortalityRiskScore alloc] init];
    self.title = [riskScore getTitle];
    array = [riskScore getArray];
    self.risks = array;
 
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Risk" style:UIBarButtonItemStylePlain target:self action:@selector(calculateScore)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.risks = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// for iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


- (void)calculateScore {
    int score = [riskScore calculateScore:self.risks];
    NSString *message = [riskScore getMessage:score];
    NSArray *risksSelected = [riskScore risksSelected:risks];
    NSString* result = [riskScore getFullRiskReportFromMessage:message andRisks:risksSelected];
    
    [EPSSharedMethods showRiskDialogWithMessage:message riskResult:result reference:[riskScore getReference] url:[riskScore getReferenceLink] inView:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [riskScore numberOfSections];
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = [riskScore numberOfRowsInSection:section];
    if (rows == 0)  // only a single section
        return [self.risks count];
    else
        return rows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [riskScore rowHeight:[super tableView:tableView heightForRowAtIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChadsCell"];
    // deal with the 2 sectioned HCM risk
    int offset = [riskScore getOffset:indexPath.section];
    NSString *risk = [[self.risks objectAtIndex:indexPath.row + offset] name];
    NSString *details = [[self.risks objectAtIndex:indexPath.row + offset] details];
    cell.textLabel.text = risk;
    [riskScore formatCell:cell];

    cell.detailTextLabel.text = details;
    cell.detailTextLabel.numberOfLines = [riskScore detailTextNumberOfLines];
    if ([[self.risks objectAtIndex:(indexPath.row + offset)] selected] == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (int)calculateOffset:(int)section {
    return [riskScore getOffset:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [riskScore getTitleForHeaderSection:section];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offset = [riskScore getOffset:indexPath.section];
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

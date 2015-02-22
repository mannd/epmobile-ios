//
//  EPSMainTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012, 2013, 2014 EP Studios. All rights reserved.
//

#import "EPSMainTableViewController.h"
#import "EPSLinkViewController.h"
#import "EPSRiskScoreTableViewController.h"
#import "EPSDrugDoseCalculatorViewController.h"

#define ALLOW_DRUG_CALCULATORS YES
#define DRUG_CALCULATORS_ROW 2

@interface EPSMainTableViewController ()

@end

@implementation EPSMainTableViewController
{
    BOOL allowDrugCalculators;
}
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
    
    allowDrugCalculators = ALLOW_DRUG_CALCULATORS;
    [self.drugCalculatorCell setHidden:!allowDrugCalculators];

    
}

- (void)showAbout {
    [self performSegueWithIdentifier:@"AboutSegue" sender:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
  
    if (section == 0 && row == DRUG_CALCULATORS_ROW && !allowDrugCalculators)
        return 0; //set the hidden cell's height to 0
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSRiskScoreTableViewController *vc = (EPSRiskScoreTableViewController *)[segue destinationViewController];
    EPSDrugDoseCalculatorViewController *drugDoseViewController = (EPSDrugDoseCalculatorViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"CreatinineClearanceSegue"])
        drugDoseViewController.drug = @"Creatinine Clearance";
    if ([segueIdentifier isEqualToString:@"Chads2Segue"])
        vc.scoreType = @"Chads2";
    else if ([segueIdentifier isEqualToString:@"ChadsVascSegue"])
        vc.scoreType = @"ChadsVasc";
    else if ([segueIdentifier isEqualToString:@"HasBledSegue"])
        vc.scoreType = @"HasBled";
    else if ([segueIdentifier isEqualToString:@"HemorrhagesSegue"])
        vc.scoreType = @"Hemorrhages";
    else if ([segueIdentifier isEqualToString:@"HcmSegue"])
        vc.scoreType = @"HCM";
    EPSLinkViewController *lc = (EPSLinkViewController *)vc;
    if ([segueIdentifier isEqualToString:@"BrugadaDrugsSegue"])
        lc.webPage = @"http://www.brugadadrugs.org";
    else if ([segueIdentifier isEqualToString:@"LongQTDrugsSegue"])
        lc.webPage = @"http://www.crediblemeds.org";
    else if ([segueIdentifier isEqualToString:@"ParaHisSegue"])
        lc.webPage = @"parahisianpacinginstructions";
    else if ([segueIdentifier isEqualToString:@"RVPaceSegue"])
        lc.webPage = @"rvapexvsbasepacing";
    
}


@end

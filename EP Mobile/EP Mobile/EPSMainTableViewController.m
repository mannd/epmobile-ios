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
#import "EPSARVC2010TableViewController.h"

#import "EP_Mobile-Swift.h"

// Sigh!
// TODO: Switch back to NO!!!! for release version
#define ALLOW_DRUG_CALCULATORS YES

// Update as needed.  Remember row 2 is invisible (the banned drug calculators).
#define DATE_CALCULATOR_ROW 1
#define DRUG_CALCULATORS_ROW 2
#define INTERVAL_RATE_ROW 3

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
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == INTERVAL_RATE_ROW) {
        [IntervalRateCalculatorController showWithVc:self];
    }
    if (indexPath.section == 0 && indexPath.row == DATE_CALCULATOR_ROW) {
        [DateCalculatorController showWithVc:self];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSDrugDoseCalculatorViewController *drugDoseViewController = (EPSDrugDoseCalculatorViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"CreatinineClearanceSegue"])
        drugDoseViewController.drug = @"Creatinine Clearance";
    
    EPSRiskScoreTableViewController *vc = (EPSRiskScoreTableViewController *)drugDoseViewController;

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
    else if ([segueIdentifier isEqualToString:@"AtriaBleedSegue"])
        vc.scoreType = @"AtriaBleed";
    else if ([segueIdentifier isEqualToString:@"SameTtrSegue"])
        vc.scoreType = @"SameTtr";
    else if ([segueIdentifier isEqualToString:@"AtriaStrokeSegue"])
        vc.scoreType = @"AtriaStroke";
    else if ([segueIdentifier isEqualToString:@"OrbitSegue"])
        vc.scoreType = @"Orbit";
    else if ([segueIdentifier isEqualToString:@"ICDMortalityRiskSegue"])
        vc.scoreType = @"ICDMortalityRisk";
    else if ([segueIdentifier isEqualToString:@"ERSSegue"])
        vc.scoreType = @"ERSRisk";
    else if ([segueIdentifier isEqualToString:@"TamponadeSegue"])
        vc.scoreType = @"TamponadeRisk";
    else if ([segueIdentifier isEqualToString:@"QTProlongationSegue"])
        vc.scoreType = @"QTProlongationRisk";
    
    EPSLinkViewController *lc = (EPSLinkViewController *)vc;
    if ([segueIdentifier isEqualToString:@"BrugadaDrugsSegue"])
        lc.webPage = @"http://www.brugadadrugs.org";
    else if ([segueIdentifier isEqualToString:@"LongQTDrugsSegue"])
        lc.webPage = @"https://www.crediblemeds.org";
    else if ([segueIdentifier isEqualToString:@"ParaHisSegue"]) {
        lc.webPage = @"parahisianpacinginstructions";
        lc.linkTitle = @"Para-Hisian Pacing";
    }
    else if ([segueIdentifier isEqualToString:@"RVPaceSegue"]) {
        lc.webPage = @"rvapexvsbasepacing";
        lc.linkTitle = @"RV Apex vs Base Pacing";
    }
    else if ([segueIdentifier isEqualToString:@"RvhSegue"]) {
        lc.webPage = @"rvh";
        lc.linkTitle = @"RVH Criteria";
    }
    else if ([segueIdentifier isEqualToString:@"LbbbSegue"]) {
        lc.webPage = @"lbbb";
        lc.linkTitle = @"LBBB Criteria";
    }
  
    EPSARVC2010TableViewController *arvcVc = (EPSARVC2010TableViewController *)vc;
    if ([segueIdentifier isEqualToString:@"ARVC2010Segue"])
        arvcVc.criteria = @"ARVC2010";
    else if ([segueIdentifier isEqualToString:@"ARVC1994Segue"])
        arvcVc.criteria = @"ARVC1994";

}


@end

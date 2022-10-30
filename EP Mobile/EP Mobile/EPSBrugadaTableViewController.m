//
//  EPSBrugadaTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/23/17.
//  Copyright © 2017 EP Studios. All rights reserved.
//

#import "EPSBrugadaTableViewController.h"
#import "EPSLinkViewController.h"
#import "EPSRiskScoreTableViewController.h"
#import "EPSBrugadaRiskScore.h"

#import "EP_Mobile-Swift.h"

// NB: This is hard-wired.  If the Brugada table changes, this will
// need to be changed too.
#define BRUGADA_RISK_ROW 2

@interface EPSBrugadaTableViewController ()

@end

@implementation EPSBrugadaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == BRUGADA_RISK_ROW) {
        [RiskScoreViewController showWithVc:self riskScore:[[EPSBrugadaRiskScore alloc] init]];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"BrugadaDiagnosisSegue"]) {
        EPSLinkViewController *lc = (EPSLinkViewController *)[segue destinationViewController];
        lc.webPage = @"brugadadiagnosis";
        lc.linkTitle = @"Brugada Diagnosis";
        lc.references = [NSArray arrayWithObject:[[Reference alloc] init:@"Priori SG, Wilde AA, Horie M, et al. HRS/EHRA/APHRS Expert Consensus Statement on the Diagnosis and Management of Patients with Inherited Primary Arrhythmia Syndromes: Document endorsed by HRS, EHRA, and APHRS in May 2013 and by ACCF, AHA, PACES, and AEPC in June 2013. Heart Rhythm. 2013;10(12):1932-1963.\ndoi:10.1016/j.hrthm.2013.05.014"]];
    }
}


@end

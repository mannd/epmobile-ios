//
//  EPSSyncopeRiskViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/7/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSSyncopeRiskViewController.h"
#import "EPSEgsysRiskScore.h"
#import "EPSMartinRiskScore.h"
#import "EPSOesilScore.h"
#import "EPSSfRuleRiskScore.h"
#import "EP_Mobile-Swift.h"

#define EGSYS_ROW 0
#define MARTIN_ROW 1
#define OESIL_ROW 2
#define SF_RULE_ROW 3

@interface EPSSyncopeRiskViewController ()

@end

@implementation EPSSyncopeRiskViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case EGSYS_ROW:
            [RiskScoreViewController showWithVc:self riskScore:[EPSEgsysRiskScore new]];
            break;
        case MARTIN_ROW:
            [RiskScoreViewController showWithVc:self riskScore:[EPSMartinRiskScore new]];
            break;
        case OESIL_ROW:
            [RiskScoreViewController showWithVc:self riskScore:[EPSOesilScore new]];
            break;
        case SF_RULE_ROW:
            [RiskScoreViewController showWithVc:self riskScore:[EPSSfRuleRiskScore new]];
            break;
        default:
            break;
    }
}

@end

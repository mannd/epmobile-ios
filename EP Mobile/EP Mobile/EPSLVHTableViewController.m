//
//  EPSLVHTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/8/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSLVHTableViewController.h"
#import "EPSRiskScoreTableViewController.h"
#import "EPSEstesRiskScore.h"

#import "EP_Mobile-Swift.h"

#define ESTES_ROW 1

@interface EPSLVHTableViewController ()

@end

@implementation EPSLVHTableViewController

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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ESTES_ROW) {
        [RiskScoreViewController showWithVc:self riskScore:[[EPSEstesRiskScore alloc] init]];
    }
}

@end

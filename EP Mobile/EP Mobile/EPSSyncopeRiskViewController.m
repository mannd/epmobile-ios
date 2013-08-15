//
//  EPSSyncopeRiskViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/7/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSSyncopeRiskViewController.h"
#import "EPSRiskScoreTableViewController.h"

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

// for iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSRiskScoreTableViewController *vc = (EPSRiskScoreTableViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"EgsysScoreSegue"])
        vc.scoreType = @"EgsysScore";
    else if ([segueIdentifier isEqualToString:@"MartinScoreSegue"])
        vc.scoreType = @"MartinScore";
    else if ([segueIdentifier isEqualToString:@"OesilScoreSegue"])
        vc.scoreType = @"OesilScore";
    else if ([segueIdentifier isEqualToString:@"SfRuleSegue"])
        vc.scoreType = @"SfRule";
}



@end
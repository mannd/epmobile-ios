//
//  EPSWPWTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/19/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWPWTableViewController.h"
#import "EPSSimpleAlgorithmViewController.h"

@interface EPSWPWTableViewController ()

@end

@implementation EPSWPWTableViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"ArrudaSegue"])
        vc.algorithmName = @"ArrudaWPW";
    else if ([segueIdentifier isEqualToString:@"MilsteinSegue"])
        vc.algorithmName = @"MilsteinWPW";
    else if ([segueIdentifier isEqualToString:@"ModifiedArrudaSegue"])
        vc.algorithmName = @"ModifiedArrudaWPW";
    else if ([segueIdentifier isEqualToString:@"DavilaSegue"])
        vc.algorithmName = @"DavilaWPW";
}

@end

//
//  EPSWCTTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 10/17/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSWCTTableViewController.h"
#import "EPSSimpleAlgorithmViewController.h"

@interface EPSWCTTableViewController ()

@end

@implementation EPSWCTTableViewController

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
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"BrugadaAlgorithmSegue"]) {
        EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
        vc.algorithmName = @"BrugadaWCT";
    }
    else if ([segueIdentifier isEqualToString:@"VereckeiAlgorithmSegue"]) {
        EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
        vc.algorithmName = @"VereckeiWCT";
    }
}

@end

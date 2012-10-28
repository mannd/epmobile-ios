//
//  EPSLVHTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/8/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSLVHTableViewController.h"
#import "EPSRiskScoreTableViewController.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSRiskScoreTableViewController *vc = (EPSRiskScoreTableViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"EstesSegue"])
        vc.scoreType = @"Estes";
 }



@end

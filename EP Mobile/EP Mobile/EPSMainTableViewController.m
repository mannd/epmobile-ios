//
//  EPSMainTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 7/14/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSMainTableViewController.h"
#import "EPSRiskScoreTableViewController.h"

@interface EPSMainTableViewController ()

@end

@implementation EPSMainTableViewController

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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showAbout {
    [self performSegueWithIdentifier:@"AboutSegue" sender:nil];
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
}


@end

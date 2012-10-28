//
//  EPSVTViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/30/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSVTViewController.h"
#import "EPSSimpleAlgorithmViewController.h"

@interface EPSVTViewController ()

@end

@implementation EPSVTViewController

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
    EPSSimpleAlgorithmViewController *vc = (EPSSimpleAlgorithmViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"OutflowVTSegue"])
        vc.algorithmName = @"OutflowVT";
    else if ([segueIdentifier isEqualToString:@"AnnularVTSegue"])
        vc.algorithmName = @"AnnularVT";
}


@end

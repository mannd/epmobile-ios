//
//  EPSARVCTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 9/21/12.
//  Copyright (c) 2012 EP Studios. All rights reserved.
//

#import "EPSARVCTableViewController.h"
#import "EPSARVC2010TableViewController.h"

@interface EPSARVCTableViewController ()

@end

@implementation EPSARVCTableViewController

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

// for iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EPSARVC2010TableViewController *vc = (EPSARVC2010TableViewController *)[segue destinationViewController];
    NSString *segueIdentifier = [segue identifier];
    if ([segueIdentifier isEqualToString:@"ARVC2010Segue"])
        vc.criteria = @"ARVC2010";
    else if ([segueIdentifier isEqualToString:@"ARVC1994Segue"])
        vc.criteria = @"ARVC1994";
}


@end

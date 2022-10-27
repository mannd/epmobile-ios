//
//  EPSLQTSTableViewController.m
//  EP Mobile
//
//  Created by David Mann on 8/13/13.
//  Copyright (c) 2013 EP Studios. All rights reserved.
//

#import "EPSLQTSTableViewController.h"
#import "EPSTabBarViewController.h"

@interface EPSLQTSTableViewController ()

@end

@implementation EPSLQTSTableViewController

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

    EPSTabBarViewController *vc = (EPSTabBarViewController *)[segue destinationViewController];

    if ([segueIdentifier isEqualToString:@"LQTSSubtypesSegue"]) {
        vc.references =  [NSArray arrayWithObject:[[Reference alloc] init:@"Adler A, Novelli V, Amin AS, et al. An International, Multicentered, Evidence-Based Reappraisal of Genes Reported to Cause Congenital Long QT Syndrome. Circulation. 2020;141(6):418-428. doi:10.1161/CIRCULATIONAHA.119.043132"]];
        vc.name = @"LQTS Subtypes";
    }

}

@end
